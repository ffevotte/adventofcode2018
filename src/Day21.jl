module Day21
export part1, part2, puzzle

using Lazy
using DataStructures
using AOC

using AOC.Day16: run
using AOC.Day19: readProgram

r"""
IP   Instr                    |  Low level                            | Equivalent code
------------------------------------------------------------------------------------------------
     #ip 2                    |                                       |
 0   seti 123     0        3  |    R3 = 123                           | \
                              |  lbl1:                                | | Useless
 1   bani 3       456      3  |    R3 &= 456                          | | stuff
 2   eqri 3       72       3  |    if R3 == 72                        | |
 3   addr 3       2        2  |      goto lbl5                        | |
 4   seti 0       0        2  |    goto lbl1                          | /
                              |  lbl5:                                |
 5   seti 0       0        3  |    R3 = 0                             |   R3 = 0
                              |  lbl6:                                |   do
 6   bori 3       65536    1  |    R1 = R3 | 65536                    |       R1 = R3 | 65536
 7   seti 4921097 0        3  |    R3 = 4921097                       |       R3 = 4921097
                              |  lbl8:                                |       while true
 8   bani 1       255      4  |    R4 = R1 & 255                      | \         R3 += (R1 & 255)
 9   addr 3       4        3  |    R3 += R4                           | |         R3 &= 16777215
10   bani 3       16777215 3  |    R3 &= 16777215                     | |         R3 *= 65899
11   muli 3       65899    3  |    R3 *= 65899                        | |         R3 &= 16777215
12   bani 3       16777215 3  |    R3 &= 16777215                     | /
13   gtir 256     1        4  |    if 256 > R1                        |    \      if R1 < 256
14   addr 4       2        2  |        pass             (goto lbl16)  |    |          break
16   seti 27      8        2  |        goto lbl28                     |    |      end
15   addi 2       1        2  |    pass                 (goto lbl17)  |    /
17   seti 0       5        4  |    R4 = 0                             | \
                              |    loop                 (lbl18)       | |
18   addi 4       1        5  |        -                              | |         R1 = floor(R1 / 256)
19   muli 5       256      5  |        R5 = 256 * (R4+1)              | |
20   gtrr 5       1        5  |        if R5 > R1                     | |
21   addr 5       2        2  |            pass         (goto lbl23)  | |
23   seti 25      1        2  |            pass         (goto lbl26)  | |
26   setr 4       3        1  |            R1 = R4                    | |
27   seti 7       9        2  |            goto lbl8                  | |
22   addi 2       1        2  |        pass             (goto lbl24)  | |
24   addi 4       1        4  |        R4 += 1                        | /
25   seti 17      8        2  |    end                  (goto lbl18)  |       end
                              |  lbl28:                               | \
28   eqrr 3       0        4  |    if R0 == R3                        | | while R0 != R3
29   addr 4       2        2  |        EXIT             (goto lbl31)  | /
30   seti 5       4        2  |    goto lbl6                          |
"""

# Slow variant: run the given program in our VM
function puzzle_slow(N)
    k = 0
    r3old = 0
    seen = Set{Int64}()

    ipReg, program = readProgram("input21")
    registers = [0 for i in 1:6]
    ip = 0

    while ip <= length(program)
        instr = program[ip+1]
        registers[ipReg+1] = ip

        if ip == 28
            k += 1

            # part 1
            k == N && return registers[4]

            # part 2
            if registers[4] in seen
                return r3old
            else
                push!(seen, registers[4])
                r3old = registers[4]
            end
        end

        # print("$ip\t$registers\t")
        run(instr..., registers)
        # println("$instr\t$registers")

        ip = registers[ipReg+1] + 1
    end
end

# Fast variant: re-implement the given program in Julia
function puzzle(N)
    seen = Set{Int64}()
    r3old = 0

    r3 = 0
    for k in Iterators.countfrom(0)
        # part 1
        #  stop the first time
        k == N && return r3

        # part 2
        #  return last value before cycle
        if r3 in seen
            return r3old
        else
            push!(seen, r3)
            r3old = r3
        end

        r1 = r3 | 65536
        r3 = 4921097
        while true
            r3 += r1 & 255
            r3 &= 16777215
            r3 *= 65899
            r3 &= 16777215

            if r1 < 256
                break
            end

            r1 = floor(r1 / 256) |> Int
        end
    end
end



end # module
