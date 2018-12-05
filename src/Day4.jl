module Day4
export part1, part2

using Lazy
using Dates


function parseLine(l)
    s = split(l, " ")
    d = s[1]*" "*s[2]
    (DateTime(d, "[yyyy-mm-dd HH:MM]"), s[3], s[4])
end

function events()
    open("input4") do f
        @as x eachline(f) begin
            map(parseLine, x)
            sort(x, lt=(x,y)->(x[1]<y[1]))
        end
    end
end

function sched()
    schedule = Dict{String, Array{Int64,1}}([])
    guard = ""
    sleep = 0
    for (dat, typ, id) in events()
        if typ == "Guard"
            guard = id
        elseif typ == "falls"
            sleep = Dates.minute(dat) + 1
        elseif typ == "wakes"
            wake = Dates.minute(dat)
            x = get(schedule, guard, zeros(Int64,60))
            x[sleep:wake] .+= 1
            schedule[guard] = x
        end
    end
    schedule
end

function part1()
    schedule = sched()
    guard = sort(collect(keys(schedule)), by=x->sum(schedule[x]), rev=true)[1]

    minute = argmax(schedule[guard]) - 1
    guard = parse(Int64, guard[2:end])
    minute * guard
end

function part2()
    schedule = sched()
    guard = sort(collect(keys(schedule)), by=x->maximum(schedule[x]), rev=true)[1]

    minute = argmax(schedule[guard]) - 1
    guard = parse(Int64, guard[2:end])
    minute * guard
end

end # module
