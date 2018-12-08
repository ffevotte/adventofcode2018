module Day8
export part1, part2, puzzle

using Lazy

to_int(x) = parse(Int, x)

function readNode(stream)
    nChildren = popfirst!(stream)
    nData = popfirst!(stream)
    children = [readNode(stream) for i in 1:nChildren]
    data = [popfirst!(stream) for i in 1:nData]
    (children, data)
end

function tree()
    @as x open(f->read(f, String), "input8") begin
        split(x, " ")
        map(to_int, x)
        readNode(x)
    end
end


function checksum(tree)
    reduce((x,y)->x+checksum(y), tree[1], init=sum(tree[2]))
end

function value(tree)
    children = tree[1]
    data = tree[2]

    if children == []
        sum(data)
    else
        v = 0
        for d in data
            if d<=length(children)
                v += value(children[d])
            end
        end
        v
    end
end

function part1()
    checksum(tree())
end

function part2()
    value(tree())
end

end # module
