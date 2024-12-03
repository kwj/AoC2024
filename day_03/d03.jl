
module Day03

function read_file(fname::String)
    read(fname, String)
end

function d03_p1(fname::String = "input")
    map(eachmatch(r"mul\((\d+),(\d+)\)", read_file(fname))) do m
        reduce(*, map(x -> parse(Int, x), m.captures))
    end |> sum
end

function d03_p2(fname::String = "input")
    eval_flag = true
    acc = 0
    for m in eachmatch(r"(mul|do|don't)\((\d+,\d+)?\)", read_file(fname))
        if m.captures[1] == "do"
            eval_flag = true
        elseif m.captures[1] == "don't"
            eval_flag = false
        elseif eval_flag
            acc += reduce(*, map(x -> parse(Int, x), split(m.captures[2], ",")))
        end
    end

    acc
end

end #module

using .Day03: d03_p1, d03_p2
