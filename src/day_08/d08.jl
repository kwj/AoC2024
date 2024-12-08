
module Day08

import Combinatorics: combinations

function parse_file(fname::String)
    data = map(split.(readlines(joinpath((@__DIR__), fname)), "")) do lst
        map(s -> s[1], lst)
    end

    permutedims(stack(data))
end

function get_antennas(grid::Array{Char, 2})
    antennas = Dict{Char, Vector{CartesianIndex{2}}}()
    for ci in findall(x -> x != '.', grid)
        key = grid[ci]
        antennas[key] = push!(get!(antennas, key, Vector{CartesianIndex{2}}()), ci)
    end

    antennas
end

function d08_p1(fname::String = "input")
    grid = parse_file(fname)
    antennas = get_antennas(grid)

    antinodes = Set{CartesianIndex{2}}()
    for lst in values(antennas)
        for pos in combinations(lst, 2)
            v = pos[1] - pos[2]
            push!(antinodes, pos[1] + v, pos[2] - v)
        end
    end

    count(ci -> checkbounds(Bool, grid, ci), antinodes)
end

function d08_p2(fname::String = "input")
    grid = parse_file(fname)
    antennas = get_antennas(grid)

    antinodes = Set{CartesianIndex{2}}()
    for lst in values(antennas)
        if length(lst) > 1
            push!(antinodes, lst...)
        end
        for pos in combinations(lst, 2)
            v = pos[1] - pos[2]

            p1 = pos[1] + v
            while checkbounds(Bool, grid, p1)
                push!(antinodes, p1)
                p1 += v
            end

            p2 = pos[2] - v
            while checkbounds(Bool, grid, p2)
                push!(antinodes, p2)
                p2 -= v
            end
        end
    end

    length(antinodes)
end

end #module

using .Day08: d08_p1, d08_p2
export d08_p1, d08_p2
