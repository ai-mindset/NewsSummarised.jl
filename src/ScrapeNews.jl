module ScrapeNews
using HTTP
using Gumbo
using Cascadia

"""

"""
function grab_news_urls(; url::String="https://lenushealth.com")::Vector{String}
    r = HTTP.get(url * "/news")
    h = parsehtml(String(r.body))
    root = h.root
    head = h.root[1]
    body = h.root[2]

    news = eachmatch(Selector(".news-card"), h.root)
    news_urls::Vector{String} = []
    for entry in news
        entry_url::String = entry.attributes["href"]
        push!(news_urls, url * entry_url)
    end

    return news_urls

end

"""

"""
function extract_text_from_url(url::String)::String
    r = HTTP.get(url)
    h = parsehtml(String(r.body))
    root = h.root
    head = h.root[1]
    body = h.root[2]

    article = eachmatch(Selector(".article__editor"), root)
    extracted_text::Vector{String} = []
    for elem in article
        for par in elem.children
            c = par.children[1]
            if c isa HTMLElement && !isa(c, HTMLElement{:br})
                push!(extracted_text, c.children[1].text)
            elseif c isa HTMLNode && !isa(c, HTMLElement{:br})
                push!(extracted_text, c.text)
            end
        end
    end

    return join(extracted_text)
end

end
