module Day16
export part1, part2, puzzle

using Lazy
using DataStructures

macro op(op, typA, typB)
    a = (typA == :r) ? :(r[a+1]) : :a
    b = (typB == :r) ? :(r[b+1]) : :b
    b = (typB == 0)  ? 0         : b
    quote
        (a,b,c,r) -> begin
            r[c+1] = Int(($op)($a, $b))
            r
        end
    end
end

opcode = Dict(
    "addr" => @op(+,  r, r),
    "addi" => @op(+,  r, i),
    "mulr" => @op(*,  r, r),
    "muli" => @op(*,  r, i),
    "borr" => @op(|,  r, r),
    "bori" => @op(|,  r, i),
    "setr" => @op(+,  r, 0),
    "seti" => @op(+,  i, 0),
    "gtir" => @op(>,  i, r),
    "gtri" => @op(>,  r, i),
    "gtrr" => @op(>,  r, r),
    "eqir" => @op(==, i, r),
    "eqri" => @op(==, r, i),
    "eqrr" => @op(==, r, r),
    "banr" => @op((x,y)->x&y, r, r),
    "bani" => @op((x,y)->x&y, r, i),
)

run(op, a, b, c, r) = opcode[op](a,b,c,r)

function readSample(f)
    before = @as _x_ readline(f) begin
        match(r"\[(.*)\]", _x_)
        _x_.captures[1]
        split(_x_, ",")
        map(x->parse(Int,x), _x_)
    end

    args = @as _x_ readline(f) begin
        split(_x_, " ")
        map(x->parse(Int,x), _x_)
    end

    after = @as _x_ readline(f) begin
        match(r"\[(.*)\]", _x_)
        _x_.captures[1]
        split(_x_, ",")
        map(x->parse(Int,x), _x_)
    end

    readline(f)

    (before, args, after)
end

function part1()
    COUNT = 0
    open("input16") do f
        try
            while true
                before, args, after = readSample(f)
                count = 0
                for op in keys(opcode)
                    if after == run(op, args[2], args[3], args[4], deepcopy(before))
                        count += 1
                    end
                end
                if count >= 3
                    COUNT += 1
                end
            end
        catch
            nothing
        end
    end
    COUNT
end

function part2()
    open("input16") do f
        OPNAME = collect(keys(opcode))
        OPCODE = zeros(Int32, 16,16)

        try
            while true
                before, args, after = readSample(f)
                for i = 1:16
                    op = OPNAME[i]
                    if after == run(op, args[2], args[3], args[4], deepcopy(before))
                        OPCODE[i, args[1]+1] += 1
                    end
                end
            end
        catch e
            opname = ["" for i in 1:16]
            for k = 1:16
                for j = 1:16
                    if count(x->x>0, OPCODE[1:end,j]) == 1
                        i = argmax(OPCODE[1:end,j])
                        fill!(view(OPCODE, i, :), 0)
                        opname[j] = OPNAME[i]
                    end
                end
            end

            registers = [0, 0, 0, 0]
            foreach(eachline(f)) do line
                if strip(line) == ""
                    return
                end

                arg = @>>  split(line, " ")  map(x->parse(Int,x))
                run(opname[arg[1]+1], arg[2], arg[3], arg[4], registers)
            end
            registers[1]
        end
    end
end

end # module
