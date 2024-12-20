
module Day20

import DataStructures: PriorityQueue, dequeue!

const CIdx = CartesianIndex

struct Delta
    move::CIdx{2}
    dist::Int
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

    visit_map = Dict{CIdx{2}, Int}()
    map(eachindex(IndexCartesian(), dist_tbl)) do ci
        if dist_tbl[ci] != typemax(Int)
            visit_map[ci] = dist_tbl[ci]
        end
    end

    visit_map
end

# Note: `dist` is a Manhattan distance
function count_savings(visited::Dict{CIdx{2}, Int}, dist::Int, thr::Int)
    delta_lst = filter(collect(Iterators.product(-dist:dist, -dist:dist))) do (x, y)
        abs(x) + abs(y) <= dist && !(x == 0 && y == 0)
    end |> lst -> map(x -> Delta(CIdx(x), abs(x[1]) + abs(x[2])), lst)

    acc = 0
    for ci in keys(visited)
        for d in delta_lst
            new_ci = ci + d.move
            if haskey(visited, new_ci) && visited[ci] < visited[new_ci]
                if (visited[new_ci] - visited[ci]) - d.dist >= thr
                    acc += 1
                end
            end
        end
    end

    acc
end

function d20_p1(fname::String = "input"; thr::Int = 100)
    maze = parse_file(fname)
    start = findfirst(==('S'), maze)
    goal = findfirst(==('E'), maze)

    count_savings(dijkstra(maze, start, goal), 2, thr)
end

function d20_p2(fname::String = "input"; thr::Int = 100)
    maze = parse_file(fname)
    start = findfirst(==('S'), maze)
    goal = findfirst(==('E'), maze)

    count_savings(dijkstra(maze, start, goal), 20, thr)
end

end #module

using .Day20: d20_p1, d20_p2
export d20_p1, d20_p2
