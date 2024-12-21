
module Day20

import DataStructures: PriorityQueue, dequeue!

const CIdx = CartesianIndex
const CIndices = CartesianIndices

struct Delta
    move::CIdx{2}
    dist::Int  # Manhattan distance
end

function parse_file(fname::String)
    first.(stack(split.(readlines(joinpath(@__DIR__, fname)), ""), dims = 1))
end

function get_path_info(grid::Array{Char, 2}, start::CIdx{2}, goal::CIdx{2})
    DIRS = CIdx.([(-1, 0), (0, 1), (1, 0), (0, -1)])
    dist_tbl = fill(typemax(Int), size(grid)...)

    dist_tbl[start] = dist = 0
    pos = start
    while pos != goal
        pos = first(filter(x -> grid[x] != '#' && dist_tbl[x] == typemax(Int), pos .+ DIRS))
        dist += 1
        dist_tbl[pos] = dist
    end

    dist_map = Dict{CIdx{2}, Int}()
    foreach(CIndices(dist_tbl)) do ci
        if dist_tbl[ci] != typemax(Int)
            dist_map[ci] = dist_tbl[ci]
        end
    end

    dist_map
end

function count_savings(grid::Array{Char, 2}, cheat_dur::Int, thr::Int)
    start = findfirst(==('S'), grid)
    goal = findfirst(==('E'), grid)
    @assert !isnothing(start) && !isnothing(goal) "invalid map"

    dist_map = get_path_info(grid, start, goal)
    delta_lst = filter(collect(Iterators.product(-cheat_dur:cheat_dur, -cheat_dur:cheat_dur))) do (x, y)
        1 < abs(x) + abs(y) <= cheat_dur
    end |> lst -> map(x -> Delta(CIdx(x), abs(x[1]) + abs(x[2])), lst)

    acc = 0
    for src in keys(dist_map)
        for d in delta_lst
            dest = src + d.move
            if haskey(dist_map, dest)
                if (dist_map[dest] - dist_map[src]) - d.dist >= thr
                    acc += 1
                end
            end
        end
    end

    acc
end

function d20_p1(fname::String = "input"; thr::Int = 100)
    @assert thr > 0 "The threshold must be greater than 0"

    count_savings(parse_file(fname), 2, thr)
end

function d20_p2(fname::String = "input"; thr::Int = 100)
    @assert thr > 0 "The threshold must be greater than 0"

    count_savings(parse_file(fname), 20, thr)
end

end #module

using .Day20: d20_p1, d20_p2
export d20_p1, d20_p2
