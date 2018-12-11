module Day11
export part1, part2, puzzle

using Lazy

function power(serial, x, y)
    rId = 10+x
    @as p rId * y begin
        p + serial
        p * rId
        Int(floor(p / 100)) % 10
        p - 5
    end
end

function puzzle(sizeRange)
    serial = 4842
    p = zeros(Int32, 300,300)

    p[1,1] = power(serial, 1,1)
    for i in 2:300
        p[i,1] = p[i-1,1] + power(serial, i,1)
        p[1,i] = p[1,i-1] + power(serial, 1,i)
    end
    for x in 2:300
        for y in 2:300
            p[x,y] = power(serial, x, y) + p[x-1,y] + p[x,y-1] - p[x-1,y-1]
        end
    end

    bestCoord = (0,0,0)
    bestVal = 0
    for s in sizeRange
        for x in 2:301-s
            for y in 2:301-s
                val = p[x-1,y-1] + p[x+s-1,y+s-1] - p[x-1,y+s-1] - p[x+s-1,y-1]
                if val > bestVal
                    bestVal = val
                    bestCoord = (x,y,s)
                end
            end
        end
    end
    bestCoord
end

end # module
