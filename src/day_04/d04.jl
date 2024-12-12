
module Day04

function parse_file(fname::String)
    first.(stack(split.(readlines(joinpath((@__DIR__), fname)), ""), dims = 1))
end

function d04_p1(fname::String = "input")
    WORD = "XMAS"
    data = parse_file(fname)

    @assert length(WORD) > 1 "the length of keyword must be longer than 1"
    acc = 0
    for ci in findall(x -> x == first(WORD), data)
        for delta = CartesianIndex(-1, -1):CartesianIndex(1, 1)
            if !checkbounds(Bool, data, ci + delta * (length(WORD) - 1))
                continue
            end

            idx = ci  # Copy a CartesianIndex for working
            for x = 2:lastindex(WORD)
                idx += delta
                if data[idx] != WORD[x]
                    break
                end
                if x == lastindex(WORD)
                    acc += 1
                end
            end
        end
    end

    acc
end

function d04_p2(fname::String = "input")
    check_nbr = issetequal(Set("MS"))
    data = parse_file(fname)

    acc = 0
    for ci in findall(x -> x == 'A', data)
        idx_nw = ci + CartesianIndex(-1, -1)
        idx_ne = ci + CartesianIndex(-1, 1)
        idx_sw = ci + CartesianIndex(1, -1)
        idx_se = ci + CartesianIndex(1, 1)
        if checkbounds(Bool, data, [idx_nw, idx_ne, idx_sw, idx_se])
            nbrs = [
                Set([data[idx_nw], data[idx_se]]),
                Set([data[idx_ne], data[idx_sw]])
            ]
            if all(check_nbr, nbrs)
                acc += 1
            end
        end
    end

    acc
end

end #module

using .Day04: d04_p1, d04_p2
export d04_p1, d04_p2
