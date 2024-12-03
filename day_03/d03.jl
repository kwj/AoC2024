
module Day03

function read_file(fname::String)
    read(fname, String)
end

function d03_p1(fname::String = "input")
    re = r"mul\((?<args>\d+,\d+)\)"
    map(eachmatch(re, read_file(fname))) do m
        reduce(*, map(x -> parse(Int, x), split(m["args"], ",")))
    end |> sum
end

function d03_p2(fname::String = "input")
    re = r"(?<flag>do|don't)\(\)|mul\((?<args>\d+,\d+)\)"
    enabled = true
    acc = 0
    for m in eachmatch(re, read_file(fname))
        if m["flag"] == "do"
            enabled = true
        elseif m["flag"] == "don't"
            enabled = false
        elseif enabled
            acc += reduce(*, map(x -> parse(Int, x), split(m["args"], ",")))
        end
    end

    acc
end

end #module

using .Day03: d03_p1, d03_p2
