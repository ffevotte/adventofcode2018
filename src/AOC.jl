module AOC
export toInt

toInt(x) = parse(Int, x)
Base.minmax(x...) = extrema(x)

include("Day1.jl")
include("Day2.jl")
include("Day3.jl")
include("Day4.jl")
include("Day5.jl")
include("Day6.jl")
include("Day7.jl")
include("Day8.jl")
include("Day9.jl")
include("Day10.jl")
include("Day11.jl")
include("Day12.jl")
include("Day13.jl")
include("Day14.jl")
include("Day15.jl")
include("Day16.jl")
include("Day17.jl")
include("Day18.jl")
include("Day19.jl")
include("Day20.jl")
include("Day21.jl")

end # module
