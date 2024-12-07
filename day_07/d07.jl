
module Day07

struct Equation
    value::Int
    numbers::Vector{Int}
end

function parse_file(fname::String)
    map(split.(readlines(fname), ": ")) do line
        Equation(parse(Int, line[1]), map(x -> parse(Int, x), split(line[2], " ")))
    end
end

function d07_p1(fname::String = "input")
    function eval_p1(eq::Equation)
        @assert length(eq.numbers) > 1 "invalid data"

        reduce(eq.numbers[2:end]; init = [eq.numbers[1]]) do xs, n
            Iterators.flatmap(x -> [x * n, x + n], xs) |>
                collect |>
                filter(x -> x <= eq.value)
        end
    end

    data = parse_file(fname)
    map(x -> x.value, filter(eq -> eq.value ∈ eval_p1(eq), data)) |> sum
end

function d07_p2(fname::String = "input")
    function eval_p2(eq::Equation)
        @assert length(eq.numbers) > 1 "invalid data"

        reduce(eq.numbers[2:end]; init = [eq.numbers[1]]) do xs, n
            Iterators.flatmap(x -> [x * n, x + n, parse(Int, string(x) * string(n))], xs) |>
                collect |>
                filter(x -> x <= eq.value)
        end
    end

    data = parse_file(fname)
    map(x -> x.value, filter(eq -> eq.value ∈ eval_p2(eq), data)) |> sum
end

end #module

using .Day07: d07_p1, d07_p2
