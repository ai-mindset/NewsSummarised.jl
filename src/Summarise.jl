module Summarise
include("OllamaAI.jl")

##
# Imports
using HTTP, JSON

##
# Globals
# Shortest context window, to account for smaller models
const CONTEXT_TOKENS = 4192
# Approximate count, based on OpenAI documentation
const CONTEXT_WORDS = round(Int64, CONTEXT_TOKENS * 0.75)

##
"""
    word_and_token_count(vector::Vector{String})

Approximately count the total number of tokens in a vector of strings.
1 token = 0.75 words per [OpenAI API documentation](https://platform.openai.com/docs/introduction)

# Arguments
- `vector::Vector{String}`: A vector of strings.

# Returns
- `Int64`: The total number of tokens in the vector of strings
- `Int64`: The total number of words in the vector of strings
"""
function word_and_token_count(text::String)::Tuple{Int64,Int64}
    token_estimate::Float64 = 0
    total_words::Int64 = 0

    words = split(text)
    total_words = length(words)
    token_estimate = total_words / 0.75

    return round(Int64, token_estimate), total_words
end

##
"""
    segment_input(vector::Vector{String})
Segment text into `$(CONTEXT_WORDS)\` word chunks.
Chunk length is calculated using the token = 0.75 word conversion,
according to [OpenAI API documentation](https://platform.openai.com/docs/introduction).

# Arguments
- `text::String`: A string of text

# Returns
- `Dict{Int64, String}`: Chunks `text` has been divided into
"""
function segment_input(text::String)::Dict{Int64,String}
    # TODO: Improve
    d = Dict{Int64,String}()
    no_tokens, _ = word_and_token_count(text)
    folds::Int64 = ceil(Int, no_tokens / CONTEXT_TOKENS)
    text_vec::Vector{SubString{String}} = split(text)
    len_text_vec::Int64 = length(text_vec)
    last_chunk_len::Int64 = len_text_vec % CONTEXT_WORDS

    for i in range(stop=folds)
        local window
        if folds > 1
            window::UnitRange{Int64} = i:CONTEXT_WORDS-1
            if i == folds
                window = window[end]+1:window[end]+last_chunk_len
            end
        else
            window = i:len_text_vec
        end
        vec::Vector{SubString{String}} = text_vec[window]
        chunk::String = join(vec, " ")
        no_tokens, _ = word_and_token_count(chunk)
        d[no_tokens] = chunk
    end

    return d
end

##
"""
    summarise_text(model::String, chunks::Dict{Int64,String})::Vector{String}

# Arguments
- `model::String`: LLM model to use for summarising text. Make sure it's already downloaded locally
- `chunks::Dict{Int64,String}`: Segmented text (when longer than context window) as output from `segment_input()`

# Returns
- `summaries::Vector{String}`: Summary of each text chunk of text, as divided by `segment_input()`
"""
function summarise_text(model::String, chunks::Dict{Int64,String})::Vector{String}
    local summaries = Vector{String}()
    local url = "http://localhost:11434/api/generate"
    for (_, v) in chunks
        prompt = "Transcript excerpt: $v"
        prompt *= """\nSummarise the most important points in the news bulletin above.
            Only return the summary, wrapped in single quotes (' '), and nothing else.
            Be concise"""
        request = OllamaAI.send_request(prompt, model)
        res = HTTP.request("POST", url, [("Content-type", "application/json")], request)
        if res.status == 200
            body = JSON.parse(String(res.body))
            push!(summaries, body["response"])
        else
            println("LLM returned status $(res.status)")
        end
    end

    return summaries
end

end
