module TestScrapeNews
using Test
include("./../src/ScrapeNews.jl")

@testset "Get news articles from website" begin
    @test "https://lenushealth.com/news/what-is-preventive-healthcare/" in ScrapeNews.grab_news_urls()
    @test "https://lenushealth.com/news/new-respiratory-monitoring-service-for-covid-19-patients/" in ScrapeNews.grab_news_urls()
end

@testset "Extract text from url" begin
    @test occursin("A more equal solution", ScrapeNews.extract_text_from_url("https://lenushealth.com/news/what-is-preventive-healthcare/"))
    @test occursin("The solution to reform in the NHS lies with technology", ScrapeNews.extract_text_from_url("https://lenushealth.com/news/what-is-preventive-healthcare/"))
    @test occursin("Improved patient outcomes", ScrapeNews.extract_text_from_url("https://lenushealth.com/news/lenus-shares-new-evidence-for-an-integrated-virtual-ward-approach/"))
    @test occursin("Digital home care is set to be an important model to help the NHS improve services for patients with long-term conditions", ScrapeNews.extract_text_from_url("https://lenushealth.com/news/lenus-shares-new-evidence-for-an-integrated-virtual-ward-approach/"))
end

end
