
module Day12

const CHECKED = '\0'
const DIRS = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])

function parse_file(fname::String)
    first.(stack(split.(readlines(joinpath((@__DIR__), fname)), ""), dims = 1))
end

function get_regions!(grid::Array{Char, 2})
    regions = Vector{Set{CartesianIndex{2}}}()

    for idx in eachindex(IndexCartesian(), grid)
        if grid[idx] == CHECKED
            continue
        end

        plant = grid[idx]
        queue = [idx]
        rgn = Set{CartesianIndex{2}}()
        while !isempty(queue)
            ci = pop!(queue)
            push!(rgn, ci)
            grid[ci] = CHECKED
            for nbr in filter(x -> checkbounds(Bool, grid, x) && grid[x] == plant, ci .+ DIRS)
                push!(queue, nbr)
            end
        end
        push!(regions, rgn)
    end

    regions
end

function d12_p1(fname::String = "input")
    function eval_p1(region::Set{CartesianIndex{2}})
        area = length(region)
        perimeter = area * 4
        for ci in region
            perimeter -= count(x -> x ∈ region, ci .+ DIRS)
        end

        area * perimeter
    end

    mapreduce(eval_p1, +, get_regions!(parse_file(fname)))
end

function d12_p2(fname::String = "input")
    function eval_p2(region::Set{CartesianIndex{2}})
        turn_right90(x) = mod1(x + 1, length(DIRS))

        area = length(region)
        n_sides = 0
        for idx in eachindex(DIRS)
            edges = Set(x for x in region if x + DIRS[idx] ∉ region)
            n_sides += count(x -> x + DIRS[turn_right90(idx)] ∉ edges, edges)
        end

        area * n_sides
    end

    mapreduce(eval_p2, +, get_regions!(parse_file(fname)))
end

end #module

using .Day12: d12_p1, d12_p2
export d12_p1, d12_p2
