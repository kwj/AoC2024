
module Day24

import Printf: @printf, @sprintf

mutable struct LogicGate
    id::Int
    op::Symbol
    inp::NTuple{2, String}
    out::String
    LogicGate(id, op, i1, i2, o) = new(id, op, (i1, i2), o)
end

mutable struct Circuit
    wires::Dict{String, Bool}
    gates::Vector{LogicGate}
    swapped::Vector{String}
    Circuit(w, g) = new(w, g, Vector())
end

function parse_file(fname::String)
    op_map = Dict{String, Symbol}("AND" => :AND, "OR" => :OR, "XOR" => :XOR)
    wires = Dict{String, Bool}()
    gates = Vector{LogicGate}()

    data = readlines(joinpath(@__DIR__, fname))
    sep_pos = findfirst(isempty, data)

    foreach(data[1:sep_pos - 1]) do line
        tag, state = split(line, ": ")
        wires[tag] = parse(Bool, state)
    end

    foreach(pairs(data[sep_pos + 1:end])) do (id, line)
        i1, f, i2, o  = map(m -> m.match, collect(eachmatch(r"[[:alnum:]]+", line)))
        push!(gates, LogicGate(id, op_map[f], i1, i2, o))
    end

    wires, gates
end

function op(func::Symbol, x::Bool, y::Bool)
    func == :AND && return x & y
    func == :OR && return x | y
    func == :XOR && return x ⊻ y

    error("invalid func")
end

function to_decimal(wires::Dict{String, Bool}, prefix::Char)
    ans = 0
    for (i, key) in pairs(sort(filter(k -> k[1] == prefix, collect(keys(wires)))))
        @assert i == parse(Int, key[2:end]) + 1 "mismatch!"
        if wires[key]
            ans |= 1 << (i - 1)
        end
    end

    ans
end

function simulate(wires::Dict{String, Bool}, gates::Vector{LogicGate})
    next_gates = Vector{LogicGate}()
    while !isempty(gates)
        empty!(next_gates)
        for g in gates
            if all(haskey(wires, i) for i in g.inp)
                wires[g.out] = op(g.op, map(i -> wires[i], g.inp)...)
            else
                push!(next_gates, g)
            end
        end
        gates = copy(next_gates)
    end

    to_decimal(wires, 'z')
end

function d24_p1(fname::String = "input")
    wires, gates = parse_file(fname)

    simulate(wires, gates)
end

#=
The given data may be a ripple-carry adder circuit.

  $ grep -e '->' input | grep -e 'x[0-9]' | awk '{print $1, $3}' | sed -e 's/[xy]//g' | sort | uniq -c
        2 00 00
        2 01 01
        2 02 02
         ....
        2 42 42
        2 43 43
        2 44 44
  $ grep -e '->' input | grep -e 'z[0-9]' | awk '{print $5}' | sort
  z00
  z01
  ...
  z44
  z45
  $ grep -e '->' input | grep -e 'z[0-9]' | awk '{print $5}' | sort | wc -l
  46

The input/output wires between adders would be as follows.

  [MSB]                                                                        [LSB]
            x44 y44          x43 y43                       x01 y01          x00 y00
             v   v            v   v                         v   v            v   v
            +-----+          +-----+                       +-----+          +-----+
   .-(C45)-.| FA  | <-(C44)- | FA  | <-(C43)- ... <-(C02)- | FA  | <-(C01)- | HA  |
   |        +-----+          +-----+                       +-----+          +-----+
   v           v                v                             v                v
  z45         z44              z43                           z01              z00

      * HA: half adder, FA: full adder

  $ grpe -e '->' input | wc -l
  222

  python> divmod(222, 45 - 1)
  (5, 2)

So, HA circuit would have two gates and FA circuit would have five gates.
Perhaps each circuit would look like the following:

  HA:
   A(x00) ----+--> +-----+
              |    | XOR | --> S(z00)
   B(y00) --+----> +-----+
            | |
            | .--> +-----+
            |      | AND | --> C01
            .----> +-----+

     A xor B = S
     A and B = Cout

  FA:
   A(x##) ----+--> +------+   T
              |    | XOR1 | -+--> +------+
   B(y##) --+----> +------+  |    | XOR2 |
            | |              |    |      | --------------> S(z##)
      C## -----------------+----> +------+
            | |            | |
            | |            | .--> +------+  V
            | |            |      | AND2 | ---> +----+
            | |            .----> +------+      | OR | --> C[## + 1]
            | |                       .-------> +----+
            | .--> +------+      U    |
            |      | AND1 | ----------.
            .----> +------+

     A xor B = T
     A and B = U
     T xor Cin = S
     T and Cin = V
     U or V = Cout
=#

tag(ch::Char, n::Int) = @sprintf "%c%02d" ch n

function find_gates(
    gates::Vector{LogicGate},
    inp::Vector{String};
    op::Union{Symbol, Nothing} = nothing,
    out::Union{String, Nothing} = nothing,
    mode::Symbol = :ALL
)
    @assert !isempty(inp) "there are no input wire names"

    if mode == :ALL
        result = filter(gate -> all(i -> i ∈ gate.inp, inp), gates)
    elseif mode == :ANY
        result = filter(gate -> any(i -> i ∈ gate.inp, inp), gates)
    else
        @error "invalid mode"
    end

    !isnothing(op) && begin result = filter(x -> x.op == op, result) end
    !isnothing(out) && begin result = filter(x -> x.out == out, result) end

    result
end

# Half adder
function check_adder(c::Circuit, idx::Int, verbose = false)
    x_in, y_in = tag('x', idx), tag('y', idx)
    XOR = first(find_gates(c.gates, [x_in, y_in], op = :XOR))
    AND = first(find_gates(c.gates, [x_in, y_in], op = :AND))

    if XOR.out == tag('z', idx)
        AND.out
    else
        if verbose
            # wrong adder
            println("[Wrong Adder]")
            println("No.: ", idx)
            println("  Cin: ", cin)
            println("  XOR: ", XOR)
            println("  AND: ", AND)
        end

        (idx, [XOR, AND])
    end
end

function is_valid_FA(XOR1::LogicGate, XOR2::LogicGate, AND1::LogicGate, AND2::LogicGate, OR::LogicGate, idx::Int)
    XOR1.out ∉ XOR2.inp && return false
    XOR1.out ∉ AND2.inp && return false
    AND1.out ∉ OR.inp && return false
    AND2.out ∉ OR.inp && return false
    XOR2.out == tag('z', idx)
end

# Full adder
function check_adder(c::Circuit, idx::Int, c_in::String, verbose = false)
    # Note: It is assumed that only one gate is found in the follwoing searches.

    # Names of input wires from outside the adder are reliable. (x##, y## and carry-in)
    x_in, y_in = tag('x', idx), tag('y', idx)
    XOR1 = find_gates(c.gates, [x_in, y_in], op = :XOR) |> first
    AND1 = find_gates(c.gates, [x_in, y_in], op = :AND) |> first
    XOR2 = find_gates(c.gates, [c_in], op = :XOR) |> first
    AND2 = find_gates(c.gates, [c_in], op = :AND) |> first

    # Append `mode = :ANY` for search based on the output wire names of the internal gates.
    OR = find_gates(c.gates, [AND1.out, AND2.out], op = :OR, mode = :ANY) |> first

    if is_valid_FA(XOR1, XOR2, AND1, AND2, OR, idx)
        return OR.out
    else
        if verbose
            # wrong adder
            println("[Wrong Adder]")
            println("No.: ", idx)
            println("  Cin: ", c_in)
            println("  XOR1: ", XOR1)
            println("  XOR2: ", XOR2)
            println("  AND1: ", AND1)
            println("  AND2: ", AND2)
            println("  OR: ", OR)
        end

        (idx, [XOR1, XOR2, AND1, AND2, OR])
    end
end

function fix_adder(c::Circuit, tpl::Tuple{Int, Vector{LogicGate}}, verbose = false)
    idx, lg_vec = tpl
    ns = map(lg -> lg.id, lg_vec)

    if idx == 0
        # Half adder
        XOR, AND = c.gates[ns[1]], c.gates[ns[2]]
        XOR.out, AND.out = AND.out, XOR.out
        push!(c.swapped, XOR.out, AND.out)

        if verbose
            println("\nSwapped output lines: ", XOR.out, ", ", AND.out)
        end

        return AND.out
    else
        # Full adder
        #
        # The following process assumes that there is at most one failure,
        # two output lines are only swapped, per an adder.
        for i = 1:(lastindex(ns) - 1), j = 2:lastindex(ns)
            # swap
            lg_vec[i].out, lg_vec[j].out = lg_vec[j].out, lg_vec[i].out

            if is_valid_FA(lg_vec..., idx)
                push!(c.swapped, lg_vec[i].out, lg_vec[j].out)
                if verbose
                    println("\nSwapped output lines: ", lg_vec[i].out, ", ", lg_vec[j].out, "\n")
                end

                return lg_vec[end].out
            end

            # restore
            lg_vec[i].out, lg_vec[j].out = lg_vec[j].out, lg_vec[i].out
        end
    end

    @error "panic!"
end

function d24_p2(fname::String = "input"; verbose = false)
    C = Circuit(parse_file(fname)...)
    n_adders = count(k -> k[1] == 'x', collect(keys(C.wires)))

    carry_in = ""
    for idx = 0:(n_adders - 1)
        # idx == 0 -> Half adder, otherwise -> Full adder
        result = iszero(idx) ? check_adder(C, idx, verbose) : check_adder(C, idx, carry_in, verbose)
        carry_in = typeof(result) == String ? result : fix_adder(C, result, verbose)
    end

    if verbose
        # validation
        x = to_decimal(C.wires, 'x')
        y = to_decimal(C.wires, 'y')
        z = simulate(C.wires, C.gates)

        @printf "x = %d, y = %d, x + y = %d\n" x y (x + y)
        @printf "Simulation result: %d  -- " z
        x + y == z ? println("Matched.\n") : println("Mismatched.\n")
    end

    join(sort(C.swapped), ",")
end

end #module

using .Day24: d24_p1, d24_p2
export d24_p1, d24_p2
