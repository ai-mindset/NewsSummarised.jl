module TestScrapeNews
using Test
include("./../src/ScrapeNews.jl")

@testset "Get news articles from website" begin
    @test "https://lenushealth.com/news/what-is-preventive-healthcare/" in ScrapeNews.grab_news_urls()
    @test "https://lenushealth.com/news/new-respiratory-monitoring-service-for-covid-19-patients/" in ScrapeNews.grab_news_urls()
end

@testset "Extract text from url" begin
    @test "A more equal solution" in ScrapeNews.extract_text_from_url("https://lenushealth.com/news/what-is-preventive-healthcare/")
    @test "The solution to reform in the NHS lies with technology, better data structuring and application of artificial intelligence to drive more automation and give clinicians the tools they need to help patients with chronic disease." in ScrapeNews.extract_text_from_url("https://lenushealth.com/news/what-is-preventive-healthcare/")
    @test "Improved patient outcomes" in ScrapeNews.extract_text_from_url("https://lenushealth.com/news/lenus-shares-new-evidence-for-an-integrated-virtual-ward-approach/")
    @test "Digital home care is set to be an important model to help the NHS improve services for patients with long-term conditions and address the extreme capacity issues facing the NHS that will only be exacerbated as we head into winter." in ScrapeNews.extract_text_from_url("https://lenushealth.com/news/lenus-shares-new-evidence-for-an-integrated-virtual-ward-approach/")
end

end
