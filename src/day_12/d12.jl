
module Day12

const CHECKED = '\0'
const DIRS = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])

function parse_file(fname::String)
    first.(stack(split.(readlines(joinpath((@__DIR__), fname)), ""), dims = 1))
end

function get_regions!(grid::Array{Char, 2})
    regions = Vector{Set{CartesianIndex{2}}}()

    for idx in CartesianIndices(grid)
        if grid[idx] == CHECKED
            continue
        end

        plant = grid[idx]
        rgn = Set{CartesianIndex{2}}()

        grid[idx] = CHECKED
        push!(rgn, idx)
        queue = [idx]
        while !isempty(queue)
            ci = pop!(queue)
            for nbr in filter(x -> checkbounds(Bool, grid, x) && grid[x] == plant, ci .+ DIRS)
                grid[nbr] = CHECKED
                push!(rgn, nbr)
                push!(queue, nbr)
            end
        end
        push!(regions, rgn)
    end

    regions
end

function d12_p1(fname::String = "input")
    mapreduce(+, get_regions!(parse_file(fname))) do region
        area = length(region)
        perimeter = area * 4
        for ci in region
            perimeter -= count(x -> x ∈ region, ci .+ DIRS)
        end

        area * perimeter
    end
end

function d12_p2(fname::String = "input")
    turn_right90(x) = mod1(x + 1, length(DIRS))

    mapreduce(+, get_regions!(parse_file(fname))) do region
        area = length(region)
        n_sides = 0
        for idx in eachindex(DIRS)
            edges = Set(x for x in region if x + DIRS[idx] ∉ region)
            n_sides += count(x -> x + DIRS[turn_right90(idx)] ∉ edges, edges)
        end

        area * n_sides
    end
end

end #module

using .Day12: d12_p1, d12_p2
export d12_p1, d12_p2
