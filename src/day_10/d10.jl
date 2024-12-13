
module Day10

const NBRS = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])

function parse_file(fname::String)
    parse.(Int, stack(split.(readlines(joinpath(@__DIR__, fname)), ""), dims = 1))
end

function find_goals(grid::Array{Int, 2}, start::CartesianIndex{2})
    reduce(1:9, init = [start]) do xs, n
        Iterators.flatmap(
            x -> x .+ NBRS |> filter(pos -> checkbounds(Bool, grid, pos) && grid[pos] == n),
            xs
        ) |> collect
    end
end

function d10_p1(fname::String = "input")
    grid = parse_file(fname)

    mapreduce(+, findall(iszero, grid)) do ci
        find_goals(grid, ci) |> unique |> length
    end
end

function d10_p2(fname::String = "input")
    grid = parse_file(fname)

    mapreduce(+, findall(iszero, grid)) do ci
        find_goals(grid, ci) |> length
    end
end

end #module

using .Day10: d10_p1, d10_p2
export d10_p1, d10_p2
