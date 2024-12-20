
module Day08

const CIdx = CartesianIndex

function parse_file(fname::String)
    first.(stack(split.(readlines(joinpath(@__DIR__, fname)), ""), dims = 1))
end

function get_antennas(grid::Array{Char, 2})
    antennas = Dict{Char, Vector{CIdx{2}}}()
    for ci in findall(!=('.'), grid)
        key = grid[ci]
        antennas[key] = push!(get!(antennas, key, Vector{CIdx{2}}()), ci)
    end

    antennas
end

function d08_p1(fname::String = "input")
    grid = parse_file(fname)

    anti_nodes = Set{CIdx{2}}()
    for ants in values(get_antennas(grid))
        for i = firstindex(ants):(lastindex(ants) - 1), j = (i + 1):lastindex(ants)
            v = ants[i] - ants[j]
            push!(anti_nodes, ants[i] + v, ants[j] - v)
        end
    end

    count(ci -> checkbounds(Bool, grid, ci), anti_nodes)
end

function d08_p2(fname::String = "input")
    grid = parse_file(fname)

    anti_nodes = Set{CIdx{2}}()
    for ants in values(get_antennas(grid))
        for i = firstindex(ants):(lastindex(ants) - 1), j = (i + 1):lastindex(ants)
            v = ants[i] - ants[j]

            p = ants[i]
            while checkbounds(Bool, grid, p)
                push!(anti_nodes, p)
                p += v
            end

            p = ants[j]
            while checkbounds(Bool, grid, p)
                push!(anti_nodes, p)
                p -= v
            end
        end
    end

    length(anti_nodes)
end

end #module

using .Day08: d08_p1, d08_p2
export d08_p1, d08_p2
