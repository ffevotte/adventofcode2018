module Day18
export part1, part2, puzzle

using Lazy
using DataStructures
using AOC

function readInput(name, size)
    area = Array{Char, 2}(undef, size+2, size+2)
    fill!(area, '0')

    i = 1
    foreach(eachline(name)) do line
        copyto!(view(area, i+1, 2:size+1), line)
        i += 1
    end

    area
end

neighbors(i,j) = Iterators.filter(x -> x!=(i,j), Iterators.product(i-1:i+1, j-1:j+1))

countType(area) = (cnt, pos) -> let c = area[pos...]
    if c == '|'
        cnt .+ (1,0)
    elseif c == '#'
        cnt .+ (0,1)
    else
        cnt
    end
end

function transform(area, i, j)
    init = area[i,j]
    (tree, lumber) = foldl(countType(area), neighbors(i,j), init=(0,0))

    if     init=='.' && tree>=3
        '|'
    elseif init=='|' && lumber>=3
        '#'
    elseif init=='#' && lumber>=1 && tree>=1
        '#'
    elseif init=='#'
        '.'
    else
        init
    end
end

function puzzle(nGens)
    area = readInput("input18",   50)
    N = size(area, 1)
    new = deepcopy(area)

    checksums = CircularBuffer{Int}(100)
    foreach(x->push!(checksums,-x), 1:100)

    gen = 0
    period = -1
    checksum = 0
    while gen < nGens
        gen += 1
        for i in 2:N-1
            for j in 2:N-1
                new[i,j] = transform(area, i, j)
            end
        end
        (area, new) = (new, area)

        checksum = foldl(countType(area), Iterators.product(1:N,1:N), init=(0,0)) |> prod
        push!(checksums, checksum)

        period = findnext(x->x==checksums[1], checksums, 2)
        if period != nothing && all(checksums[i+period-1]-checksums[i] == 0 for i in 1:101-period)
            period -= 1
            #println("Cycle detected: gen=$gen, period=$period")
            break
        end
    end

    if gen < nGens
        i = findfirst(x->x==checksum, checksums) + (nGens-gen)%period
        checksum = checksums[i]
    end

    checksum
end

end # module
