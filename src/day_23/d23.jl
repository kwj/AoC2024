
module Day23

mutable struct UDGraph
    adj_map::Dict{String, Set{String}}
    UDGraph() = new(Dict())
end

mutable struct CliqueState
    graph::UDGraph
    Q::Vector{String}
    CliqueState(g::UDGraph) = new(g, Vector())
end

function add_vertex!(g::UDGraph, v::String)
    if !haskey(g.adj_map, v)
        g.adj_map[v] = Set{String}()
    end

    true
end

function add_edge!(g::UDGraph, u::String, v::String)
    if haskey(g.adj_map, u) && haskey(g.adj_map, v)
        push!(g.adj_map[u], v)
        push!(g.adj_map[v], u)
        true
    else
        false
    end
end

# TODO: Read the paper carefully later
# https://doi.org/10.1007/978-3-319-53925-6_1
gamma(g::UDGraph, x::String) = g.adj_map[x]
degree(g::UDGraph, x::String) = length(gamma(g, x))

function expand!(state::CliqueState, subg::Set{String}, cand::Set{String}, c::Channel)
    if isempty(subg)
        put!(c, copy(state.Q))
    else
        pivot = argmax(x -> degree(state.graph, x), subg)
        r_cpl = setdiff(cand, gamma(state.graph, pivot))
        for q in r_cpl
            push!(state.Q, q)

            q_nbrs = gamma(state.graph, q)
            subg_q = subg ∩ q_nbrs
            cand_q = cand ∩ q_nbrs
            expand!(state, subg_q, cand_q, c)

            pop!(cand, q)
            pop!(state.Q)
        end
    end
end

function parse_file(fname::String)
    graph = UDGraph()

    foreach(split.(readlines(joinpath(@__DIR__, fname)), '-')) do lst
        u, v = map(String, lst)
        add_vertex!(graph, u)
        add_vertex!(graph, v)
        add_edge!(graph, u, v)
    end

    graph
end

function d23_p1(fname::String = "input")
    G = parse_file(fname)

    comps = collect(keys(G.adj_map))
    three_cliques = Set{NTuple{3, String}}()

    for i = 1:(lastindex(comps) - 1), j = (i + 1):lastindex(comps)
        comps[j] ∉ G.adj_map[comps[i]] && continue

        foreach(G.adj_map[comps[i]] ∩ G.adj_map[comps[j]]) do x
            push!(three_cliques, Tuple(sort([comps[i], comps[j], x])))
        end
    end

    count(clq -> in('t', map(first, clq)), three_cliques)
end

function d23_p2(fname::String = "input")
    G = parse_file(fname)

    max_len = 0
    max_clique = ""
    for clq in Channel(c -> expand!(CliqueState(G), Set(keys(G.adj_map)), Set(keys(G.adj_map)), c))
        if length(clq) > max_len
            max_len = length(clq)
            max_clique = clq
        end
    end

    join(sort(max_clique), ",")
end

end #module

using .Day23: d23_p1, d23_p2
export d23_p1, d23_p2
