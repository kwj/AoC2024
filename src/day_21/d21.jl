
module Day21

const Pos = CartesianIndex{2}
const Key = Union{Char, Nothing}
const CostMap = Dict{NTuple{2, Key}, Int64}

const dpad_keys::Array{Key, 2} = [
    nothing  '^'  'A';
       '<'   'v'  '>'
]
const dpad_map = Dict{Key, Pos}(v => k for (k, v) in pairs(IndexCartesian(), dpad_keys))

const npad_keys::Array{Key, 2} = [
       '7'   '8'  '9';
       '4'   '5'  '6';
       '1'   '2'  '3';
    nothing  '0'  'A'
]
const npad_map = Dict{Key, Pos}(v => k for (k, v) in pairs(IndexCartesian(), npad_keys))

function next_costmap(pad_map::Dict{Key, Pos}, base_costmap::CostMap; cnt = 1)
    not_key = pad_map[nothing]
    new_map = CostMap()

    for _ = 1:cnt
        empty!(new_map)
        for (s, idx_s) in pairs(pad_map), (d, idx_d) in pairs(pad_map)
            (isnothing(s) || isnothing(d)) && continue

            delta = idx_d - idx_s
            vs = (delta[1] > 0 ? 'v' : '^') ^ abs(delta[1])
            hs = (delta[2] > 0 ? '>' : '<') ^ abs(delta[2])

            if pad_map[s][2] == not_key[2] && pad_map[d][1] == not_key[1]
                keys = [hs * vs * "A"]
            elseif pad_map[s][1] == not_key[1] && pad_map[d][2] == not_key[2]
                keys = [vs * hs * "A"]
            else
                keys = [hs * vs * "A", vs * hs * "A"]
            end

            new_map[s, d] = minimum(sum(base_costmap[tpl...] for tpl in zip("A" * k, k)) for k in keys)
        end

        base_costmap = copy(new_map)
    end

    new_map
end

function make_costmap(n_robots::Int)
    base_costmap = CostMap()
    for x in keys(dpad_map), y in keys(dpad_map)
        base_costmap[x, y] = 1
    end

    next_costmap(npad_map, next_costmap(dpad_map, base_costmap, cnt = n_robots))
end

function parse_file(fname::String)
    map(readlines(joinpath(@__DIR__, fname))) do line
        (line, parse(Int, line[1:3]))
    end
end

function d21_p1(fname::String = "input")
    data = parse_file(fname)
    costmap = make_costmap(2)

    mapreduce(+, data) do (code, n)
        sum(costmap[tpl...] for tpl in zip("A" * code, code)) * n
    end
end

function d21_p2(fname::String = "input")
    data = parse_file(fname)
    costmap = make_costmap(25)

    mapreduce(+, data) do (code, n)
        sum(costmap[tpl...] for tpl in zip("A" * code, code)) * n
    end
end

end #module

using .Day21: d21_p1, d21_p2
export d21_p1, d21_p2
