module Day22
export part1, part2, puzzle

using Lazy
using DataStructures
using AOC

level(index, depth) = (index+depth) % 20183

function puzzle(depth, xT, yT)
    margin = 25

    # Compute erosion level
    lvl = Array{Int64, 2}(undef, yT+margin, xT+margin)
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
    dist = typemax(Int64) * ones(Int64, size(lvl,1), size(lvl,2), 3)
    l = PriorityQueue((1,1,1)=>0)
    dist[1,1,1] = 0

    M = size(dist, 1)
    N = size(dist, 2)

    while !isempty(l)
        (i,j,t) = dequeue!(l)
        (i,j,t) == (yT+1,xT+1,1) && break

        for (ii,jj,tt) in Iterators.product(i-1:i+1, j-1:j+1, 1:3)
            # Ignore regions which are out of bounds
            (ii<1 || jj<1 || ii>M || jj>N) && continue

            # Ignore regions in diagonal
            dd = abs(ii-i)+abs(jj-j)
            dd > 1 && continue

            # The chosen tool must be compatible with both the origin and destination
            (tt-lvl[i,j])   % 3 == 0 && continue
            (tt-lvl[ii,jj]) % 3 == 0 && continue

            # New distance
            d = dist[i,j,t] + dd
            if t!=tt
                d += 7
            end

            # Update if necessary
            if d<dist[ii,jj,tt]
                dist[ii,jj,tt] = d
                l[(ii,jj,tt)] = d + abs(yT+1-ii) + abs(xT+1-jj) + (tt==1 ? 0 : 7)
            end
        end
    end

    part2 = dist[yT+1, xT+1, 1]

    (part1, part2)
end

end # module
