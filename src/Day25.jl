module Day25
export part1, part2, puzzle

using Lazy
using DataStructures
using AOC

manhattan(p1, p2) = sum(abs.(p1.-p2))

function puzzle()
    constellations = []
    foreach(eachline("input25")) do l
        point = toInt.(split(l, ","))
        reachable = []
        for c in constellations
            for p in c
                if manhattan(p, point) <= 3
                    push!(reachable, c)
                    break
                end
            end
        end
        if length(reachable) == 1
            push!(reachable[1], point)
        elseif length(reachable) == 0
            push!(constellations, [point])
        else
            push!(reachable[1], point)
            for c in reachable[2:end]
                append!(reachable[1], c)
                empty!(c)
            end
        end
    end
    count(c->!isempty(c), constellations)
end

end # module
