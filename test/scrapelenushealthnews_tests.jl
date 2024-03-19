module TestScrapeLenusHealthNews
using Test
include("./../src/ScrapeLenusHealthNews.jl")

@testset "Get news articles from website" begin
    @test "https://lenushealth.com/news/what-is-pharmacovigilance-and-why-does-it-matter/" in ScrapeLenusHealthNews.grab_news_urls()
    @test "https://lenushealth.com/news/new-respiratory-monitoring-service-for-covid-19-patients/" in ScrapeLenusHealthNews.grab_news_urls()
end

@testset "Extract text from url" begin
    @test occursin("A more equal solution", ScrapeLenusHealthNews.extract_text_from_url("https://lenushealth.com/news/what-is-preventive-healthcare/"))
    @test occursin("Role of Virtual Care Models and Digital Pathways", ScrapeLenusHealthNews.extract_text_from_url("https://lenushealth.com/news/how-lenus-services-lower-nhs-emissions/"))
    @test occursin("Digital home care is set to be an important model to help the NHS improve services for patients with long-term conditions", ScrapeLenusHealthNews.extract_text_from_url("https://lenushealth.com/news/lenus-shares-new-evidence-for-an-integrated-virtual-ward-approach/"))
end

end
