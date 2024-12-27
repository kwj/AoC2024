
module Day09

function parse_file(fname::String)
    data = parse.(Int64, split(chomp(read(joinpath(@__DIR__, fname), String)), ""))
    file_capacities = data[1:2:end]
    file_IDs = collect(0:(length(file_capacities) - 1))
    gap_capacities = data[2:2:end]

    file_capacities, file_IDs, gap_capacities
end

function blk_chksum(pos::Int64, id::Int64, len::Int64)
    sum(p -> p * id, pos:(pos + len - 1))
end

function d09_p1(fname::String = "input")
    file_capacities, file_IDs, gap_capacities = parse_file(fname)

    chksum = 0
    pos = 0
    idx = 1  # Use for both file_capacities and gap_capacities
    last_idx = lastindex(file_capacities)

    while idx <= last_idx
        # file block
        if file_capacities[idx] > 0
            chksum += blk_chksum(pos, file_IDs[idx], file_capacities[idx])
            pos += file_capacities[idx]
        end

        # free space block (gap)
        if checkbounds(Bool, gap_capacities, idx)
            while gap_capacities[idx] > 0
                last_idx = findlast(>(0), file_capacities)
                if last_idx <= idx
                    break
                end

                len = min(gap_capacities[idx], file_capacities[last_idx])
                chksum += blk_chksum(pos, file_IDs[last_idx], len)
                pos += len
                gap_capacities[idx] -= len
                file_capacities[last_idx] -= len
            end
        end

        idx += 1
    end

    chksum
end

function d09_p2(fname::String = "input")
    file_capacities, file_IDs, gap_capacities = parse_file(fname)
    exist_file = trues(length(file_IDs))

    chksum = 0
    pos = 0
    idx = 1  # Use for both file_capacities and gap_capacities

    while idx <= lastindex(file_capacities)
        # file block
        if file_capacities[idx] > 0
            # if the block is not exist, skip to the next block
            if exist_file[idx]
                chksum += blk_chksum(pos, file_IDs[idx], file_capacities[idx])
            end
            pos += file_capacities[idx]
        end

        # free space block (gap)
        if checkbounds(Bool, gap_capacities, idx)
            while gap_capacities[idx] > 0
                move_idx = lastindex(file_capacities)
                while idx < move_idx
                    if 0 < file_capacities[move_idx] <= gap_capacities[idx] && exist_file[move_idx]
                        break
                    end
                    move_idx -= 1
                end
                move_idx <= idx && break

                len = file_capacities[move_idx]
                chksum += blk_chksum(pos, file_IDs[move_idx], len)
                pos += len
                gap_capacities[idx] -= len
                exist_file[move_idx] = false
            end
            pos += gap_capacities[idx]
        end

        idx += 1
    end

    chksum
end

end #module

using .Day09: d09_p1, d09_p2
export d09_p1, d09_p2
