module Day7
export puzzle

using Lazy

mutable struct Node
    name     :: Char
    ndeps    :: Int64
    succ     :: Array{Char,1}
    duration :: Int64
end

Node(name) = Node(name, 0, [], name-'A'+61)
Base.isless(n1::Node, n2::Node) = (n1.ndeps < n2.ndeps) || (n1.ndeps == n2.ndeps && n1.name < n2.name)

function addDep!(graph, name1, name2)
    n1 = get(graph, name1, Node(name1))
    n2 = get(graph, name2, Node(name2))

    push!(n1.succ, name2)
    n2.ndeps += 1

    graph[name1] = n1
    graph[name2] = n2
end

function readGraph()
    graph = Dict{Char, Node}()
    open("input7") do f
        for line in eachline(f)
            a = split(line, " ")
            addDep!(graph, a[2][1], a[8][1])
        end
    end
    graph
end

function puzzle(nW)
    graph = readGraph()

    t = 0
    w = ['-' for i in 1:nW]
    active = 0
    sequence = ""
    while true
        if minimum(values(graph)).ndeps == typemax(Int64) && active == 0
            break
        end

        for i in 1:nW
            if w[i] == '-'
                n = minimum(values(graph))
                if n.ndeps == 0
                    sequence *= n.name
                    w[i] = n.name
                    n.ndeps = typemax(Int64)
                    active += 1
                end
            end
        end

        # println(t,w...)

        for i in 1:nW
            if w[i] == '-'
                continue
            end

            n = graph[w[i]]
            n.duration -= 1

            if n.duration == 0
                for n2 in n.succ
                    graph[n2].ndeps -= 1
                end
                w[i] = '-'
                active -= 1
            end
        end
        t += 1
    end

    (sequence,t)
end

end # module
