module Day9
export part1, part2, puzzle

using DataStructures

function shift(ring, n)
    f1 = push!
    f2 = popfirst!
    if n<0
        n = -n
        f1 = pushfirst!
        f2 = pop!
    end

    for i in 1:n
        x = f2(ring)
        f1(ring, x)
    end
end

function puzzle(nPlayer, nMarble)
    ring  = Deque{Int}();  push!(ring, 0)
    score = [0 for i in 1:nPlayer]

    for marble = 1:nMarble
        if marble % 23 == 0
            shift(ring, -7)
            score[1+marble%nPlayer] += marble + pop!(ring)
            shift(ring, 1)
        else
            shift(ring, 1)
            push!(ring, marble)
        end
        # @show ring
    end
    maximum(score)
end

end # module
