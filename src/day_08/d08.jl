
module Day08

import Combinatorics: combinations

function parse_file(fname::String)
    first.(stack(split.(readlines(joinpath((@__DIR__), fname)), ""), dims = 1))
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

    anti_nodes = Set{CartesianIndex{2}}()
    for lst in values(get_antennas(grid))
        for pos in combinations(lst, 2)
            v = pos[1] - pos[2]
            push!(anti_nodes, pos[1] + v, pos[2] - v)
        end
    end

    count(ci -> checkbounds(Bool, grid, ci), anti_nodes)
end

function d08_p2(fname::String = "input")
    grid = parse_file(fname)

    anti_nodes = Set{CartesianIndex{2}}()
    for lst in values(get_antennas(grid))
        for pos in combinations(lst, 2)
            v = pos[1] - pos[2]

            p1 = pos[1]
            while checkbounds(Bool, grid, p1)
                push!(anti_nodes, p1)
                p1 += v
            end

            p2 = pos[2]
            while checkbounds(Bool, grid, p2)
                push!(anti_nodes, p2)
                p2 -= v
            end
        end
    end

    length(anti_nodes)
end

end #module

using .Day08: d08_p1, d08_p2
export d08_p1, d08_p2
