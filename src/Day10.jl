module Day10
export part1, part2, puzzle

using Lazy

points() = open("input10") do f
    list = map(eachline(f)) do l
        @>> match(r"position=<(\s*-?\d+),(\s*-?\d+)> velocity=<(\s*-?\d+),(\s*-?\d+)>", l).captures begin
            map(x->parse(Int, x))
        end
    end
end

function bbox(points)
    xmin = typemax(Int)
    xmax = typemin(Int)
    ymin = typemax(Int)
    ymax = typemin(Int)

    for p in points
        xmin = min(xmin, p[1])
        xmax = max(xmax, p[1])
        ymin = min(ymin, p[2])
        ymax = max(ymax, p[2])
    end

    (xmin, xmax, ymin, ymax)
end

function picture(points)
    (xmin, xmax, ymin, ymax) = bbox(points)

    pic = Array{Char,2}(undef, ymax-ymin+1, xmax-xmin+1)
    fill!(pic, ' ')

    for p in points
        p[1] -= xmin-1
        p[2] -= ymin-1
        pic[p[2], p[1]] = '#'
    end

    join((String(pic[i,:]) for i in 1:size(pic,1)), "\n")
end

function step!(points, speed)
    for p in points
        p[1] += speed*p[3]
        p[2] += speed*p[4]
    end
    speed
end

function puzzle()
    p = points()

    h = typemax(Int)
    speed = 1000
    time = 0

    while true
        time += step!(p, speed)

        (xmin, xmax, ymin, ymax) = bbox(p)
        h_old = h
        h = ymax-ymin
        if h > h_old
            if abs(speed) == 1
                time += step!(p, -speed)
                break
            end
            speed = -sign(speed) * max(Int(round(0.8*abs(speed)))-1, 1)
        end
    end
    picture(p), time
end

end # module
