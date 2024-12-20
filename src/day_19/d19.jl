
module Day19

struct Towel
    pattern::String
    len::Int64
end

function parse_file(fname::String)
    data = readlines(joinpath(@__DIR__, fname))

    towels = map(t -> Towel(t, length(t)), split(data[1], ", "))
    designs = data[3:end]

    towels, designs
end

function is_possible(d::AbstractString, towels::Vector{Towel})
    isempty(d) || any(towels) do x
        if startswith(d, x.pattern)
            is_possible((@view d[x.len + 1:end]), towels)
        else
            false
        end
    end
end

function count_combinations(d::AbstractString, towels::Vector{Towel}, memo::Dict{String, Int64})
    # I don't know the reason why using the `get!()` function increases number of memory allocations.
    if !haskey(memo, d)
        memo[d] = sum(towels) do x
            if startswith(d, x.pattern)
                count_combinations((@view d[x.len + 1:end]), towels, memo)
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
alternative version: a little slow

function count_combinations(design::String, towels::Vector{Towel})
    count_combinations_aux(1, design, towels, Dict{Int, Int}())
end

function count_combinations_aux(idx::Int, design::String, towels::Vector{Towel}, memo::Dict{Int64, Int64})
    if idx > length(design)
        1
    else
        get!(memo, idx) do
            mapreduce(+, filter(x -> startswith((@view design[idx:end]), x.pattern), towels), init = 0) do towel
                count_combinations_aux(idx + towel.len, design, towels, memo)
            end
        end
    end
end

function d19_p2(fname::String = "input")
    towels, designs = parse_file(fname)

    sum(design -> count_combinations(design, towels), designs)
end

=#

end #module

using .Day19: d19_p1, d19_p2
export d19_p1, d19_p2
