
module Day02

function parse_file(fname::String)
    map(lst -> parse.(Int, lst), split.(readlines(joinpath((@__DIR__), fname))))
end

function is_safe(lst::Vector{Int})
    diff_lst = lst[1:end - 1] .- lst[2:end]

    all(n -> 1 <= n <= 3, diff_lst) || all(n -> -3 <= n <= -1, diff_lst)
end

function is_probably_safe(lst::Vector{Int})
    if is_safe(lst)
        true
    else
        for i = 1:length(lst)
            if is_safe(deleteat!(copy(lst), i))
                return true
            end
        end
        false
    end
end

function d02_p1(fname::String = "input")
    count(is_safe, parse_file(fname))
end

function d02_p2(fname::String = "input")
    count(is_probably_safe, parse_file(fname))
end

end #module

using .Day02: d02_p1, d02_p2
export d02_p1, d02_p2
