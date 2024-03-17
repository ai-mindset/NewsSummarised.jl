using LenusHealthNewsSummarised
using Test

@testset "Test webscraping and summarising steps" begin

    @testset "Webscrape tests" begin
        include("scrapenews_tests.jl")
    end

    @testset "Summarise tests" begin
        include("summarise_tests.jl")
    end
end
