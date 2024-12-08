
module Day03

function parse_file(fname::String)
    join(readlines(joinpath((@__DIR__), fname)))
end

function d03_p1(fname::String = "input")
    re = r"mul\((?<args>\d{1,3},\d{1,3})\)"
    data = parse_file(fname)

    map(eachmatch(re, data)) do m
        prod(map(x -> parse(Int, x), split(m["args"], ",")))
    end |> sum
end

function d03_p2(fname::String = "input")
    re = r"mul\((?<args>\d{1,3},\d{1,3})\)"
    data = parse_file(fname)

    map(eachmatch(re, replace(data, r"don't\(\).*?(do\(\)|$)" => ""))) do m
        prod(map(x -> parse(Int, x), split(m["args"], ",")))
    end |> sum
end

end #module

using .Day03: d03_p1, d03_p2
export d03_p1, d03_p2
