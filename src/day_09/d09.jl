
module Day09

function parse_file(fname::String)
    data = parse.(Int64, split(chomp(read(joinpath(@__DIR__, fname), String)), ""))
    file_blocks = data[1:2:end]
    gap_blocks = data[2:2:end]

    file_blocks, gap_blocks
end

file_ID(idx::Int64) = idx - 1

function blk_chksum(pos::Int64, id::Int64, len::Int64)
    sum(p -> p * id, pos:(pos + len - 1))
end

function d09_p1(fname::String = "input")
    file_blocks, gap_blocks = parse_file(fname)

    chksum = 0
    pos = 0
    idx = 1  # Use for both file_blocks and gap_blocks
    last_file_idx = lastindex(file_blocks)

    # Note:
    # This implementation doesn't keep the original block in correct state
    # after a file is moved from the block. It cuts corners.
    while idx <= last_file_idx
        # file block
        if file_blocks[idx] > 0
            chksum += blk_chksum(pos, file_ID(idx), file_blocks[idx])
            pos += file_blocks[idx]
        end

        # free space block (gap)
        if checkbounds(Bool, gap_blocks, idx)
            while gap_blocks[idx] > 0
                # skip empty file blocks
                while file_blocks[last_file_idx] == 0
                    last_file_idx -= 1
                end
                last_file_idx <= idx && break

                len = min(gap_blocks[idx], file_blocks[last_file_idx])
                chksum += blk_chksum(pos, file_ID(last_file_idx), len)
                pos += len
                gap_blocks[idx] -= len
                file_blocks[last_file_idx] -= len
            end
        end

        idx += 1
    end

    chksum
end

function d09_p2(fname::String = "input")
    file_blocks, gap_blocks = parse_file(fname)
    exist_file = trues(length(file_blocks))

    chksum = 0
    pos = 0
    idx = 1  # Use for both file_blocks and gap_blocks

    while idx <= lastindex(file_blocks)
        # file block
        if file_blocks[idx] > 0
            # If a file is exist in this block, calculate its checksum.
            if exist_file[idx]
                chksum += blk_chksum(pos, file_ID(idx), file_blocks[idx])
            end
            pos += file_blocks[idx]
        end

        # free space block (gap)
        if checkbounds(Bool, gap_blocks, idx)
            while gap_blocks[idx] > 0
                move_src_idx = lastindex(file_blocks)
                while idx < move_src_idx
                    if 0 < file_blocks[move_src_idx] <= gap_blocks[idx] && exist_file[move_src_idx]
                        break
                    end
                    move_src_idx -= 1
                end
                move_src_idx <= idx && break

                len = file_blocks[move_src_idx]
                chksum += blk_chksum(pos, file_ID(move_src_idx), len)
                pos += len
                gap_blocks[idx] -= len
                exist_file[move_src_idx] = false
            end
            pos += gap_blocks[idx]
        end

        idx += 1
    end

    chksum
end

end #module

using .Day09: d09_p1, d09_p2
export d09_p1, d09_p2
