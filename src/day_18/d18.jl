
module Day18

import DataStructures: PriorityQueue, dequeue!

const CIdx = CartesianIndex
const DIRS = CIdx.([(-1, 0), (0, 1), (1, 0), (0, -1)])

const X_SIZE = 71
const Y_SIZE = 71

function parse_file(fname::String)
    data = parse.(Int, stack(split.(readlines(joinpath(@__DIR__, fname)), ","), dims = 1)) .+ 1
    zip(data[:, 1], data[:, 2]) |> collect
end

function dijkstra(grid::Array{Int, 2}, start::CIdx{2}, goal::CIdx{2})
    dest_tbl = fill(typemax(Int), size(grid)...)
    dest_tbl[start] = 0

    pq = PriorityQueue{CIdx{2}, Int}()
    pq[start] = 0
    while !isempty(pq)
        ci = dequeue!(pq)
        if ci == goal
            # Return the number of steps to the goal
            return dest_tbl[goal]
        end

        for adj in filter(x -> checkbounds(Bool, grid, x) && iszero(grid[x]), ci .+ DIRS)
            new_dest = dest_tbl[ci] + 1
            if dest_tbl[adj] > new_dest
                dest_tbl[adj] = new_dest
                pq[adj] = new_dest
            end
        end
    end

    # There is no path to the goal.
    0
end

function d18_p1(fname::String = "input")
    start = CIdx(1, 1)
    goal = CIdx(X_SIZE, Y_SIZE)
    grid = zeros(Int, X_SIZE, Y_SIZE)

    for pos in parse_file(fname)[1:1024]
        grid[pos...] = 1
    end

    dijkstra(grid, start, goal)
end

function d18_p2(fname::String = "input")
    start = CIdx(1, 1)
    goal = CIdx(X_SIZE, Y_SIZE)
    grid = zeros(Int, X_SIZE, Y_SIZE)

    falling_bytes = parse_file(fname)

    # binary search
    L = 1024
    R = length(falling_bytes)
    while L + 1 < R
        fill!(grid, 0)

        m = div(L + R, 2)
        for pos in falling_bytes[1:m]
            grid[pos...] = 1
        end
        if iszero(dijkstra(grid, start, goal))
            R = m
        else
            L = m
        end
    end

    x, y = falling_bytes[R] .- 1
    println(x, ",", y)
end

end #module

using .Day18: d18_p1, d18_p2
export d18_p1, d18_p2
