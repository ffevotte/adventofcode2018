module Day14
export part1, part2, puzzle

using Lazy
using DataStructures

function step(elves, recipes)
    e1 = recipes[elves[1]]
    e2 = recipes[elves[2]]
    s = e1 + e2
    d = div(s, 10)
    if d > 0
        push!(recipes, d)
    end

    u = s % 10
    push!(recipes, u)

    (elves .+ (e1, e2)) .% length(recipes) .+ (1,1)
end

function part1(nRecipes)
    recipes = [3, 7]
    elves = (1,2)

    while length(recipes) < nRecipes + 10
        elves = step(elves, recipes)
    end

    @as x recipes[nRecipes+1:nRecipes+10] begin
        map(string, x)
        join(x, "")
    end
end

function part2(sequence)
    recipes = [3, 7]
    elves = (1,2)
    sequence = map(x->parse(Int,x),collect(sequence))

    for i in 1:length(sequence)
        elves = step(elves, recipes)
    end

    while true
        elves = step(elves, recipes)

        ok = true
        for i0 in 1:length(sequence)
            if sequence[i0] != recipes[i0+length(recipes)-length(sequence)]
                ok = false
                break
            end
        end
        ok && return length(recipes)-length(sequence)

        ok = true
        for i0 in 1:length(sequence)
            if sequence[i0] != recipes[i0+length(recipes)-length(sequence)-1]
                ok = false
                break
            end
        end
        ok && return length(recipes)-length(sequence)-1
    end
end

end # module
