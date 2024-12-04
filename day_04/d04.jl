
module Day04

function parse_file(fname::String)
    permutedims(map(x -> x[1], stack(split.(readlines(fname), ""))))
end

function d04_p1(fname::String = "input")
    WORD = "XMAS"
    data = parse_file(fname)

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
        m, n = Tuple(ci)
        if checkindex(Bool, 2:(size(data, 1) - 1), m) && checkindex(Bool, 2:(size(data, 2) - 1), n)
            nbrs = [
                Set([data[m - 1, n - 1], data[m + 1, n + 1]]),
                Set([data[m + 1, n - 1], data[m - 1, n + 1]])
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
