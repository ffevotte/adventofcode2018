module Day19
export part1, part2, puzzle

using Lazy
using DataStructures
using AOC
using AOC.Day16: run

function readProgram()
    open("input19") do f
        ipReg = @> readline(f) begin
            split(" ")
            x->x[2]
            toInt
        end

        program = map(eachline(f)) do l
            (op, a, b, c) = split(l, " ") |> Tuple
            (op, toInt.((a, b ,c))...)
        end
        ipReg, program
    end
end

function puzzle(initReg0)
    ipReg, program = readProgram()
    registers = [0 for i in 1:6]
    registers[1] = initReg0
    ip = 0

    # Only perform the first few iterations to initialize R1
    N = 1
    Nmax = 100
    while ip < length(program) && N<Nmax
        instr = program[ip+1]
        registers[ipReg+1] = ip

        run(instr..., registers)
        ip = registers[ipReg+1] + 1

        N += 1
    end

    if N == Nmax
        # Compute the sum of all factors of R1
        sumFactors(registers[2])
    else
        registers[1]
    end
end

function sumFactors(n)
    s = 0
    for k in 1:Int(round(sqrt(n)))
        (d, r) = divrem(n,k)
        if r == 0
            s += d + k
        end
    end
    s
end

# IP   Instr         Explanation
# --------------------------------------------------------------
# 0    addi 5 16 5   goto 17 # -> initialize R1
# 17   addi 1 2  1   # Some code related to initialization of R1
# 18   mulr 1 1  1
# 19   mulr 5 1  1
# 20   muli 1 11 1
# 21   addi 4 7  4
# 22   mulr 4 5  4
# 23   addi 4 20 4
# 24   addr 1 4  1
# 25   addr 5 0  5   if R0 == 0
#                       # End of the initialization in part1 (when R0 = 0 initially)
# 26   seti 0 4  5      goto 1
#                    end
#
# 27   setr 5 9  4   # Some more initialization code for part 2
# 28   mulr 4 5  4   # (when R0 == 1 initially)
# 29   addr 5 4  4
# 30   mulr 5 4  4
# 31   muli 4 14 4
# 32   mulr 4 5  4
# 33   addr 1 4  1
# 34   seti 0 2  0   R0 = 0
# 35   seti 0 5  5   goto 1
#
#                    # Beginning of the program body
# 1    seti 1 0  3   R3 = 1
#                    loop1:
# 2    seti 1 2  2       R2 = 1
#                        loop2:
# 3    mulr 3 2  4
# 4    eqrr 4 1  4           if R1 == R2*R3
# 7    addr 3 0  0               R0 += R3
#                            end
# 8    addi 2 1  2           R2 += 1
# 9    gtrr 2 1  4           if R2 > R1
# 10   addr 5 4  5               break    (goto 12)
#                            end
# 11   seti 2 7  5       end              (goto 3)
# 12   addi 3 1  3       R3 += 1
# 13   gtrr 3 1  4       if R3 > R1
# 16   mulr 5 5  5           exit         (goto 256)
#                        end
# 15   seti 1 3  5   end                  (goto 2)

end # module
