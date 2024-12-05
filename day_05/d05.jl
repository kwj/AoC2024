
module Day05

function parse_file(fname::String)
    data = readlines(fname)
    sep_pos = findfirst(v -> v == "", data)

    dependency = Dict{Int, Set{Int}}()
    map(data[1:sep_pos - 1]) do s
        before, after = map(x -> parse(Int, x), split(s, "|"))
        dependency[before] = push!(get(dependency, before, Set{Int}()), after)
    end

    queue = map(data[sep_pos + 1:end]) do s
        map(x -> parse(Int, x), split(s, ","))
    end

    dependency, queue
end

function make_is_before(dependency::Dict{Int, Set{Int}})
    (before::Int, after::Int) -> !haskey(dependency, after) || before ∉ dependency[after]
end

function middle_element(seq::Vector{Int})
    seq[ceil(Int, length(seq) / 2)]
end

function d05_p1(fname::String = "input")
    dependency, queue = parse_file(fname)

    acc = 0
    for pages in queue
        sorted_pages = sort(pages, lt = make_is_before(dependency))
        if pages == sorted_pages
            acc += middle_element(sorted_pages)
        end
    end

    acc
end

function d05_p2(fname::String = "input")
    dependency, queue = parse_file(fname)

    acc = 0
    for pages in queue
        sorted_pages = sort(pages, lt = make_is_before(dependency))
        if pages != sorted_pages
            acc += middle_element(sorted_pages)
        end
    end

    acc
end

end #module

using .Day05: d05_p1, d05_p2
