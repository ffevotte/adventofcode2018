module Day23
export part1, part2, puzzle

using Lazy
using DataStructures
using AOC

struct Drone
    x ::Int32
    y ::Int32
    z ::Int32
    r ::Int32
end
Base.isless(d1::Drone, d2::Drone) = d1.r < d2.r
pos(d::Drone) = (d.x,d.y,d.z)
manhattan(x, y) = abs.(x.-y) |> sum
manhattan(d1::Drone, d2::Drone) = manhattan(pos(d1), pos(d2))

function readInput(name)
    map(eachline(name)) do l
        @>> match(r"pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)", l) begin
            x->x.captures
            map(toInt)
            x->Drone(x...)
        end
    end
end

function part1()
    drones = readInput("input23")
    dMax = maximum(drones)
    count(d->manhattan(d,dMax)<=dMax.r, drones)
end

function score(x, y, z, drones)
    x1,x2 = x
    y1,y2 = y
    z1,z2 = z

    c = (div(x1+x2, 2), div(y1+y2, 2), div(z1+z2, 2))
    rad = div(1+x2+y2+z2-(x1+y1+z1), 2)

    (sum(manhattan(c, pos(d)) > d.r + rad ? 0 : 1
         for d in drones),
     rad)
end

function part2()
    drones = readInput("input23")

    x = extrema(d.x for d in drones)
    y = extrema(d.y for d in drones)
    z = extrema(d.z for d in drones)

    aux(xx,yy,zz) = begin
        (x1, x3) = x; x2 = div(x1+x3, 2)
        (y1, y3) = y; y2 = div(y1+y3, 2)
        (z1, z3) = z; z2 = div(z1+z3, 2)
        for x in ((x1, x2), (x2+1, x3))
            x[1]>x[2] && continue
            for y in ((y1, y2), (y2+1, y3))
                y[1]>y[2] && continue
                for z in ((z1, z2), (z2+1, z3))
                    z[1]>z[2] && continue
                    s = score(x,y,z,drones)
                    enqueue!(l, (x,y,z,s[2])=>s)
                end
            end
        end
    end

    l = PriorityQueue{typeof((x,y,z, x[1])), Tuple{Int,Int}}(
        Base.Order.Reverse)
    enqueue!(l, (x,y,z, 1)=>(1,1))

    while true
        (x,y,z, rad) = dequeue!(l)
        rad == 0 &&
            return manhattan((x[1], y[1], z[1]), (0,0,0))
        aux(x,y,z)
    end
end

end # module
