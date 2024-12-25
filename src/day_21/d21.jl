
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

#=
  H: Human
  R: Robot
  P: Keypad (directional)
  N: Keypad (numerical)
  ---: Wired connection
  ==>: Robot's arm

The situation of Part 1 (Two directional keypads that robots are using):

  indoor |         outdoor            | indoor
     [H] |  [R]      [R]      [R]     |
         | +---+    +---+    +---+    |
      P--|---. |==>|P|  |==>|P|  |==>|N|
         | +---+    +---+    +---+    |

If there are no robots:

      indoor
     [H]
   direct |P|
    input

If there are no indirect directional keypads:

  indoor |  outdoor | indoor
     [H] |  [R]     |
         | +---+    |   029A -->
      P--|---. |==>|N|    <A ^A >^^A vvvA
         | +---+    |

If there is one indirect directional keypad:

  indoor |      outdoor      | indoor
     [H] |  [R]      [R]     |
         | +---+    +---+    |    <A | ^A | >^^A | vvvA -->
      P--|---. |==>|P|  |==>|N|     v<<A >>^A | <A >A | vA <^A A >A | <vA A A >^A
         | +---+    +---+    |
=#

# keystroke movement by robot's arm (Starting with the `A` key)
# [example]
#   029A on the numerical pad:
#     A -> 2 -> 9 -> A => (A, 0), (0, 2), (2, 9), (9, A)
keystroke_movement(key_sequence::String) = zip("A" * key_sequence, key_sequence)

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

            # On indirect input, pressing the activate key `A` after the move is required
            # to press a target key by the robot's arm.
            if pad_map[s][2] == not_key[2] && pad_map[d][1] == not_key[1]
                mv_keys = [hs * vs * "A"]
            elseif pad_map[s][1] == not_key[1] && pad_map[d][2] == not_key[2]
                mv_keys = [vs * hs * "A"]
            else
                mv_keys = [hs * vs * "A", vs * hs * "A"]
            end

            new_map[s, d] = minimum(sum(base_costmap[tpl...] for tpl in keystroke_movement(k)) for k in mv_keys)
        end

        base_costmap = copy(new_map)
    end

    new_map
end

function make_costmap(n_indirect_keypad::Int)
    @assert n_indirect_keypad > 0 "invalid parameter"

    # If a keypad is used directly by a human, the cost of the movement
    # between each key is 0, and the cost of pressing a key is 1.
    direct_dpad_costmap = CostMap()
    for x in keys(dpad_map), y in keys(dpad_map)
        (isnothing(x) || isnothing(y)) && continue
        direct_dpad_costmap[x, y] = 1
    end

    next_costmap(npad_map, next_costmap(dpad_map, direct_dpad_costmap, cnt = n_indirect_keypad))
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
        sum(costmap[tpl...] for tpl in keystroke_movement(code)) * n
    end
end

function d21_p2(fname::String = "input")
    data = parse_file(fname)
    costmap = make_costmap(25)

    mapreduce(+, data) do (code, n)
        sum(costmap[tpl...] for tpl in keystroke_movement(code)) * n
    end
end

end #module

using .Day21: d21_p1, d21_p2
export d21_p1, d21_p2
