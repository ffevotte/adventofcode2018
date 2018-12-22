module Day22
export part1, part2, puzzle, @dbg

using Lazy
using DataStructures
using AOC

level(index, depth) = (index+depth) % 20183

function puzzle(depth, xT, yT)
    margin = 25

    # Compute erosion level
    lvl = Array{Int32, 2}(undef, yT+margin, xT+margin)
    lvl[1,1] = level(0, depth)
    for j in 2:size(lvl,2)
        lvl[1,j] = level((j-1) * 16807, depth)
    end
    for i in 2:size(lvl,1)
        lvl[i,1] = level((i-1) * 48271, depth)
    end
    for f in 3:(size(lvl,1)+size(lvl,2))
        for j in 2:min(size(lvl,2), f)
            i = f-j
            (i<2 || i>size(lvl,1)) && continue

            lvl[i,j] = level(lvl[i,j-1]*lvl[i-1,j], depth)
        end

        if f == xT+yT+2
            lvl[yT+1,xT+1] = level(0, depth)
        end
    end

    part1 = sum(lvl[i,j] % 3 for i in 1:yT+1 for j in 1:xT+1)


    # Find shortest path
    dist = typemax(Int32) * ones(Int32, size(lvl,1), size(lvl,2), 3)
    l = Deque{Tuple{Int32, Int32, Int32}}()
    push!(l, (1,1,1))
    dist[1,1,1] = 0

    while !isempty(l)
        (i,j,t) = popfirst!(l)

        dist[i,j,t] > dist[yT+1,xT+1,1] && continue

        for (ii,jj,tt) in Iterators.product(i-1:i+1, j-1:j+1, 1:3)

            # Ignore regions which are out of bounds
            (ii<1 || jj<1
             || ii>size(dist,1)
             || jj>size(dist,2)) && continue

            # Ignore regions in diagonal
            dd = abs(ii-i)+abs(jj-j)
            dd > 1 && continue

            # The chosen tool must be compatible with both the origin and destination
            if tt%3 in [lvl[ii,jj]%3, lvl[i,j]%3]
                continue
            end

            # New distance
            d = dist[i,j,t] + dd
            if t!=tt
                d += 7
            end

            # Update if necessary
            if d<dist[ii,jj,tt]
                dist[ii,jj,tt] = d
                push!(l, (ii,jj,tt))
            end
        end
    end

    part2 = dist[yT+1, xT+1,1]

    (part1, part2)
end

end # module
