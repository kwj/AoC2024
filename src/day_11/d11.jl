
module Day11

function parse_file(fname::String)
    map(x -> parse(Int64, x), split(readlines(joinpath((@__DIR__), fname))[1]))
end

function make_countmap(lst::Vector{Int64})
    cm = Dict{Int64, Int64}()
    for v in lst
        cm[v] = get(cm, v, 0) + 1
    end

    cm
end

function blink(cm::Dict{Int64, Int64}, cnt::Int)
    for _ in 1:cnt
        new_cm = Dict{Int64, Int64}()
        for (k, v) in pairs(cm)
            if iszero(k)
                new_cm[1] = get(new_cm, 1, 0) + v
            elseif iseven(ndigits(k))
                len = div(ndigits(k), 2)
                left = parse(Int, string(k)[1:len])
                right = parse(Int, string(k)[len + 1:end])
                new_cm[left] = get(new_cm, left, 0) + v
                new_cm[right] = get(new_cm, right, 0) + v
            else
                tmp = k * 2024
                new_cm[tmp] = get(new_cm, tmp, 0) + v
            end
        end

        cm = new_cm
    end

    cm
end

function d11_p1(fname::String = "input")
    stones = parse_file(fname)

    blink(make_countmap(stones), 25) |> values |> sum
end

function d11_p2(fname::String = "input")
    stones = parse_file(fname)

    blink(make_countmap(stones), 75) |> values |> sum
end

end #module

using .Day11: d11_p1, d11_p2
export d11_p1, d11_p2
