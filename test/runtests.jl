using NewsSummarised
using Test

@testset "Test webscraping and summarising steps" begin

    @testset "Webscrape tests" begin
        include("scrapelenushealthnews_tests.jl")
    end

    @testset "Summarise tests" begin
        include("summarise_tests.jl")
    end
end
