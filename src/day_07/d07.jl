
module Day07

struct Equation
    value::Int64
    numbers::Vector{Int64}
end

function parse_file(fname::String)
    map(split.(readlines(joinpath(@__DIR__, fname)), r":? +")) do lst
        vs = parse.(Int, lst)
        Equation(vs[1], vs[2:end])
    end
end

function d07_p1(fname::String = "input")
    function eval_p1(eqn::Equation)
        @assert length(eqn.numbers) > 1 "invalid data"

        reduce(eqn.numbers[2:end], init = eqn.numbers[1:1]) do xs, n
            Iterators.flatmap(x -> [x * n, x + n], xs) |>
                collect |>
                filter(x -> x <= eqn.value)
        end
    end

    mapreduce(+, filter(eqn -> eqn.value ∈ eval_p1(eqn), parse_file(fname))) do x
        x.value
    end
end

function d07_p2(fname::String = "input")
    function eval_p2(eqn::Equation)
        @assert length(eqn.numbers) > 1 "invalid data"

        reduce(eqn.numbers[2:end], init = eqn.numbers[1:1]) do xs, n
            Iterators.flatmap(x -> [x * n, x + n, x * 10 ^ ndigits(n) + n], xs) |>
                collect |>
                filter(x -> x <= eqn.value)
        end
    end

    mapreduce(+, filter(eqn -> eqn.value ∈ eval_p2(eqn), parse_file(fname))) do x
        x.value
    end
end

end #module

using .Day07: d07_p1, d07_p2
export d07_p1, d07_p2
