module Day17
export part1, part2, puzzle

using Lazy
using DataStructures


toInt(x) = parse(Int, x)

Base.minmax(x...) = extrema(x)

function puzzle()
    x = (500,500)
    y = ()

    input = "input17"

    foreach(eachline(input)) do l
        m = match(r"x=(\d+), y=(\d+)..(\d+)", l)
        if m !== nothing
            x = minmax(x..., toInt(m.captures[1]))
            y = minmax(y..., toInt(m.captures[2]), toInt(m.captures[3]))
            return
        end

        m = match(r"y=(\d+), x=(\d+)..(\d+)", l)
        if m !== nothing
            x = minmax(x..., toInt(m.captures[2]), toInt(m.captures[3]))
            y = minmax(y..., toInt(m.captures[1]))
            return
        end
    end

    YMIN = y[1]
    y = minmax(y..., 0)

    xMin = x[1] - 2
    yMin = y[1] - 2
    YMIN -= yMin+1

    terrain = Array{Char, 2}(undef, y[2]+1-yMin, x[2]+1-xMin)
    fill!(terrain, '.')
    terrain[0-yMin, 500-xMin] = '+'

    foreach(eachline(input)) do l
        m = match(r"x=(\d+), y=(\d+)..(\d+)", l)
        if m !== nothing
            x = toInt(m.captures[1]) - xMin
            y1 = toInt(m.captures[2]) - yMin
            y2 = toInt(m.captures[3]) - yMin
            fill!(view(terrain, y1:y2, x), '#')
            return
        end

        m = match(r"y=(\d+), x=(\d+)..(\d+)", l)
        if m !== nothing
            y  = toInt(m.captures[1]) - yMin
            x1 = toInt(m.captures[2]) - xMin
            x2 = toInt(m.captures[3]) - xMin
            fill!(view(terrain, y, x1:x2), '#')
            return
        end
    end

    # open("output17", "w") do f
    #     for i in 1:size(terrain, 1)
    #         write(f, terrain[i,:] |> String)
    #         write(f, "\n")
    #     end
    # end
    # return

    fillOnce(xSource, ySource) = begin
        y = ySource
        while y < size(terrain, 1)-1
            y += 1
            if terrain[y,xSource] in "#~"
                y -= 1

                left = false
                x = xSource
                while true
                    x -= 1
                    if terrain[y+1, x] in ".|S"
                        break
                    elseif terrain[y, x] == '#'
                        x += 1
                        left = true
                        break
                    end
                end
                x1 = x

                right = false
                x = xSource
                while true
                    x += 1
                    if terrain[y+1, x] in ".|S"
                        break
                    elseif terrain[y, x] == '#'
                        x -= 1
                        right = true
                        break
                    end
                end
                x2 = x

                if left && right
                    fill!(view(terrain, y, x1:x2), '~')
                else
                    fill!(view(terrain, y, x1:x2), '|')
                end

                ret = []
                if !left
                    push!(ret, (x1, y))
                end
                if !right
                    push!(ret, (x2, y))
                end

                return ret
            end

            terrain[y,xSource] = '|'
        end
    end

    sources = Deque{Tuple{Int32, Int32}}()
    stalled = true
    while stalled

        open("output17", "w") do f
            for i in 1:size(terrain, 1)
                write(f, terrain[i,:] |> String)
                write(f, "\n")
            end
        end
        println("LOOP")

        stalled = false
        push!(sources, (500-xMin, 0-yMin))
        while !isempty(sources)
            (xSource, ySource) = popfirst!(sources)
            i = 1
            while i <= 20
                new = fillOnce(xSource, ySource)

                if new === nothing
                    break
                elseif !isempty(new)
                    foreach(x->push!(sources, x), new)
                    break
                end

                i += 1
            end
            if i >= 20
                stalled = true
            end
        end
    end

    println()
    open("output17", "w") do f
        for i in 1:size(terrain, 1)
            write(f, terrain[i,:] |> String)
            write(f, "\n")
        end
    end

    fill!(view(terrain, 1:YMIN, :), '*')
    (count(c->c in "~|", terrain),
     count(c->c == '~',  terrain))
end

end # module
