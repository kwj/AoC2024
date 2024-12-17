
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

    ip = 1
    while ip < length(program)
        opc = program[ip]
        opr = program[ip + 1]
        if opc == ADV
            reg.A >>>= combo_operand(opr)
            ip += 2
        elseif opc == BXL
            reg.B ⊻= opr
            ip += 2
        elseif opc == BST
            reg.B = combo_operand(opr) & 0b111
            ip += 2
        elseif opc == JNZ
            if iszero(reg.A)
                ip += 2
            else
                ip = opr + 1
            end
        elseif opc == BXC
            reg.B ⊻= reg.C
            ip += 2
        elseif opc == OUT
            push!(buf, combo_operand(opr) & 0b111)
            ip += 2
        elseif opc == BDV
            reg.B = reg.A >>> combo_operand(opr)
            ip += 2
        elseif opc == CDV
            reg.C = reg.A >>> combo_operand(opr)
            ip += 2
        end
    end

    buf
end

function d17_p1(fname::String = "input")
    reg, program = parse_file(fname)

    buf = run_program!(reg, program)
    println(join(string.(buf), ","))
end

#=
Observations of inputs and outputs, I felt the following points.

  - Loop until the register of `A` is zero
  - `A`` is shifted 3 bits to the right in one loop
  - The calculation of the output value does not seem particularly meaningful

What is cleart that there is the relationship between the length of the output and
the range of initial value of `A`.

I therefore decided to search for the initial value of register `A` from the output result.
=#
function d17_p2(fname::String = "input")
    reg, program = parse_file(fname)

    len = length(program)
    uppers::Vector{Int64} = [(1 << (3 * len)) - 1]

    for n in reverse(0:(len - 1))
        block = 1 << (3 * n)
        uppers = Iterators.flatmap(uppers) do upper
            filter(Iterators.take(Iterators.countfrom(upper, -block), 8) |> collect) do x
                run_program!(Register(x, reg.B, reg.C), program)[(n + 1):end] == program[(n + 1):end]
            end
        end |> collect
    end

    minimum(uppers)
end

end #module

using .Day17: d17_p1, d17_p2
export d17_p1, d17_p2
