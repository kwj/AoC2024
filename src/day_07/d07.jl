
module Day07

function parse_file(fname::String)
    map(split.(readlines(joinpath(@__DIR__, fname)), r":? +")) do lst
        vs = parse.(Int, lst)
        (numbers = vs[2:end], value = vs[1])
    end
end

# Note:
# Checking numbers from back to front allows pruning.
function calibration(ns::AbstractVector{Int}, target::Int, mode::Symbol = :P1)
    if length(ns) == 1
        return target == ns[1]
    end

    init, last = (@view ns[1:end - 1]), ns[end]

    target < last && return false

    # addition
    if calibration(init, target - last, mode)
        return true
    end

    # multiplication
    if iszero(mod(target, last)) && calibration(init, div(target, last), mode)
        return true
    end

    # concatination (Part 2)
    if mode == :P2
        k = 10 ^ ndigits(last)
        if mod(target, k) == last && calibration(init, div(target, k), mode)
            return true
        end
    end

    false
end

function d07_p1(fname::String = "input")
    data = parse_file(fname)
    sum(x.value for x in filter(tpl -> calibration(tpl...), data))
end

function d07_p2(fname::String = "input")
    data = parse_file(fname)
    sum(x.value for x in filter(tpl -> calibration(tpl..., :P2), data))
end

end #module

using .Day07: d07_p1, d07_p2
export d07_p1, d07_p2
