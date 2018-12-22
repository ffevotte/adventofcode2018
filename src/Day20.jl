module Day20
export part1, part2, puzzle

using Lazy
using DataStructures
using AOC

abstract type Path end
struct Seq <: Path
    first :: Path
    remainder :: Path
end
struct Opt <: Path
    options :: Array{Path, 1}
end
struct Branch <: Path
    path :: String
end

function parseRE(s)
    s == "" && return Branch(s)

    if s[1] == '('
        lvl = 0
        options = Path[]
        i = 2
        for j in Iterators.countfrom(2)
            if s[j] == '('
                lvl += 1
            elseif s[j]=='|' && lvl==0
                push!(options, parseRE(s[i:j-1]))
                i = j+1
            elseif s[j]==')'
                if lvl == 0
                    push!(options, parseRE(s[i:j-1]))
                    if j==length(s)
                        return Opt(options)
                    else
                        return Seq(Opt(options),
                                   parseRE(s[j+1:end]))
                    end
                else
                    lvl -= 1
                end
            end
        end
    end

    j = findfirst("(", s)
    if j===nothing
        return Branch(s)
    else
        return Seq(Branch(s[1:j.start-1]),
                   parseRE(s[j.start:end]))
    end
end

addNeighbors(neighbors, pos1, shift...) = begin
    pos2 = pos1 .+ shift
    a, b = minmax(pos1, pos2)
    @>  get!(neighbors, a, [])  push!(b)
    pos2
end

areNeighbors(neighbors, pos1, pos2) = begin
    a, b = minmax(pos1, pos2)
    b in get(neighbors, a, [])
end

function display(neighbors)
    i1, i2 = extrema(pos[1] for pos in keys(neighbors))
    j1, j2 = extrema(pos[2] for pos in keys(neighbors))
    println((i1,i2,j1,j2))

    for i in i1:i2
        for j in j1:j2
            print("#")
            print(areNeighbors(neighbors, (i,j), (i-1,j)) ? " " : "#")
        end
        println("#")

        print("#")
        for j in j1:j2
            print((i,j)==(0,0) ? "x" : ".")
            print(areNeighbors(neighbors, (i,j), (i,j+1)) ? " " : "#")
        end
        println()
    end
    foreach(print, "##" for j in j1:j2)
    println("#")
end

function puzzle(disp = false)
    re = parseRE(
        #"N(E|W)N"
        #"ENWWW(NEEE|SSE(EE|N))"
        #"ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN"
        #"ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))"
        #"WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))"
        read("input20", String)[2:end-2]
    )

    neighbors = Dict((0,0)=>[])

    seen = Set{Tuple{Tuple{Int,Int}, Path}}()

    aux(pos, branch, remainder) = aux_(pos, branch, remainder)
    aux(pos, branch, ::Nothing) = begin
        if (pos, branch) in seen
            return
        end

        push!(seen, (pos, branch))
        aux_(pos, branch, nothing)
    end

    aux_(pos, branch::Branch, remainder) = begin
        for c in branch.path
            pos =
                if c=='E'
                    addNeighbors(neighbors, pos, 0, 1)
                elseif c=='W'
                    addNeighbors(neighbors, pos, 0, -1)
                elseif c=='N'
                    addNeighbors(neighbors, pos, -1, 0)
                elseif c=='S'
                    addNeighbors(neighbors, pos, 1, 0)
                else
                    pos
                end
        end

        if typeof(remainder) !== Nothing
            aux(pos, remainder, nothing)
        end
    end

    aux_(pos, path::Opt, remainder) = begin
        for opt in path.options
            aux(pos, opt, remainder)
        end
    end

    aux_(pos, path::Seq, remainder) = begin
        aux(pos, path.first, path.remainder)
    end

    aux((0,0), re, nothing)

    disp && display(neighbors)

    l = Deque{Tuple{Int, Int}}()
    push!(l, (0,0))
    dist = Dict((0,0)=>0)

    while !isempty(l)
        (i,j) = popfirst!(l)
        d = dist[(i,j)]

        for (ii,jj) in Iterators.product(i-1:i+1, j-1:j+1)
            (ii,jj) in keys(dist)  && continue

            if areNeighbors(neighbors, (i,j), (ii,jj))
                dist[(ii,jj)] = d+1
                push!(l, (ii,jj))
            end
        end
    end

    dist |> values |> v->(
        maximum(v),
        count(x->x>=1000, v)
    )
end

end # module
