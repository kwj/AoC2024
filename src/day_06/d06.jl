
module Day06

const CIdx = CartesianIndex

# up(1), right(2), down(3), left(4)
const STEP = CIdx.([(-1, 0), (0, 1), (1, 0), (0, -1)])

function parse_file(fname::String)
    first.(stack(split.(readlines(joinpath(@__DIR__, fname)), ""), dims = 1))
end

function check_grid(grid::Array{Char, 2}, path::Vector{Tuple{CIdx{2}, Int}})
    turn_right90(x) = mod1(x + 1, 4)
    pos, dir = path[end]

    route = copy(path)  # Don't change the `path` argument of the caller for safty
    visited = Set(route)
    while true
        next_pos = pos + STEP[dir]
        if (next_pos, dir) ∈ visited
            return nothing
        elseif !checkbounds(Bool, grid, next_pos)
            return route
        elseif grid[next_pos] == '#'
            dir = turn_right90(dir)
        else
            pos = next_pos
        end
        push!(route, (pos, dir))
        push!(visited, (pos, dir))
    end
end

function d06_p1(fname::String = "input")
    grid = parse_file(fname)
    start = findfirst(==('^'), grid)

    path = check_grid(grid, [(start, 1)])  # direction: up(1)
    @assert !isnothing(path) "found a loop"

    length(Set(pos for (pos, _) in path))
end

function d06_p2(fname::String = "input")
    grid = parse_file(fname)
    start = findfirst(==('^'), grid)

    path = check_grid(grid, [(start, 1)])  # direction: up(1)
    @assert !isnothing(path) "found a loop"

    confirmed = Set{CIdx{2}}([start])
    acc = 0
    for i = 1:(lastindex(path) - 1)
        next_pos = path[i + 1][1]
        if next_pos ∈ confirmed
            continue
        end

        grid[next_pos] = '#'
        if isnothing(check_grid(grid, path[1:i]))
            acc += 1
        end
        grid[next_pos] = '.'
        push!(confirmed, next_pos)
    end

    acc
end

end #module

using .Day06: d06_p1, d06_p2
export d06_p1, d06_p2
