
module Day06

function parse_file(fname::String)
    data = map(split.(readlines(fname), "")) do lst
        map(s -> s[1], lst)
    end

    permutedims(stack(data))
end

@enum Result escape=1 loop=2

function find_path(grid::Array{Char, 2}, pos::CartesianIndex{2})
    # up(1), right(2), down(3), left(4)
    dir = 1
    step = [CartesianIndex(-1, 0), CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(0, -1)]
    turn_right90(x) = mod1(x + 1, 4)

    path = Set{Tuple{CartesianIndex{2}, Int}}()
    while true
        push!(path, (pos, dir))

        next_pos = pos + step[dir]
        if (next_pos, dir) ∈ path
            return loop, 0
        elseif !checkbounds(Bool, grid, next_pos)
            return escape, path
        elseif grid[next_pos] == '#'
            dir = turn_right90(dir)
        else
            pos = next_pos
        end
    end
end

function d06(fname::String = "input")
    grid = parse_file(fname)
    start = findfirst(x -> x == '^', grid)

    result, path = find_path(grid, start)
    @assert result == escape "no escape route found"
    visited = Set(pos for (pos, _) in path)

    ans_p1 = length(visited)

    pop!(visited, start)  # remove the start position from visited positions
    ans_p2 = 0
    for pos in visited
        grid[pos] = '#'
        result, _ = find_path(grid, start)
        if result == loop
            ans_p2 += 1
        end
        grid[pos] = '.'
    end

    println(ans_p1)
    println(ans_p2)
end

end #module

using .Day06: d06
