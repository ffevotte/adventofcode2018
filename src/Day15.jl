module Day15
export part1, part2, puzzle

using Lazy
using DataStructures

mutable struct Warrior
    typ :: Char
    hp  :: Int32
    i   :: Int32
    j   :: Int32
end

import Base.isless
isless(w1::Warrior, w2::Warrior) = isless((w1.i, w1.j), (w2.i,w2.j))

function readMap()
    terrain = open("input15") do f
        map(eachline(f)) do line
            collect(line)
        end
    end

    warriors = Warrior[]
    for i in 1:length(terrain)
        row = terrain[i]
        for j in 1:length(row)
            if row[j] == 'G'
                push!(warriors, Warrior(row[j], 200, i, j))
                row[j] = '.'
            elseif row[j] == 'E'
                push!(warriors, Warrior(row[j], 200, i, j))
                row[j] = '.'
            end
        end
    end

    terrain, warriors
end

function buildMap(terrain, warriors)
    t = deepcopy(terrain)
    for w in warriors
        t[w.i][w.j] = w.typ
    end
    t
end

function display(title, terrain, warriors)
end

# function display(title, terrain, warriors)
#     println(title)
#     t = buildMap(terrain, warriors)
#     k = 1
#     w = warriors[k]
#     for i in 1:length(t)
#         hp = "   "
#         while k > 0 && w.i == i
#             hp = hp * " $(w.typ)($(w.hp))"
#             k += 1
#             if k <= length(warriors)
#                 w = warriors[k]
#             else
#                 k = -1
#             end
#         end
#         println(String(t[i]), hp)
#     end
# end

neighbours(i,j) = [
    (i-1, j),
    (i, j-1),
    (i, j+1),
    (i+1, j)
]

function move(terrain, warriors, i)
    w = warriors[i]
    typ = w.typ
    opp = typ=='G' ? 'E' : 'G'

    terrain = buildMap(terrain, warriors)
    terrain[w.i][w.j] = 'X'

    dist = typemax(Int32) * ones(Int32, length(terrain), length(terrain[1]))

    l = Deque{Tuple{Int32,Int32,Int32}}()
    push!(l, (w.i, w.j,0))

    chooseOpp() = begin
        while !isempty(l)
            (i,j,d) = popfirst!(l)
            if terrain[i][j] in ['#', typ]
                continue
            elseif dist[i,j] < typemax(Int32)
                continue
            elseif terrain[i][j] == opp
                dist[i,j] = d
                return (i, j, d)
            else
                dist[i,j] = d
                for (ii,jj) in neighbours(i,j)
                    push!(l, (ii,jj,d+1))
                end
            end
        end
        return (w.i, w.j, typemax(Int32))
    end

    (i,j,d) = chooseOpp()
    if d == 1
        return
    end
    if d == typemax(Int32)
        return
    end

    l = Deque{Tuple{Int32,Int32}}()
    push!(l, (i,j))
    while !isempty(l)
        (i,j) = popfirst!(l)
        if dist[i,j] < 0
            continue
        elseif (i, j) == (w.i, w.j)
            continue
        else
            for (ii,jj) in neighbours(i,j)
                if dist[ii,jj] == dist[i,j]-1
                    push!(l, (ii,jj))
                end
            end
            dist[i,j] *= -1
        end
    end

    aux() = for (i,j) in neighbours(w.i, w.j)
        if dist[i,j] == -1
            return (i,j)
        end
    end
    w.i,w.j = aux()
end

manhattan(w1, w2) = abs(w1.i-w2.i) + abs(w1.j-w2.j)

function battle(terrain, warriors, PART, atk)
    sort!(warriors)

    nElves, nGoblins = reduce(warriors; init=(0,0)) do acc, w
        (e,g) = acc
        if w.typ == 'E'
            (e+1, g)
        else
            (e, g+1)
        end
    end

    round = 0
    while true
        round += 1

        k = 1
        while k <= length(warriors)
            if nElves == 0 || nGoblins == 0
                return (round-1) * reduce((x,w)->(x + w.hp), warriors; init=0)
            end

            move(terrain, warriors, k)

            target = Warrior('X', 201, 100, 100)
            for w in warriors
                if w.typ != warriors[k].typ && manhattan(warriors[k], w) == 1
                    if (w.hp, w.i, w.j) < (target.hp, target.i, target.j)
                        target = w
                    end
                end
            end
            if target.typ != 'X'
                target.hp -= atk[warriors[k].typ]
                if target.hp <= 0
                    if target.typ == 'E'
                        nElves -= 1
                        if PART == 2
                            return -1
                        end
                    else
                        nGoblins -= 1
                    end

                    i = findfirst(w->w==target, warriors)
                    splice!(warriors, i)
                    if i < k
                        continue
                    end
                end
            end

            k += 1
        end
        sort!(warriors)
        display("\nAfter round $round", terrain, warriors)
    end
end

function part1()
    terrain, warriors = readMap()
    display("Initial situation", terrain, warriors)
    atk = Dict('G' => 3,
               'E' => 3)
    battle(terrain, warriors, 1, atk)
end

function part2()
    terrain, warriors_keep = readMap()
    display("Initial situation", terrain, warriors_keep)

    for a in 4:100
        warriors = deepcopy(warriors_keep)
        atk = Dict('G' => 3,
                   'E' => a)
        score = battle(terrain, warriors, 2, atk)
        if score > 0
            return score
        end
    end
end


end # module
