module LenusHealthNewsSummarised
include("ScrapeNews.jl")
include("Summarise.jl")

urls::Vector{String} = ScrapeNews.grab_news_urls()

all_news::Vector{String} = []
for url in urls[1:2]
    webpage_text::String = ScrapeNews.extract_text_from_url(url)
    push!(all_news, webpage_text)
    segmented::Dict{Int64,String} = Summarise.segment_input([webpage_text])
    summaries::Vector{String} = Summarise.summarise_text("mistral", segmented)
end


end # module LenusHealthNewsSummarised
