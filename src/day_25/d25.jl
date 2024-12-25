
module Day25

const WIDTH = 5
const HEIGHT = 7

function parse_file(fname::String)
    lines = map(x -> replace(x, "\n" => ""), split(read(joinpath(@__DIR__, fname), String), "\n\n"))
    data = map(m -> permutedims(reshape(m, WIDTH, HEIGHT)), map(x -> map(==('#'), collect(x)), lines))

    lock = Vector{Array{Bool, 2}}()
    key = Vector{Array{Bool, 2}}()

    foreach(data) do m
        if m[1]  # rocks
            push!(lock, m)
        else
            push!(key, m)
        end
    end

    lock, key
end

function d25_p1(fname::String = "input")
    lock, key = parse_file(fname)

    lock_n = map(m -> map(count, eachcol(m)), lock)
    key_n = map(m -> map(count, eachcol(m)), key)

    acc = 0
    for (i, j) in Iterators.product(1:lastindex(lock), 1:lastindex(key))
        if all(<=(HEIGHT), lock_n[i] + key_n[j])
            acc += 1
        end
    end

    acc
end

end #module

using .Day25: d25_p1
export d25_p1
