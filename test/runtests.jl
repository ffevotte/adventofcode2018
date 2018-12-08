using Test
using BenchmarkTools

BenchmarkTools.DEFAULT_PARAMETERS.samples = 2
BenchmarkTools.DEFAULT_PARAMETERS.seconds = 1

macro btest(title, expr)
    quote
        println($title)
        @test @btime $expr
    end
end

@testset "Advent of Code 2018" begin
    using AOC.Day1
    @testset "Day1" begin
        @btest "1.1" Day1.part1() == 556
        @btest "1.2" Day1.part2() == 448
    end

    using AOC.Day2
    @testset "Day2" begin
        @btest "2.1" Day2.part1() == 7105
        @btest "2.2" Day2.part2() == "omlvgdokxfncvqyersasjziup"
    end

    using AOC.Day3
    @testset "Day3" begin
        @btest "3.1" Day3.part1() == 113716
        @btest "3.2" Day3.part2() == 742
    end

    using AOC.Day4
    @testset "Day4" begin
        @btest "4.1" Day4.part1() == 19874
        @btest "4.2" Day4.part2() == 22687
    end

    using AOC.Day5
    @testset "Day5" begin
        @btest "5.1" Day5.part1() == 9526
        @btest "5.2" Day5.part2() == 6694
    end

    using AOC.Day6
    @testset "Day6" begin
        @btest "6"   Day6.puzzle() == (3223, 40495)
    end

    using AOC.Day7
    @testset "Day7" begin
        @btest "7.1" Day7.puzzle(1)[1] == "GLMVWXZDKOUCEJRHFAPITSBQNY"
        @btest "7.2" Day7.puzzle(5)[2] == 1105
    end

    using AOC.Day8
    @testset "Day8" begin
        @btest "8.1" Day8.part1() == 49180
        @btest "8.2" Day8.part2() == 20611
    end
end
