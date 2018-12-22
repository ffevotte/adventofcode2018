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
        if startswith($title, "")
            @test $expr
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

    using AOC.Day12
    @testset "Day12" begin
        @btest "12.1" Day12.puzzle(20)          == 3061
        @btest "12.2" Day12.puzzle(50000000000) == 4049999998575
    end

    using AOC.Day13
    @testset "Day13" begin
        @btest "13.1" Day13.part1() == (119, 41)
        @btest "13.2" Day13.part2() == (45, 136)
    end

    using AOC.Day14
    @testset "Day14" begin
        @btest "14.1" Day14.part1(323081)   == "7162937112"
        @btest "14.2" Day14.part2("323081") == 20195890
    end

    using AOC.Day15
    @testset "Day15" begin
        @btest "15.1" Day15.part1() == 216270
        @btest "15.2" Day15.part2() == 59339
    end

    using AOC.Day16
    @testset "Day16" begin
        @btest "16.1" Day16.part1() == 531
        @btest "16.2" Day16.part2() == 649
    end

    using AOC.Day17
    @testset "Day17" begin
        @btest "17" Day17.puzzle() == (30380, 25068)
    end

    using AOC.Day18
    @testset "Day18" begin
        @btest "18.1" Day18.puzzle(10)         == 621205
        @btest "18.2" Day18.puzzle(1000000000) == 228490
    end

    using AOC.Day19
    @testset "Day19" begin
        @btest "19.1" Day19.puzzle(0) == 1836
        @btest "19.2" Day19.puzzle(1) == 18992556
    end

    using AOC.Day20
    @testset "Day20" begin
        @btest "20" Day20.puzzle() == (4018, 8581)
    end
end
