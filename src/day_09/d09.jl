
module Day09

mutable struct Block
    id::Int  # 0: free space, otherwise: file
    len::Int
end

Base.copy(s::Block) = Block(s.id, s.len)

function parse_file(fname::String)
    map(x -> parse(Int, x), split.(readlines(joinpath((@__DIR__), fname))[1], ""))
end

# Note: the `blocks` parameter of the caller will be modified
function trim_blocks!(blocks::Vector{Block})
    while iszero(blocks[end].id) || iszero(blocks[end].len)
        pop!(blocks)
    end

    blocks
end

function make_block_lst(lst::Vector{Int})
    map(collect(enumerate(lst))) do (idx, len)
        if isodd(idx)
            Block((idx + 1) ÷ 2, len)
        else
            Block(0, len)
        end
    end |> filter(blk -> blk.len != 0) |> trim_blocks!
end

function checksum(blocks::Vector{Block})
    acc = 0
    idx = 0
    for blk in blocks
        if !iszero(blk.id)
            acc += sum((blk.id - 1) .* collect(idx:(idx + blk.len - 1)))
        end
        idx += blk.len
    end

    acc
end

function d09_p1(fname::String = "input")
    blocks = make_block_lst(parse_file(fname))

    i = 1
    while i < length(blocks)
        if iszero(blocks[i].id)
            if blocks[i].len <= blocks[end].len
                blocks[i].id = blocks[end].id
                blocks[end].len -= blocks[i].len
            else
                blocks[i].len -= blocks[end].len
                insert!(blocks, i, pop!(blocks))
            end
        end

        # truncate space blocks and empty blocks at the end of block list
        trim_blocks!(blocks)

        i += 1
    end

    checksum(blocks)
end

function d09_p2(fname::String = "input")
    function find_space_block(lst::Vector{Block}, idx::Int)
        space_blk_idx = findfirst(blk -> blk.id == 0 && lst[idx].len <= blk.len, lst)
        if !isnothing(space_blk_idx) && space_blk_idx < idx
            space_blk_idx
        else
            nothing
        end
    end

    blocks = make_block_lst(parse_file(fname))

    src_idx = lastindex(blocks)
    while src_idx > 1
        if !iszero(blocks[src_idx].id)
            dest_idx = find_space_block(blocks, src_idx)
            if !isnothing(dest_idx)
                if blocks[src_idx].len == blocks[dest_idx].len
                    blocks[dest_idx].id = blocks[src_idx].id
                    blocks[src_idx].id = 0
                else
                    blocks[dest_idx].len -= blocks[src_idx].len
                    insert!(blocks, dest_idx, copy(blocks[src_idx]))
                    src_idx += 1
                    blocks[src_idx].id = 0
                end
            end
        end

        src_idx -= 1
    end

    checksum(blocks)
end

end #module

using .Day09: d09_p1, d09_p2
export d09_p1, d09_p2
