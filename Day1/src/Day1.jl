module Day1
export part1, part2

using Lazy

function part1()
    @>> "input" begin
        eachline
        map(x->parse(Int64,x))
        sum
    end
end

function part2()
    let l = [0] ::Array{Int64,1}
        s = 0
        found = false
        while(!found)
            open("input") do f
                for x in eachline(f)
                    x = parse(Int64, x)
                    s += x
                    if s in l
                        found = true
                        return s
                    else
                        push!(l, s)
                    end
                end
            end
        end
        s
    end
end


end # module
