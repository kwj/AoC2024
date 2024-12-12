
module Day12

const MARKED = '\0'
const DIRS = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])

function parse_file(fname::String)
    first.(stack(split.(readlines(joinpath((@__DIR__), fname)), ""), dims = 1))
end

function get_regions!(grid::Array{Char, 2})
    regions = Vector{Set{CartesianIndex{2}}}()

    for idx in findall(isprint, grid)
        if grid[idx] == MARKED
            continue
        end

        ch = grid[idx]
        rgn = Set{CartesianIndex{2}}()
        queue::Vector{CartesianIndex{2}} = [idx]
        while !isempty(queue)
            ci = pop!(queue)
            grid[ci] = MARKED
            push!(rgn, ci)
            for nbr in filter(x -> checkbounds(Bool, grid, x) && grid[x] == ch, ci .+ DIRS)
                push!(queue, nbr)
            end
        end
        push!(regions, rgn)
    end

    regions
end

function eval_p1(region::Set{CartesianIndex{2}})
    area = length(region)
    perimeter = area * 4
    for ci in region
        perimeter -= count(x -> x ∈ region, ci .+ DIRS)
    end

    area * perimeter
end

function eval_p2(region::Set{CartesianIndex{2}})
    turn_right90(x) = mod1(x + 1, length(DIRS))

    area = length(region)
    n_sides = 0
    for idx in eachindex(DIRS)
        delta = DIRS[idx]
        edges = Set{CartesianIndex{2}}()
        for ci in region
            if ci + delta ∉ region
                push!(edges, ci)
            end
        end

        n_sides += count(x -> x + DIRS[turn_right90(idx)] ∉ edges, edges)
    end

    area * n_sides
end

function d12_p1(fname::String = "input")
    mapreduce(eval_p1, +, get_regions!(parse_file(fname)))
end

function d12_p2(fname::String = "input")
    mapreduce(eval_p2, +, get_regions!(parse_file(fname)))
end

end #module

using .Day12: d12_p1, d12_p2
export d12_p1, d12_p2
