
module Day02

function parse_file(fname::String)
    map(split.(readlines(fname))) do lst
        map(x -> parse(Int, x), lst)
    end
end

function is_safe(lst::Vector{Int})
    diff_lst = (-).(lst[1:end - 1], lst[2:end])

    all(n -> 1 <= n <= 3, diff_lst) || all(n -> -3 <= n <= -1, diff_lst)
end

function d02_p1(fname::String = "input")
    count(is_safe, parse_file(fname))
end

function d02_p2(fname::String = "input")
    function candidate_lsts(lst::Vector{Int})
        result = Vector{Vector{Int}}()
        for i in 1:length(lst)
            push!(result, deleteat!(copy(lst), i))
        end

        result
    end

    count(lst -> is_safe(lst) || any(is_safe, candidate_lsts(lst)), parse_file(fname))
end

end #module

using .Day02: d02_p1, d02_p2
