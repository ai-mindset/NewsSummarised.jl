module NewsSummarised
include("ScrapeLenusHealthNews.jl")
include("Summarise.jl")

##
# Imports
using Glob

##
const PROJECT_ROOT::String = @__DIR__
const MODEL::String = "mistral"
const NEWS_DIR::String = "news"
const FINAL_FILE::String = "final-summary.txt"

##
function julia_main()::Vector{String}
    if (@__DIR__) != PROJECT_ROOT
        cd(PROJECT_ROOT)
    end
    if !isdir(NEWS_DIR)
        mkdir(NEWS_DIR)
    end

    cd(NEWS_DIR)

    # TODO: [Issue #4](https://github.com/inferential/LenusHealthNewsSummarised.jl/issues/4)
    # If "news/" is empty, access and summarise all currently available articles
    if Glob.readdir(Glob.glob"*.txt", ".") == String[]
        urls::Vector{String} = ScrapeLenusHealthNews.grab_news_urls()

        all_news::Vector{String} = []
        for url in urls
            title = split(url, "/")[end-1] * "-summary"
            webpage_text::String = ScrapeLenusHealthNews.extract_text_from_url(url)
            push!(all_news, webpage_text)
            segmented::Dict{Int64,String} = Summarise.segment_input(webpage_text)
            summaries::Vector{String} = Summarise.summarise_text(MODEL, segmented, title)
            file = open(title * ".txt", "a")
            for s in summaries
                write(file, s)
            end
            close(file)
        end
    end

    if !isfile(FINAL_FILE)
        # Summarise the summaries to get a final insight of the company's activities throughout their existence
        final_summary::Vector{String} = Summarise.master_summary(MODEL, FINAL_FILE)
    else
        f = open(FINAL_FILE)
        final_summary = [read(f, String)]
    end

    cd(PROJECT_ROOT)

    return final_summary

end

@time begin
    final = julia_main()
    println(join(final, " "))
end

end # module NewsSummarised
