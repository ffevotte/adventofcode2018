module Day6
export puzzle

using Lazy

coordinates() = open("input6") do f
    map(eachline(f)) do x
        s = split(x, ",")
        (parse(Int64, s[1]), parse(Int64, s[2]))
    end
end

function manhattan(c1, c2)
    (x1, y1) = c1
    (x2, y2) = c2
    abs(x2-x1) + abs(y2-y1)
end

function puzzle()
    coord = coordinates()

    (xmin, ymin) = reduce((x,y)->min.(x,y), coord, init=(typemax(Int64), typemax(Int64)))
    (xmax, ymax) = reduce((x,y)->max.(x,y), coord, init=(typemin(Int64), typemin(Int64)))

    count = zeros(Int, length(coord))
    count2 = 0
    for x in xmin:xmax
        for y in ymin:ymax

            iBest = 0
            dBest = 1000

            sumDist = 0

            for i in 1:length(coord)
                d = manhattan((x,y), coord[i])
                sumDist += d

                if d < dBest
                    dBest = d
                    iBest = i
                elseif d == dBest
                    iBest = 0
                end
            end

            if iBest != 0
                if x == xmin || x==xmax || y==ymin || y==ymax
                    count[iBest] = typemin(Int64)
                end
                count[iBest] += 1
            end

            if sumDist < 10000
                count2 += 1
            end
        end
    end

    (maximum(count), count2)
end

end # module
