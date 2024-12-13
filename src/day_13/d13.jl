
module Day13

function parse_file(fname::String)
    terms = split(replace(read(joinpath(@__DIR__, fname), String) |> chomp, r"[^,\n\d]" => ""), r"[,\n]")
    seps = findall(isempty, terms)

    map(getindex.(Ref(terms), UnitRange.([1; seps .+ 1], [seps .- 1; length(terms)]))) do lst
        v = parse.(Int64, lst)
        (v[1], v[3], v[5], v[2], v[4], v[6])
    end
end

function play(claw1::Tuple{Int64, Int64, Int64}, claw2::Tuple{Int64, Int64, Int64})
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
    for (a1, b1, c1, a2, b2, c2) in machines
        result = play((a1, b1, c1), (a2, b2, c2))
        if isnothing(result)
            continue
        end

        A, B = result
        if A ∈ 1:100 && B ∈ 1:100  # Is this check necessary?
            tokens += 3 * A + B
        end
    end

    tokens
end

function d13_p2(fname::String = "input")
    machines = parse_file(fname)

    tokens = 0
    for (a1, b1, c1, a2, b2, c2) in machines
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
