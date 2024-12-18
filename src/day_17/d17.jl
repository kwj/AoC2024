
module Day17

mutable struct Register
    A::Int64
    B::Int64
    C::Int64
end

const ADV::Int64 = 0
const BXL::Int64 = 1
const BST::Int64 = 2
const JNZ::Int64 = 3
const BXC::Int64 = 4
const OUT::Int64 = 5
const BDV::Int64 = 6
const CDV::Int64 = 7

function parse_file(fname::String)
    data = readlines(joinpath(@__DIR__, fname))
    sep_pos = findfirst(isempty, data)

    re = r".+: (\d+).+: (\d+).+: (\d+)"
    vs = parse.(Int64, match(re, join(data[1:sep_pos - 1])).captures)
    program = parse.(Int64, split(split(data[sep_pos + 1])[2], ","))

    Register(vs[1], vs[2], vs[3]), program
end

function run_program!(reg::Register, program::Vector{Int64})
    function combo_operand(operand::Int64)
        if operand <= 3
            operand
        elseif operand == 4
            reg.A
        elseif operand == 5
            reg.B
        else
            reg.C
        end
    end

    buf = Vector{Int64}()

    ip = 1  # instruction pointer
    while ip < length(program)
        # fetch
        opc = program[ip]
        opr = program[ip + 1]

        # decode & execute
        if opc == ADV
            reg.A >>>= combo_operand(opr)
        elseif opc == BXL
            reg.B ⊻= opr
        elseif opc == BST
            reg.B = combo_operand(opr) & 0b111
        elseif opc == JNZ
            if !iszero(reg.A)
                # set new address specified by the operand to the instruction
                # pointer, and repeat cycle (jump to the fetch stage)
                ip = opr + 1
                continue
            end
        elseif opc == BXC
            reg.B ⊻= reg.C
        elseif opc == OUT
            push!(buf, combo_operand(opr) & 0b111)
        elseif opc == BDV
            reg.B = reg.A >>> combo_operand(opr)
        elseif opc == CDV
            reg.C = reg.A >>> combo_operand(opr)
        end

        # set the next opcode address to the instruction pointer, and repeat cycle
        ip += 2
    end

    buf
end

function d17_p1(fname::String = "input")
    reg, program = parse_file(fname)

    println(join(string.(run_program!(reg, program)), ","))
end

#=
Observations of inputs and outputs, I felt the following points.

  - The seed value for calculation to output one-digit number is the lowest
    3-bits of the register `A`
  - The register `B` and `C` are overwritten with some values at the beginning of each loop
  - The value of the register `A` is shifted 3-bits to the right on each loop
  - Loop until the value of the register `A` is zero

I therefore decided to search for the initial value of the register `A` from the output result.
Specifically, they are as follows:

  1. The number `a1` to determine the last one-digit of the output is in `0 <= a1 < 8`.
  2. The number `a2` to determine the last two-digit of the output is in `a1 * 8 <= a2 < a1 * 8 + 8`.
  3. The number `a3` to determine the last three-digit of the output is in `a2 * 8 <= a3 < a2 * 8 + 8`.
    ...
=#
function d17_p2(fname::String = "input")
    function dfs(a::Int64, n::Int64)
        for i = 0:7
            if run_program!(Register(a + i, reg.B, reg.C), program) == program[n:end]
                if n == 1
                    return a + i
                end

                if (result = dfs((a + i) << 3, n - 1); !isnothing(result))
                    return result
                end
            end
        end

        nothing
    end

    reg, program = parse_file(fname)

    result = dfs(0, length(program))
    @assert !isnothing(result) "Can't find the answer"

    result
end

end #module

using .Day17: d17_p1, d17_p2
export d17_p1, d17_p2
