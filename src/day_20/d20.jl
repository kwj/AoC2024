
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

function dijkstra(maze::Array{Char, 2}, start::CIdx{2}, goal::CIdx{2})
    DIRS = CIdx.([(-1, 0), (0, 1), (1, 0), (0, -1)])
    dist_tbl = fill(typemax(Int), size(maze)...)
    dist_tbl[start] = 0

    pq = PriorityQueue{CIdx{2}, Int}()
    pq[start] = 0
    while !isempty(pq)
        ci = dequeue!(pq)
        if ci == goal
            break
        end

        for new_ci in filter(x -> checkbounds(Bool, maze, x) && maze[x] != '#', ci .+ DIRS)
            new_dist = dist_tbl[ci] + 1
            if dist_tbl[new_ci] > new_dist
                dist_tbl[new_ci] = new_dist
                pq[new_ci] = new_dist
            end
        end
    end

    dist_map = Dict{CIdx{2}, Int}()
    foreach(CIndices(dist_tbl)) do ci
        if dist_tbl[ci] != typemax(Int)
            dist_map[ci] = dist_tbl[ci]
        end
    end

    dist_map
end

function count_savings(maze::Array{Char, 2}, cheat_dur::Int, thr::Int)
    start = findfirst(==('S'), maze)
    goal = findfirst(==('E'), maze)
    @assert !isnothing(start) && !isnothing(goal) "invalid map"

    dist_map = dijkstra(maze, start, goal)
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
