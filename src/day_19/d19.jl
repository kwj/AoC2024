
module Day19

function parse_file(fname::String)
    data = readlines(joinpath(@__DIR__, fname))

    towels = split(data[1], ", ")
    designs = data[3:end]

    towels, designs
end

function is_possible(d::AbstractString, towels::Vector{SubString{String}})
    iszero(length(d)) || any(towels) do x
        if startswith(d, x)
            is_possible((@view d[length(x) + 1:end]), towels)
        else
            false
        end
    end
end

function count_combinations(d::AbstractString, towels::Vector{SubString{String}}, memo::Dict{String, Int64})
    # I don't know the reason why using the `get!()` function increases number of memory allocations.
    if !haskey(memo, d)
        memo[d] = sum(towels) do x
            if startswith(d, x)
                count_combinations((@view d[length(x) + 1:end]), towels, memo)
            else
                0
            end
        end
    end

    memo[d]
end

function d19_p1(fname::String = "input")
    towels, designs = parse_file(fname)

    count(design -> is_possible(design, towels), designs)
end

function d19_p2(fname::String = "input")
    towels, designs = parse_file(fname)
    memo = Dict{String, Int64}("" => 1)

    sum(design -> count_combinations(design, towels, memo), designs)
end


#=
alternative version:

function parse_file(fname::String)
    data = readlines(joinpath(@__DIR__, fname))

    towels = map(t -> (t, length(t)), split(data[1], ", "))
    designs = data[3:end]

    towels, designs
end

function find_combinations(design::String, towels::Vector{Tuple{SubString{String}, Int}})
    memo = Dict{Int, Int}()

    function aux(idx::Int)
        if idx > length(design)
            1
        else
            get!(memo, idx) do
                mapreduce(+, filter(x -> startswith((@view design[idx:end]), x[1]), towels), init = 0) do towel
                    aux(idx + towel[2])
                end
            end
        end
    end

    aux(1)
end

function d19_p1(fname::String = "input")
    towels, designs = parse_file(fname)

    count(design -> !iszero(find_combinations(design, towels)), designs)
end

function d19_p2(fname::String = "input")
    towels, designs = parse_file(fname)

    sum(design -> find_combinations(design, towels), designs)
end

=#

end #module

using .Day19: d19_p1, d19_p2
export d19_p1, d19_p2
