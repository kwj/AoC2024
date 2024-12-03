
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
    for m in eachmatch(r"(?<op>mul|do|don't)\((?<args>\d+,\d+)?\)", read_file(fname))
        if m["op"] == "do"
            eval_flag = true
        elseif m["op"] == "don't"
            eval_flag = false
        elseif eval_flag && !isnothing(m["args"])
            acc += reduce(*, map(x -> parse(Int, x), split(m["args"], ",")))
        end
    end

    acc
end

end #module

using .Day03: d03_p1, d03_p2
