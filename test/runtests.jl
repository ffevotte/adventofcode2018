using AOC.Day1
using AOC.Day2
using AOC.Day3
using AOC.Day4
using AOC.Day5
using AOC.Day6
using AOC.Day7

using Test

@testset "Advent of Code 2018" begin
    @testset "Day1" begin
        @test Day1.part1() == 556
        @test Day1.part2() == 448
    end

    @testset "Day2" begin
        @test Day2.part1() == 7105
        @test Day2.part2() == "omlvgdokxfncvqyersasjziup"
    end

    @testset "Day3" begin
        @test Day3.part1() == 113716
        @test Day3.part2() == 742
    end

    @testset "Day4" begin
        @test Day4.part1() == 19874
        @test Day4.part2() == 22687
    end

    @testset "Day5" begin
        @test Day5.part1() == 9526
        @test Day5.part2() == 6694
    end

    @testset "Day6" begin
        @test Day6.puzzle() == (3223, 40495)
    end

    @testset "Day7" begin
        @test Day7.puzzle(1)[1] == "GLMVWXZDKOUCEJRHFAPITSBQNY"
        @test Day7.puzzle(5)[2] == 1105
    end
end
