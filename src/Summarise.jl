module Summarise
include("OllamaAI.jl")

##
# Imports
using HTTP: request
using JSON: parse
using Glob: glob

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
    # How many batches should the text be divided to, to fit context
    no_batches::Int64 = ceil(Int, no_tokens / CONTEXT_TOKENS)
    # Split text string to vector of individual words
    text_vec::Vector{SubString{String}} = split(text)
    text_vec_length::Int64 = length(text_vec)
    last_chunk_length::Int64 = text_vec_length % CONTEXT_WORDS

    for i in range(stop=no_batches)
        local window
        if no_batches > 1
            window::UnitRange{Int64} = i:CONTEXT_WORDS-1
            if i == no_batches
                window = window[end]+1:window[end]+last_chunk_length
            end
        else
            window = i:text_vec_length
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
    summarise_text(model::String, chunks::Dict{Int64,String}, stage::String)::Vector{String}

# Arguments
- `model::String`: LLM model to use for summarising text. Make sure it's already downloaded locally
- `chunks::Dict{Int64,String}`: Segmented text (when longer than context window) as output from `segment_input()`
- `stage::String`: Description of the stage of the process e.g. "Final summary". This is used
for printing information on the terminal

# Returns
- `summaries::Vector{String}`: Summary of each text chunk of text, as divided by `segment_input()`
"""
function summarise_text(model::String, chunks::Dict{Int64,String}, stage::String)::Vector{String}
    local summaries = Vector{String}()
    local url = "http://localhost:11434/api/generate"
    for (_, v) in chunks
        prompt = "Transcript excerpt: $v"
        prompt *= """\nSummarise the news bulletin above and highlight its most important points.
            Only return the summary, wrapped in single quotes (' '), and nothing else.
            Be precise."""
        req = OllamaAI.send_request(prompt, model, stage)
        res = request("POST", url, [("Content-type", "application/json")], req)
        if res.status == 200
            body = parse(String(res.body))
            push!(summaries, body["response"])
        else
            println("LLM returned status $(res.status)")
        end
    end

    return summaries
end

##
"""
   is_empty(filename::String)::Bool

Check if `filename` file is empty

# Arguments
- `filename::String`: Filename we'd like to Check

# Returns
- `is_empty::Bool`: Flag indicating if `filename` is empty. True = empty, False = is populated
"""
function is_empty(filename::String)::Bool
    local is_empty::Bool = false

    open(filename) do file
        content::String = read(file, String)
        if content == ""
            is_empty = true
        end
    end

    return is_empty

end


##
"""
    master_summary(model::String)::Vector{String}

# Arguments
- `model::String`: LLM model to use for summarising text. Make sure it's already downloaded locally
- `final_file::String`: Filename of final summary text file

# Returns
- `final_summary::Vector{String}`: Summary of all summaries, to extract the overarching theme
"""
function master_summary(model::String, final_file::String)::Vector{String}
    # Given we've navigated to `./news`, list .txt files
    file_list::Vector{String} = glob("*.txt")
    file = "merged-summaries.txt"
    out_file::IOStream = open(file, "a")

    prompt = "The following paragraphs summarise the company's activity since 2018.
    The company has been exploring aspects of healthcare, ways to improve patient outcomes,
    prevent and diagnose illness in a timely manner.
    Here is how the company has explored the British healthcare space:\n\n
    "
    write(out_file, prompt)
    for txt in file_list
        file_title::String = replace(basename(txt), "-" => " ")
        file_title = replace(file_title, ".txt" => "")
        file_content = read(txt, String)
        write(out_file, "This section describes $file_title:\n$file_content\n\n")
    end
    final_statement = "With the above in mind, explain to me step by step the most important
    projects, milestones, activities and outcomes the company has achieved over the years.
    Be precise. Avoid repetition. Use correct grammar. Return a summary that flows,
    to help the reader get a global overview of the company's achievements and focus."
    write(out_file, final_statement)
    close(out_file)

    c::Dict{Int64,String} = segment_input(read(file, String))
    final_summary::Vector{String} = summarise_text(model, c, "Final summary")
    f = open(final_file, "a")
    write(f, join(final_summary, " "))
    close(f)

    return final_summary

end

end
