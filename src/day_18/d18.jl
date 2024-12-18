
module Day18

import DataStructures: PriorityQueue, dequeue!

const CIdx = CartesianIndex
const DIRS = CIdx.([(-1, 0), (0, 1), (1, 0), (0, -1)])

const X_SIZE = 71
const Y_SIZE = 71

function parse_file(fname::String)
    data = parse.(Int, stack(split.(readlines(joinpath(@__DIR__, fname)), ","), dims = 1)) .+ 1
    zip(data[:, 1], data[:, 2])
end

function dijkstra(grid::Array{Int, 2}, start::CIdx{2}, goal::CIdx{2})
    dest_tbl = fill(typemax(Int), size(grid)...)
    dest_tbl[start] = 0
    prev_tbl = Array{Union{Nothing, CIdx{2}}}(nothing, size(grid)...)

    pq = PriorityQueue{CIdx{2}, Int}()
    pq[start] = 0

    found = false
    while !isempty(pq)
        ci = dequeue!(pq)
        if ci == goal
            found = true
            break
        end

        for adj in filter(x -> checkbounds(Bool, grid, x) && iszero(grid[x]), ci .+ DIRS)
            new_dest = dest_tbl[ci] + 1
            if dest_tbl[adj] > new_dest
                dest_tbl[adj] = new_dest
                prev_tbl[adj] = ci
                pq[adj] = new_dest
            end
        end
    end

    if found
        dest_tbl[goal], get_route(prev_tbl, goal)
    else
        0, nothing
    end
end

function get_route(prev_tbl::Array{Union{Nothing, CIdx{2}}, 2}, goal::CIdx{2})
    route = Vector{NTuple{2, Int}}()
    push!(route, Tuple(goal))

    next_ci = prev_tbl[goal]
    while !isnothing(next_ci)
        push!(route, Tuple(next_ci))
        next_ci = prev_tbl[next_ci]
    end

    route
end

function d18_p1(fname::String = "input")
    grid = zeros(Int, X_SIZE, Y_SIZE)

    for pos in Iterators.take(parse_file(fname), 1024)
        grid[pos...] = 1
    end

    start = CIdx(1, 1)
    goal = CIdx(X_SIZE, Y_SIZE)
    steps, _ = dijkstra(grid, start, goal)

    steps
end

function d18_p2(fname::String = "input")
    grid = zeros(Int, X_SIZE, Y_SIZE)
    byte_itr = parse_file(fname)

    for pos in Iterators.take(byte_itr, 1024)
        grid[pos...] = 1
    end

    start = CIdx(1, 1)
    goal = CIdx(X_SIZE, Y_SIZE)
    _, route = dijkstra(grid, start, goal)

    route_set = Set(route)
    for pos in Iterators.drop(byte_itr, 1024)
        grid[pos...] = 1
        if pos ∉ route_set
            continue
        end

        steps, route = dijkstra(grid, start, goal)
        if iszero(steps)
            x, y = pos .- 1
            println(x, ",", y)
            break
        else
            route_set = Set(route)
        end
    end
end

end #module

using .Day18: d18_p1, d18_p2
export d18_p1, d18_p2
