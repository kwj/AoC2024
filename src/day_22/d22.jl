
module Day22

#=
64 = 2^6
32 = 2^5
2048 = 2^11

modulo 16777216
  = 0x1000000 = 0b1000000000000000000000000
=#

function next_secret(n::Int)
    n = (n ⊻ (n << 6)) & 0xffffff
    n = (n ⊻ (n >> 5)) & 0xffffff
    n = (n ⊻ (n << 11)) & 0xffffff

    n
end

function parse_file(fname::String)
    map(x -> parse(Int, x), readlines(joinpath(@__DIR__, fname)))
end

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
    memory_size = 4
    prices = fill(0, 2001)
    total_bananas = Dict{NTuple{4, Int}, Int}()
    seen = Set{NTuple{4, Int}}()

    for n in data
        empty!(seen)
        for i = 1:2000
            prices[i] = mod(n, 10)
            n = next_secret(n)
        end
        prices[end] = mod(n, 10)

        diff = prices[2:end] - prices[1:end - 1]
        for i = 1:(length(diff) - memory_size + 1)
            key = Tuple(view(diff, i:(i + memory_size - 1)))
            if key ∉ seen
                total_bananas[key] = get(total_bananas, key, 0) + prices[i + memory_size]
                push!(seen, key)
            end
        end
    end

    maximum(values(total_bananas))
end

end #module

using .Day22: d22_p1, d22_p2
export d22_p1, d22_p2
