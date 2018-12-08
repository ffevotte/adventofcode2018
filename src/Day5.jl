module Day5
export part1, part2

using Lazy

function collapsedLength(p; ignore='-')
    collapsed = []
    curr = '-'
    for next in p
        if uppercase(next) == ignore
            continue
        elseif uppercase(curr) == uppercase(next) && curr != next
            curr = pop!(collapsed)
        else
            push!(collapsed, curr)
            curr = next
        end
    end
    length(collapsed)
end

function part1()
    open(x->read(x,String), "input5") |> chomp |> collect |> collapsedLength
end

function part2()
    polymer = open(x->read(x,String), "input5") |> chomp
    minimum([collapsedLength(polymer; ignore=char) for char in 'A':'Z'])
end

end # module
