
module Day04

function parse_file(fname::String)
    permutedims(map(x -> x[1], stack(split.(readlines(fname), ""))))
end

function d04_p1(fname::String = "input")
    WORD = "XMAS"
    data = parse_file(fname)

    acc = 0
    for ci in findall(x -> x == first(WORD), data)
        m_base, n_base = Tuple(ci)
        for m_delta in [-1, 0, 1]
            for n_delta in [-1, 0, 1]
                for x in 1:(length(WORD) - 1)
                    m = m_base + m_delta * x
                    n = n_base + n_delta * x
                    if m ∉ 1:size(data, 1) || n ∉ 1:size(data, 2) || data[m, n] != WORD[x + 1]
                        break
                    end

                    if x == length(WORD) - 1
                        acc += 1
                    end
                end
            end
        end
    end

    acc
end

function d04_p2(fname::String = "input")
    data = parse_file(fname)

    acc = 0
    for ci in findall(x -> x == 'A', data)
        m, n = Tuple(ci)
        if m ∉ 2:(size(data, 1) - 1) || n ∉ 2:(size(data, 2) - 1)
            continue
        end

        nbrs = [
            Set([data[m - 1, n - 1], data[m + 1, n + 1]]),
            Set([data[m + 1, n - 1], data[m - 1, n + 1]])
        ]
        if all(x -> x == Set(['M', 'S']), nbrs)
            acc += 1
        end
    end

    acc
end

end #module

using .Day04: d04_p1, d04_p2
