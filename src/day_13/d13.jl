
module Day13

function parse_file(fname::String)
    data = map(eachmatch(r"\d+", read(joinpath(@__DIR__, fname), String))) do m
        parse(Int64, m.match)
    end
    reshape(data, 6, :) |> eachcol .|> Tuple
end

function play(claw1::NTuple{3, Int64}, claw2::NTuple{3, Int64})
    # two linear Diophantine equations
    #   a1 * A + b1 * B = c1
    #   a2 * A + b2 * B = c2
    a1, b1, c1 = claw1
    a2, b2, c2 = claw2

    # Each equation must have integer solutions
    if !iszero(rem(c1, gcd(a1, b1))) || !iszero(rem(c2, gcd(a2, b2)))
        return nothing
    end

    # If `b1 * a2 - b2 * a1` is equal to 0, another processes is required.
    # Fortunately, there were no such cases in the given data, so it cut corners.
    @assert !iszero(b1 * a2 - b2 * a1) "These two lines are parallel or coincident lines"
    B = (c1 * a2 - c2 * a1) / (b1 * a2 - b2 * a1)
    A = (c1 - b1 * B) / a1

    # The coordinates of the intersection of two lines must be integers
    if isinteger(A) && isinteger(B)
        Int64(A), Int64(B)
    else
        nothing
    end
end

function d13_p1(fname::String = "input")
    machines = parse_file(fname)

    tokens = 0
    for (a1, a2, b1, b2, c1, c2) in machines
        result = play((a1, b1, c1), (a2, b2, c2))
        if isnothing(result)
            continue
        end

        A, B = result
        if A ∈ 0:100 && B ∈ 0:100  # Is this check necessary?
            tokens += 3 * A + B
        end
    end

    tokens
end

function d13_p2(fname::String = "input")
    machines = parse_file(fname)

    tokens = 0
    for (a1, a2, b1, b2, c1, c2) in machines
        result = play((a1, b1, c1 + 10_000_000_000_000), (a2, b2, c2 + 10_000_000_000_000))
        if isnothing(result)
            continue
        end

        A, B = result
        tokens += 3 * A + B
    end

    tokens
end

end #module

using .Day13: d13_p1, d13_p2
export d13_p1, d13_p2
