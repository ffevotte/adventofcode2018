using Test
using BenchmarkTools
using Lazy
import Statistics: mean

BenchmarkTools.DEFAULT_PARAMETERS.samples = 2
BenchmarkTools.DEFAULT_PARAMETERS.seconds = 1


@> ["Title",
   "Mb",
   "allocs",
   "ms"] begin
       join("\t")
       println
   end
macro btest(title, expr)
    quote
        @test $expr
        if startswith($title, "")
            r = @benchmark $expr
            @as __ [$title,
                    round(r.memory/(1024^2); digits=2),
                    r.allocs,
                    round(mean(r.times)/1000000; digits=2)] begin
                        map(string, __)
                        join(__, "\t")
                        println(__)
                    end
        end
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

    using AOC.Day9
    @testset "Day9" begin
        @btest "9.1" Day9.puzzle(405, 71700)   == 428690
        @btest "9.2" Day9.puzzle(405, 7170000) == 3628143500
    end

    using AOC.Day10
    @testset "Day10" begin
        # Day10.puzzle()[1] |> println
        @btest "10" Day10.puzzle()[2] == 10036
    end

    using AOC.Day11
    @testset "Day11" begin
        @btest "11.1" Day11.puzzle(3:3)   == (20, 83, 3)
        @btest "11.2" Day11.puzzle(1:300) == (237, 281, 10)
    end
end
