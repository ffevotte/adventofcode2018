module Day12
export part1, part2, puzzle

using Lazy
using DataStructures


function read_in()
    open("input12") do f
        state = @as x readline(f) begin
            split(x, " ")
            x[3]
        end

        readline(f)
        rules = @>> eachline(f) begin
            map(l->split(l, " "))
            map(l->(string(l[1]), string(l[3])[1]))
        end

        (state, rules)
    end
end

function normalize(state, shift)
    while !startswith(state, "...")
        state = "."*state
        shift -= 1
    end
    while startswith(state, "....")
        state = state[2:end]
        shift += 1
    end

    while !endswith(state, "...")
        state = state*"."
    end

    (state, shift)
end

function step(state, shift, rules)
    new = ".."
    for i in 1:length(state)-4
        word = state[i:i+4]
        c = '.'
        for (pattern, result) in rules
            if word == pattern
                c = result
                break
            end
        end
        new = new * c
    end
    normalize(new, shift)
end

function puzzle(genMax)
    (state, rules) = read_in()
    (state, shift) = normalize(state, 0)

    # Find a fixed point
    gen = 0
    state_old = ""
    shift_old = 0
    while gen < genMax && state_old != state
        gen += 1
        state_old = state
        shift_old = shift
        (state, shift) = step(state_old, shift, rules)
        # println(gen, "\t", shift, "\t", state)
    end

    # Extrapolate from it
    shift += (shift-shift_old) * (genMax-gen)

    # Compute score
    i = shift
    s = 0
    for char in state
        if char == '#'
            s += i
        end
        i+=1
    end
    s
end

end # module
