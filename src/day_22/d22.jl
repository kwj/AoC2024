
module Day22

#=
64 = 2^6
32 = 2^5
2048 = 2^11

modulo 16777216 = bitwise `AND` operation with 0xFFFFFFFF
  16777216 = 0x1000000 = 0b1000000000000000000000000
=#

function next_secret(n::Int)
    n = (n ⊻ (n << 6)) & 0xFFFFFF
    n = (n ⊻ (n >> 5)) & 0xFFFFFF
    n = (n ⊻ (n << 11)) & 0xFFFFFF

    n
end

function parse_file(fname::String)
    map(x -> parse(Int, x), readlines(joinpath(@__DIR__, fname)))
end

const Key = NTuple{4, Int}

function d22_p1(fname::String = "input")
    function repeat_func(n::Int, cnt::Int)
        foreach(_ -> n = next_secret(n), 1:cnt)
        n
    end

    data = parse_file(fname)
    sum(repeat_func(n, 2000) for n in data)
end

function d22_p2(fname::String = "input")
    data = parse_file(fname)
    total_bananas = Dict{Key, Int}()
    seen = Set{Key}()

    for n in data
        empty!(seen)
        key::Key = (0, 0, 0, 0)

        prev_price = mod(n, 10)
        for idx = 1:2000
            n = next_secret(n)
            price = mod(n, 10)
            key = (key[2], key[3], key[4], price - prev_price)

            if key ∉ seen && idx >= 4
                total_bananas[key] = get(total_bananas, key, 0) + price
                push!(seen, key)
            end

            prev_price = price
        end
    end

    maximum(values(total_bananas))
end

end #module

using .Day22: d22_p1, d22_p2
export d22_p1, d22_p2
