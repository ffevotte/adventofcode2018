module Day5
export part1, part2

using Lazy


function collapsedLength(p)
    old = ""
    new = p
    while old != new
        old = new
        for char in 'a':'z'
            CHAR = uppercase(char)
            new = @> new begin
                replace(char*CHAR => "")
                replace(CHAR*char => "")
            end
        end
    end
    length(new)
end

function part1()
    open(x->read(x,String), "input") |> chomp |> collapsedLength
end

function part2()
    polymer = open(x->read(x,String), "input") |> chomp
    best = 100000

    for char in 'a':'z'
        CHAR = uppercase(char)
        length = @> polymer begin
            replace(char => "")
            replace(CHAR => "")
            collapsedLength()
        end

        if length < best
            best = length
        end
    end

    best
end






end # module
