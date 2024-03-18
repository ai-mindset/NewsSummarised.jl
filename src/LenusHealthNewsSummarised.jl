module LenusHealthNewsSummarised
include("ScrapeLenusHealthNews.jl")
include("Summarise.jl")

##
const PROJECT_ROOT::String = @__DIR__
const MODEL::String = "mistral"
const NEWS_DIR::String = "news"

##
function julia_main()::String
    if (@__DIR__) != PROJECT_ROOT
        cd(PROJECT_ROOT)
    end
    if !isdir(NEWS_DIR)
        mkdir(NEWS_DIR)
    end
    cd(NEWS_DIR)
    urls::Vector{String} = ScrapeLenusHealthNews.grab_news_urls()

    all_news::Vector{String} = []
    for url in urls
        title = split(url, "/")[end-1] * "-summary"
        webpage_text::String = ScrapeLenusHealthNews.extract_text_from_url(url)
        push!(all_news, webpage_text)
        segmented::Dict{Int64,String} = Summarise.segment_input(webpage_text)
        summaries::Vector{String} = Summarise.summarise_text(MODEL, segmented)
        file = open(title * ".txt", "a")
        for s in summaries
            write(file, s)
        end
        close(file)
    end

    # Summarise the summaries to get a final insight of the company's activities over their existence
    final_summary::Vector{String} = Summarise.master_summary(MODEL)

    cd(PROJECT_ROOT)

    return final_summary

end



end # module LenusHealthNewsSummarised
