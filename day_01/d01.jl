
module Day01

function parse_file(fname::String)
    data = map(x -> parse(Int, x), stack(split.(readlines(fname))))

    data[1, :], data[2, :]
end

function d01_p1(fname::String = "input")
    left, right = parse_file(fname)

    sum(abs.((-).(sort(right), sort(left))))
end

function d01_p2(fname::String = "input")
    left, right = parse_file(fname)

    dic = Dict{Int, Int}()
    for x in right
        dic[x] = get(dic, x, 0) + x
    end

    sum(map(x -> get(dic, x, 0), left))
end

end #module

using .Day01: d01_p1, d01_p2
