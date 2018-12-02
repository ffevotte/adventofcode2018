module Day2

using Lazy

export part1, part2



numdiff(w1, w2) = @> (collect(w1) .- collect(w2)) begin
    abs.()
    min.(1)
    sum
end


function count(word)
    letters = Dict()
    for letter in word
        letters[letter] = get(letters, letter, 0) + 1
    end

    two = 0
    three = 0
    for (l,c) in letters
        if c == 2
            two = 1
        elseif c == 3
            three = 1
        end
    end
    (two,three)
end

function part1()
    c = (0,0)
    open("input") do f
        for word in eachline(f)
            c = c .+ count(word)
        end
    end
    c[1] * c[2]
end

function part2()
    words = open(f->collect(eachline(f)), "input")

    for i = 1:length(words)-1
        w1 = words[i]
        for j = i+1:length(words)-1
            w2 = words[j]
            if numdiff(w1,w2) == 1
                return @>> collect(w1).-collect(w2) begin
                    zip(collect(w1))
                    collect
                    filter(x -> x[2]==0)
                    map(first)
                    join()
                end
            end
        end
    end
end

end # module
