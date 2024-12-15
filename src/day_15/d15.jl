
module Day15

const CIdx = CartesianIndex

function parse_file(fname::String)
    data = readlines(joinpath(@__DIR__, fname))
    sep_pos = findfirst(isempty, data)

    whs = first.(stack(split.(data[1:sep_pos - 1], ""), dims = 1))

    dirs = Dict{Char, CIdx{2}}(
        '^' => CIdx(-1, 0),
        '>' => CIdx(0, 1),
        'v' => CIdx(1, 0),
        '<' => CIdx(0, -1),
    )
    moves = map(ch -> dirs[ch], collect(join(data[sep_pos + 1:end])))

    whs, moves
end

function move_robot!(whs::Array{Char, 2}, moves::Vector{CIdx{2}})
    wide_box = Set(['[', ']'])
    adj_side_dir(x) =  x == '[' ? CIdx(0, 1) : CIdx(0, -1)

    targets = Vector{CIdx{2}}()  # LIFO queue, aka stack
    robot = findfirst(==('@'), whs)
    for dir in moves
        # Warning: the `targets` queue must be empty here!
        # The following code is not necessary for now but is a safeguard for future me
        empty!(targets)

        queue = [robot]  # FIFO queue
        while !isempty(queue)
            p = popfirst!(queue)
            push!(targets, p)
            next_p = p + dir

            # In the part 2, the `next_p` may already exist in the `queue`
            #
            #   @   (Try to press downward)
            #   []
            #  [][]
            #   []  <--- These two blocks fall into the category of this case
            #
            if next_p ∈ queue
                continue
            end

            # the point `p` can move in the `dir` direction
            if whs[next_p] == '.'
                continue
            end

            # cannot move forward in the `dir` direction
            if whs[next_p] == '#'
                empty!(targets)
                break
            end

            push!(queue, next_p)
            if iszero(dir[2]) && whs[next_p] ∈ wide_box
                # Add the another part of wide box to the `queue` when the `dir` direction
                # is up/down and the `next_p` is a part of a wide box
                push!(queue, next_p + adj_side_dir(whs[next_p]))
            end
        end

        # When the `targets` queue is empty, it indicates that the robot cannot move
        if isempty(targets)
            continue
        end

        # Move the robot one step to the `dir` direction
        while !isempty(targets)
            ci = pop!(targets)
            whs[ci], whs[ci + dir] = whs[ci + dir], whs[ci]
        end
        robot += dir
    end

    whs
end

function calc_GPS_coordinates(whs::Array{Char, 2})
    gps = Set(['O', '['])
    mapreduce(+, findall(in(gps), whs)) do ci
        x, y = Tuple(ci + CIdx(-1, -1))
        100 * x + y
    end
end

function d15_p1(fname::String = "input")
    whs, moves = parse_file(fname)
    move_robot!(whs, moves) |> calc_GPS_coordinates
end

function d15_p2(fname::String = "input")
    function widen_whs(whs::Array{Char, 2})
        wider = Dict(
            '@' => ['@', '.'],
            'O' => ['[', ']'],
            '#' => ['#', '#'],
            '.' => ['.', '.'],
        )

        map(eachrow(whs)) do row
            Iterators.flatmap(c -> wider[c], row) |> collect
        end |> m -> stack(m, dims = 1)
    end

    whs, moves = parse_file(fname)
    move_robot!(widen_whs(whs), moves) |> calc_GPS_coordinates
end

end #module

using .Day15: d15_p1, d15_p2
export d15_p1, d15_p2
