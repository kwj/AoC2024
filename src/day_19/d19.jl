
module Day19

function parse_file(fname::String)
    data = readlines(joinpath(@__DIR__, fname))

    towels = split(data[1], ", ")
    designs = data[3:end]

    towels, designs
end

function is_possible(design::AbstractString, towels::Vector{SubString{String}})
    if iszero(length(design))
        return true
    end

    any(towels) do towel
        if startswith(design, towel)
            is_possible(design[length(towel) + 1:end], towels)
        else
            false
        end
    end
end

function count_combinations(design::AbstractString, towels::Vector{SubString{String}}, memo::Dict{String, Int})
    function aux(d::AbstractString)
        if haskey(memo, d)
            return memo[d]
        end

        if iszero(length(d))
            return 1
        end

        ret = sum(towels) do towel
            if startswith(d, towel)
                aux(d[length(towel) + 1:end])
            else
                0
            end
        end
        if !haskey(memo, ret)
            memo[d] = ret
        end

        ret
    end

    aux(design)
end

function d19_p1(fname::String = "input")
    towels, designs = parse_file(fname)

    count(design -> is_possible(design, towels), designs)
end

function d19_p2(fname::String = "input")
    towels, designs = parse_file(fname)
    memo = Dict{String, Int}()

    sum(design -> count_combinations(design, towels, memo), designs)
end


#=
alternative version: a little slow

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
                mapreduce(+, filter(x -> startswith(design[idx:end], x[1]), towels), init = 0) do towel
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
