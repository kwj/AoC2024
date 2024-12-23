
module Day20

const CIdx = CartesianIndex

struct Delta
    move::CIdx{2}
    dist::Int  # Manhattan distance
end

function parse_file(fname::String)
    first.(stack(split.(readlines(joinpath(@__DIR__, fname)), ""), dims = 1))
end

# Note:
# The problem statements says there is only a single path from the start to the end.
# In addition, I assume that there are NO BRANCHES.
function get_path_info(grid::Array{Char, 2}, start::CIdx{2}, goal::CIdx{2})
    DIRS = CIdx.([(-1, 0), (0, 1), (1, 0), (0, -1)])
    dist_tbl = fill(typemax(Int), size(grid)...)

    dist_tbl[start] = dist = 0
    pos = start
    while pos != goal
        pos = first(filter(x -> grid[x] != '#' && dist_tbl[x] == typemax(Int), pos .+ DIRS))
        dist += 1
        dist_tbl[pos] = dist
    end

    dist_tbl
end

function count_cheats(grid::Array{Char, 2}, cheat_dur::Int, thr::Int)
    start = findfirst(==('S'), grid)
    goal = findfirst(==('E'), grid)
    @assert !isnothing(start) && !isnothing(goal) "invalid map"

    dist_tbl = get_path_info(grid, start, goal)
    delta_lst = filter(collect(Iterators.product(-cheat_dur:cheat_dur, -cheat_dur:cheat_dur))) do (x, y)
        1 < abs(x) + abs(y) <= cheat_dur
    end |> lst -> map(x -> Delta(CIdx(x), abs(x[1]) + abs(x[2])), lst)

    acc = 0
    for x in findall(!=(typemax(Int)), dist_tbl)
        for d in delta_lst
            y = x + d.move
            if checkbounds(Bool, dist_tbl, y) && dist_tbl[y] != typemax(Int)
                if dist_tbl[y] - dist_tbl[x] - d.dist >= thr
                    acc += 1
                end
            end
        end
    end

    acc
end

function d20_p1(fname::String = "input"; thr::Int = 100)
    @assert thr > 0 "The threshold must be greater than 0"

    count_cheats(parse_file(fname), 2, thr)
end

function d20_p2(fname::String = "input"; thr::Int = 100)
    @assert thr > 0 "The threshold must be greater than 0"

    count_cheats(parse_file(fname), 20, thr)
end

end #module

using .Day20: d20_p1, d20_p2
export d20_p1, d20_p2
