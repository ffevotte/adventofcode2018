module Day13
export part1, part2, puzzle

using Lazy
using DataStructures

function readInput()
    tracks = open("input13") do f
        map(collect, eachline(f))
    end

    carts = Tuple{Int64,Int64,Char,Int64}[]
    for i in 1:length(tracks)
        row = tracks[i]
        for j = 1:length(row)
            if row[j] in ['<', '>']
                push!(carts, (i, j, '-', 0))
            elseif row[j] in ['^', 'v']
                push!(carts, (i, j, '|', 0))
            end
        end
    end

    tracks, carts
end

display(tracks) = foreach(x->println(String(x)) ,tracks)

move = Dict('<' => (0,-1),
            '>' => (0, 1),
            '^' => (-1,0),
            'v' => (1, 0),
            'X' => (0, 0))

turn = Dict(('<', '-')  => '<',
            ('<', '/')  => 'v',
            ('<', '\\') => '^',
            ('>', '-')  => '>',
            ('>', '/')  => '^',
            ('>', '\\') => 'v',
            ('^', '|')  => '^',
            ('^', '/')  => '>',
            ('^', '\\') => '<',
            ('v', '|')  => 'v',
            ('v', '/')  => '<',
            ('v', '\\') => '>')

intersect = Dict('<' => ['v', '<', '^'],
                 '>' => ['^', '>', 'v'],
                 '^' => ['<', '^', '>'],
                 'v' => ['>', 'v', '<'])

function step(tracks, cart, crash)
    (iold, jold, old, state) = cart

    c = tracks[iold][jold]

    (i, j) = (iold, jold) .+ move[c] ::Tuple{Int64,Int64}
    t = tracks[i][j]

    tracks[iold][jold] = old

    if t == '+'
        tracks[i][j] = intersect[c][state+1]
        state = (state+1) % 3
    elseif t in ['<', '>', '^', 'v', 'X']
        tracks[i][j] = 'X'
        crash[] = (j-1,i-1)
    else
        tracks[i][j] = turn[(c,t)]
    end

    if c == 'X'
        t = old
    end
    (i,j,t,state)
end

function part1()
    tracks, carts = readInput()
    # display(tracks)
    # println(carts)

    crash = Ref((-1,-1))
    while crash[] == (-1,-1)
        carts = map(c->step(tracks, c, crash), carts)
        # display(tracks)
        # println(carts)
    end
    crash[]
end

function part2()
    tracks, carts = readInput()

    crash = Ref((-1,-1))
    while length(carts) > 1
        carts = @as _x_ carts begin
            map(c->step(tracks, c, crash), _x_)
            sort(_x_, by=x->(x[1],x[2]))
        end

        if crash[] != (-1,-1)
            new_carts = Tuple{Int64,Int64,Char,Int64}[]

            for (i, j, old, state) in carts
                if tracks[i][j] != 'X'
                    push!(new_carts, (i,j,old,state))
                end
            end

            for (i, j, old, state) in carts
                if tracks[i][j] == 'X'
                    if !in(old, ['<', '>', '^', 'v', 'X'])
                        tracks[i][j] = old
                    end
                end
            end

            carts = new_carts
        end
    end

    (i,j, _, _) = carts[1]
    (j-1, i-1)
end

end # module
