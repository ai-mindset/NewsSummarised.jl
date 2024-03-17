module LenusHealthNewsSummarised
include("ScrapeNews.jl")
include("Summarise.jl")

urls::Vector{String} = ScrapeNews.grab_news_urls()
url = urls[end-2] # "https://lenushealth.com/news/what-is-preventive-healthcare/"

all_news::Vector{String} = []
for url in urls[end-1:end]
    title = split(url, "/")[end-1] * "-summary"
    webpage_text::String = ScrapeNews.extract_text_from_url(url)
    push!(all_news, webpage_text)
    segmented::Dict{Int64,String} = Summarise.segment_input(webpage_text)
    summaries::Vector{String} = Summarise.summarise_text("mistral", segmented)
    file = open(title * ".txt", "a")
    for s in summaries
        write(file, s)
    end
    close(file)
end


end # module LenusHealthNewsSummarised
