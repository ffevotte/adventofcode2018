module Day3

export part1, part2, rects

using Lazy

function rects()
    open("input3") do f
        map(eachline(f)) do l
            @as x l begin
                split(x, " ")
                (split(x[3][1:end-1], ",")...,
                 split(x[4],          "x")...,
                 x[1][2:end])
                map(y->parse(Int64,y), x)
            end
        end
    end
end

function overlap()
    fabric = -ones(Int64, 1001,1001)

    for (x,y,w,h,id) in rects()
        fabric[1+x:x+w,1+y:y+h] .+= 1
    end

    @>> fabric begin
        max.(0)
        min.(1)
    end
end

function part1()
    sum(overlap())
end

function part2()
    fabric = overlap()

    for (x,y,w,h,id) in rects()
        if (sum(fabric[1+x:x+w,1+y:y+h]) == 0)
            return id
        end
    end
end


end # module
