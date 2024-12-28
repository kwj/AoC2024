
module Day18

import DataStructures: PriorityQueue, dequeue!

const CIdx = CartesianIndex
const DIRS = CIdx.([(-1, 0), (0, 1), (1, 0), (0, -1)])

function parse_file(fname::String)
    data = parse.(Int, stack(split.(readlines(joinpath(@__DIR__, fname)), ","), dims = 1)) .+ 1
    zip(data[:, 1], data[:, 2]) |> collect
end

# Get the lowest number of steps by Dijkstra's algorithm.
# If there is no path to the goal, it returns 0.
function dijkstra(grid::Array{Int, 2}, start::CIdx{2}, goal::CIdx{2})
    dist_tbl = fill(typemax(Int), size(grid)...)
    dist_tbl[start] = 0

    pq = PriorityQueue{CIdx{2}, Int}()
    pq[start] = 0
    while !isempty(pq)
        ci = dequeue!(pq)
        if ci == goal
            # Return the number of steps to the goal
            return dist_tbl[goal]
        end

        for adj in filter(x -> checkbounds(Bool, grid, x) && iszero(grid[x]), ci .+ DIRS)
            new_dist = dist_tbl[ci] + 1
            if dist_tbl[adj] > new_dist
                dist_tbl[adj] = new_dist
                pq[adj] = new_dist
            end
        end
    end

    # There is no path to the goal.
    0
end

# Note: The matrix referenced by the argument `grid` is modified
function drop_objects!(grid::Array{Int, 2}, objects::Vector{NTuple{2, Int}}, n::Int)
    foreach(x -> grid[x...] = 1, objects[1:n])
end

function d18_p1(fname::String = "input"; X_SIZE = 71, Y_SIZE = 71, NUM_FALLING_OBJS = 1024)
    start = CIdx(1, 1)
    goal = CIdx(X_SIZE, Y_SIZE)
    grid = zeros(Int, X_SIZE, Y_SIZE)

    all_objects = parse_file(fname)

    drop_objects!(grid, all_objects, NUM_FALLING_OBJS)
    dijkstra(grid, start, goal)
end

function d18_p2(fname::String = "input"; X_SIZE = 71, Y_SIZE = 71, NUM_FALLING_OBJS = 1024)
    start = CIdx(1, 1)
    goal = CIdx(X_SIZE, Y_SIZE)
    grid = zeros(Int, X_SIZE, Y_SIZE)

    all_objects = parse_file(fname)

    # binary search
    L = NUM_FALLING_OBJS
    R = lastindex(all_objects)
    while L + 1 < R
        fill!(grid, 0)

        m = div(L + R, 2)
        drop_objects!(grid, all_objects, m)
        if iszero(dijkstra(grid, start, goal))
            R = m
        else
            L = m
        end
    end

    join(all_objects[R] .- 1, ",")
end

end #module

using .Day18: d18_p1, d18_p2
export d18_p1, d18_p2
