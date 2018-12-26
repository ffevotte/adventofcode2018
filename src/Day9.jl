module Day9
export part1, part2, puzzle

using DataStructures

function shiftP(ring, n)
    for i in 1:n
        x = popfirst!(ring)
        push!(ring, x)
    end
end

function shiftN(ring, n)
    for i in 1:n
        x = pop!(ring)
        pushfirst!(ring, x)
    end
end

function puzzle(nPlayer, nMarble)
    ring  = Deque{Int}();  push!(ring, 0)
    score = [0 for i in 1:nPlayer]

    for marble = 1:nMarble
        if marble % 23 == 0
            shiftN(ring, 7)
            score[1+marble%nPlayer] += marble + pop!(ring)
            shiftP(ring, 1)
        else
            shiftP(ring, 1)
            push!(ring, marble)
        end
        # @show ring
    end
    maximum(score)
end

end # module
