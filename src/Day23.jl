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

function partition(range, n)
    (i1,i2) = range
    aux(c) = begin
        i = i1
        d, r = divrem(i2-i1+1, n)
        for k in 1:r
            ii = i+d
            put!(c, (i,ii))
            i = ii+1
        end
        d == 0 && return
        for k in r+1:n
            ii = i+d-1
            put!(c, (i,ii))
            i = ii+1
        end
    end
    Channel(aux)
end

function score(x, y, z, d)
    x1,x2 = x
    y1,y2 = y
    z1,z2 = z

    c = (div(x1+x2, 2),
         div(y1+y2, 2),
         div(z1+z2, 2))
    diam = maximum(manhattan(c, p) for p in Iterators.product(x,y,z))

    dist = manhattan(c, pos(d))

    if dist > d.r + diam
        (0,0)
    elseif dist <= d.r - diam
        (1,1)
    else
        (0,1)
    end
end

volume(x) = (1-(-(x[i]...)) for i in 1:3) |> prod |> abs

function part2()
    drones = readInput("input23")

    x = extrema(d.x for d in drones)
    y = extrema(d.y for d in drones)
    z = extrema(d.z for d in drones)

    aux(xx,yy,zz,s) = begin
        for x in partition(xx,2)
            for y in partition(yy,2)
                for z in partition(zz,2)
                    s = reduce((a,b)->a.+b,
                               score(x,y,z,d) for d in drones)
                    push!(l, (x,y,z, s))
                end
            end
        end
    end

    l = [(x,y,z, (0,typemax(Int32)))]
    bestMin = 0
    while volume(l[end]) != 1
        aux(pop!(l)...)
        bestMin = maximum(x[4][1] for x in l)
        filter!(x->x[4][2]>=bestMin, l)
        sort!(l, by=x->(x[4][2], volume(x)))
    end
    filter!(x->x[4][1]>=bestMin, l)

    minimum(manhattan((x[1],y[1],z[1]), (0,0,0)) for (x,y,z,s) in l)
end

end # module
