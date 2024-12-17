
module Day16

import DataStructures: PriorityQueue, dequeue!

const CIdx = CartesianIndex

# North(1), East(2), South(3), West(4)
const DIRS = CIdx.([(-1, 0, 0), (0, 1, 0), (1, 0, 0), (0, -1, 0)])

function parse_file(fname::String)
    first.(stack(split.(readlines(joinpath(@__DIR__, fname)), ""), dims = 1)) |> pre_processing!
end

# Fill all dead-end paths
#
# Note:
# This preprocessing is not mandatory. This program works properly
# even if this preprocessing is not performed.
function pre_processing!(maze::Array{Char, 2})
    dirs_2d = CIdx.([(-1, 0), (0, 1), (1, 0), (0, -1)])

    for ci in findall(==('.'), maze)
        while maze[ci] == '.'
            adj_walls = map(x -> maze[x] == '#', ci .+ dirs_2d)
            if count(adj_walls) < 3
                break
            end

            maze[ci] = '#'

            if count(adj_walls) == 3
                ci += dirs_2d[findfirst(!identity, adj_walls)]
            end
        end
    end

    maze
end

function dijkstra(maze::Array{Char, 2}, start::CIdx{3}, goal::CIdx{2})
    function do_next_step!(crnt_idx::CIdx{3}, new_idx::CIdx{3}, inc::Int)
        new_pt = points[crnt_idx] + inc

        if new_pt == points[new_idx]
            push!(path_info[new_idx], crnt_idx)
        elseif new_pt < points[new_idx]
            path_info[new_idx] = [crnt_idx]
            points[new_idx] = new_pt
            pq[new_idx] = new_pt
        end
    end

    points = fill(typemax(Int), size(maze)..., 4)
    points[start] = 0
    path_info = Array{Union{Nothing, Vector{CIdx{3}}}}(nothing, size(maze)..., 4)

    pq = PriorityQueue{CIdx{3}, Int}()
    pq[start] = 0

    while !isempty(pq)
        ci = dequeue!(pq)
        if points[ci] >= minimum(points[Tuple(goal)..., :])
            continue
        end

        # front side
        new_ci = ci + DIRS[ci[3]]
        if maze[new_ci[1], new_ci[2]] != '#'
            do_next_step!(ci, new_ci, 1)
        end

        # left and right sides
        foreach(mod1.([ci[3] + 1, ci[3] - 1], 4)) do d
            new_ci = CIdx(ci[1], ci[2], d)
            chk_ci = new_ci + DIRS[d]
            if maze[chk_ci[1], chk_ci[2]] != '#'
                do_next_step!(ci, new_ci, 1_000)
            end
        end
    end

    points, path_info
end

function d16_p1(fname::String = "input")
    maze = parse_file(fname)
    start = CIdx(Tuple(findfirst(==('S'), maze))..., 2)  # 2: East
    goal_2d = findfirst(==('E'), maze)

    points, _ = dijkstra(maze, start, goal_2d)

    minimum(points[Tuple(goal_2d)..., :])
end

function d16_p2(fname::String = "input")
    to_2d_idx(ci::CIdx{3}) = CIdx(ci[1], ci[2])

    function dfs(ci::CIdx{3}, visited::Set{CIdx{2}})
        push!(visited, to_2d_idx(ci))

        nexts = path_info[ci]
        if !isnothing(nexts)
            for next_ci in nexts
                dfs(next_ci, visited)
            end
        end
    end

    maze = parse_file(fname)
    start = CIdx(Tuple(findfirst(==('S'), maze))..., 2)  # 2: East
    goal_2d = findfirst(==('E'), maze)

    points, path_info = dijkstra(maze, start, goal_2d)

    goal = CIdx(Tuple(goal_2d)..., argmin(points[Tuple(goal_2d)..., :]))
    visited = Set{CIdx{2}}()
    dfs(goal, visited)

    length(visited)
end

end #module

using .Day16: d16_p1, d16_p2
export d16_p1, d16_p2
