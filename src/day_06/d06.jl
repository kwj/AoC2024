
module Day06

const CIdx = CartesianIndex

# up(1), right(2), down(3), left(4)
const STEP = CIdx.([(-1, 0), (0, 1), (1, 0), (0, -1)])

turn_right90(x) = mod1(x + 1, length(STEP))

function parse_file(fname::String)
    first.(stack(split.(readlines(joinpath(@__DIR__, fname)), ""), dims = 1))
end

function d06_p1(fname::String = "input")
    grid = parse_file(fname)
    footprints = falses(size(grid)...)

    pos = findfirst(==('^'), grid)
    dir = 1  # inital direction is up(1)
    while true
        footprints[pos] = true

        next_pos = pos + STEP[dir]
        if !checkbounds(Bool, grid, next_pos)
            break
        elseif grid[next_pos] == '#'
            dir = turn_right90(dir)
        else
            pos = next_pos
        end
    end

    count(footprints)
end

function check_loop(grid::Array{Char, 2}, pos::CIdx{2}, dir::Int)
    # Loop is detected at a position where there is a wall in front of it
    visited = Set{Tuple{CIdx{2}, Int}}()

    push!(visited, (pos, dir))
    dir = turn_right90(dir)

    while true
        if (pos, dir) ∈ visited
            return true
        end

        next_pos = pos + STEP[dir]
        if !checkbounds(Bool, grid, next_pos)
            return false
        elseif grid[next_pos] == '#'
            push!(visited, (pos, dir))
            dir = turn_right90(dir)
        else
            pos = next_pos
        end
    end
end

function d06_p2(fname::String = "input")
    grid = parse_file(fname)
    footprints = Set{CIdx{2}}()

    pos = findfirst(==('^'), grid)
    dir = 1  # inital direction is up(1)
    acc = 0
    while true
        push!(footprints, pos)

        next_pos = pos + STEP[dir]
        if !checkbounds(Bool, grid, next_pos)
            break
        elseif grid[next_pos] == '#'
            dir = turn_right90(dir)
        else
            if next_pos ∉ footprints
                backup = grid[next_pos]
                grid[next_pos] = '#'
                if check_loop(grid, pos, dir)
                    acc += 1
                end
                grid[next_pos] = backup
            end

            pos = next_pos
        end
    end

    acc
end

end #module

using .Day06: d06_p1, d06_p2
export d06_p1, d06_p2
