module Day17
export part1, part2, puzzle

using Lazy
using DataStructures
using AOC

function readTerrain(input)
    x = (500,500)
    y = ()

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

    nDiscard = y[1]
    y = minmax(y..., 0)

    xMin = x[1] - 2
    yMin = y[1] - 2
    nDiscard -= yMin+1

    terrain = Array{Char, 2}(undef, y[2]+1-yMin, x[2]+1-xMin)
    fill!(terrain, '.')

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

    terrain, xMin, yMin, nDiscard
end

function output(terrain)
    open("output17", "w") do f
        for i in 1:size(terrain, 1)
            write(f, terrain[i,:] |> String)
            write(f, "\n")
        end
    end
end

function fillOnce(terrain, l, parent)
    xSource, ySource = dequeue!(l)

    while true
        # Can't fill any more from here; should go back to a higher level
        if terrain[ySource, xSource] == '~'
            xParent, yParent = parent[(xSource, ySource)]
            l[xParent, yParent] = yParent
            return
        end

        # Fall until hit clay or water
        y = ySource
        while true
            y += 1
            if y >= size(terrain, 1)
                return
            elseif terrain[y,xSource] in "#~"
                y -= 1
                break
            end
            terrain[y,xSource] = '|'
        end

        # Look for a barrier on the left
        left = false
        x = xSource
        while true
            x -= 1
            if terrain[y+1, x] in ".|"
                break
            elseif terrain[y, x] == '#'
                x += 1
                left = true
                break
            end
        end
        x1 = x

        # Look for a barrier on the right
        right = false
        x = xSource
        while true
            x += 1
            if terrain[y+1, x] in ".|"
                break
            elseif terrain[y, x] == '#'
                x -= 1
                right = true
                break
            end
        end
        x2 = x

        if left && right
            # Barriers on both sides -> continue filling
            fill!(view(terrain, y, x1:x2), '~')
        else
            # Water flows somewhere else
            fill!(view(terrain, y, x1:x2), '|')

            # Water flow from the left extremity
            if !left
                parent[(x1,y)] = (xSource, ySource)
                l[(x1, y)] = y
            end

            # Water flow from the left extremity
            if !right
                parent[(x2,y)] = (xSource, ySource)
                l[(x2, y)] = y
            end

            return
        end
    end
end

function puzzle()
    terrain, xMin, yMin, nDiscard = readTerrain("input17")

    terrain[0-yMin, 500-xMin] = '+'
    # output(terrain)

    parent = Dict((500-xMin, 0-yMin) => (-1,-1))
    l = PriorityQueue((500-xMin, 0-yMin) => -yMin)
    while !isempty(l)
        fillOnce(terrain, l, parent)
    end
    # output(terrain)

    # Don't count the first layers, which are above measurement depths
    fill!(view(terrain, 1:nDiscard, :), '*')
    (count(c->c in "~|", terrain), # <- part 1
     count(c->c == '~',  terrain)) # <- part 2
end

end # module
