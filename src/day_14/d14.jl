
module Day14

import Statistics: var

function parse_file(fname::String)
    re = r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)"
    tpl = stack(
        map(readlines(joinpath(@__DIR__, fname))) do line
            parse.(Int, match(re, line).captures)
        end,
        dims = 1
    ) |> eachcol

    tpl[1] .+ 1, tpl[2] .+ 1, tpl[3], tpl[4]
end

function new_state(p::AbstractVector{Int}, v::AbstractVector{Int}, m::Int, t::Int)
    mod1.(p + t * v, m)
end

function ascii_art(px::AbstractVector{Int}, py::AbstractVector{Int}, w::Int, h::Int)
    grid = fill('.', w, h)
    for (i, j) in eachrow(hcat(px, py))
        grid[i, j] = '#'
    end

    for col in eachcol(grid)
        println(join(col, ""))
    end
    println("")
end

function d14_p1(fname::String = "input"; WIDTH = 101, HEIGHT = 103)
    px, py, vx, vy = parse_file(fname)

    robots = hcat(
        cmp.(new_state(px, vx, WIDTH, 100), cld(WIDTH, 2)),
        cmp.(new_state(py, vy, HEIGHT, 100), cld(HEIGHT, 2)),
    )
    mapreduce(*, [[1, 1], [1, -1], [-1, 1], [-1, -1]]) do quad
        count(==(quad), eachrow(robots))
    end
end

function d14_p2(fname::String = "input"; WIDTH = 101, HEIGHT = 103, verbose = false)
    px, py, vx, vy = parse_file(fname)

    # The problem statement says that most of the robots should arrange
    # themselves *INTO* a picture of a Christmas tree when the picture
    # is appeared. So, many robots should be unevenly distributed.
    #
    # Of course, they may be gathering for nothing, however, I trust
    # there is no such nastiness in this problem.
    #
    # I first find the timings when the variances of px and py are lowest
    # in the first cycle of each. These smallest variances mean the timings when
    # many robots are clustered in each of the vertical and horizontal directions.
    b1 = argmin(t -> var(new_state(px, vx, WIDTH, t), corrected = false), 0:(WIDTH - 1))
    b2 = argmin(t -> var(new_state(py, vy, HEIGHT, t), corrected = false), 0:(HEIGHT - 1))

    # Assume that T is the timing at which most of the robots gather both
    # vertically and horizontally, the following equations hold:
    #
    #   T ≡ b1 (modulo WIDTH)
    #   T ≡ b2 (modulo HEIGHT)
    #
    # So, this is a problem about the Chinese remainder theorem.

    # Garner's algorithm
    # https://cp-algorithms.com/algebra/garners-algorithm.html
    @assert gcd(WIDTH, HEIGHT) == 1 "Cannot use Garner's algorithm"
    #
    # Assume that T is equal to `t1 + t2 * WIDTH`.
    #
    # t1 + t2 * WIDTH ≡ b2 (modulo HEIGHT)
    #  -->
    # t2 ≡ (b2 - t1) * WIDTH⁻¹ (modulo HEIGHT)
    #    ≡ (b2 - t1) * invmod(WIDTH, HEIGHT) (modulo HEIGHT)
    #  -->
    # t2 = mod((b2 - t1) * invmod(WIDTH, HEIGHT), HEIGHT)
    #
    # Since 0 <= b1 < WIDTH, so assume that t1 is equal to b1
    #  -->
    # t2 = mod((b2 - b1) * invmod(WIDTH, HEIGHT), HEIGHT)
    #  -->
    # T = t1 + t2 * WIDTH
    #   = b1 + mod((b2 - b1) * invmod(WIDTH, HEIGHT), HEIGHT) * WIDTH
    # ------------------------------------------------------
    T = b1 + mod((b2 - b1) * invmod(WIDTH, HEIGHT), HEIGHT) * WIDTH

    # Show a picture of what appears to be a Christmas tree
    if verbose
        ascii_art(new_state(px, vx, WIDTH, T), new_state(py, vy, HEIGHT, T), WIDTH, HEIGHT)
    end

    return T


    # Note:
    # A bit of a sly method in Julia
    #
    # T = intersect(b1:WIDTH:(WIDTH * HEIGHT), b2:HEIGHT:(WIDTH * HEIGHT)) |> first

    # Note:
    # A naive method using Chinese remainder theorem
    #
    # x ≡ b₁ (modulo m₁)
    # x ≡ b₂ (modulo m₂)
    #   where 0 =< x < m₁ * m₂
    #
    # gcdx(m₁, m₂) -> (d, p, q)
    #  --> m₁ * p + m₂ * q = d
    #
    # Assume that `s = (b₂ - b₁) / d`
    #   m₁ * p + m₂ * q = (b₂ - b₁) / s
    #    --> s * m₁ * p + s * m₂ * q = b₂ - b₁
    #        b₁ + s * m₁ * p = b₂ - s * m₂ * q
    #
    # Assume that `X = b₁ + s * m₁ * p = b₂ - s * m₂ * q`
    #   X ≡ b₁ + s * m₁ * p ≡ b₁ (modulo m₁)
    #   X ≡ b₂ - s * m₂ * q ≡ b₂ (modulo m₂)
    # -->
    #   x = mod(X, m₁ * m₂)
    #     = mod(b₁ + ((b₂ - b₁) / d) * m₁ * p, m₁ * m₂)
    # ------------------------------------------------------
    # Check the answer is exist or not
    # (d, p, _) = gcdx(WIDTH, HEIGHT)
    # @assert mod(b1 - b2, d) == 0 "There is no solution"
    #
    # T = mod(b1 + div(b2 - b1, d) * WIDTH * p, WIDTH * HEIGHT)
end

end #module

using .Day14: d14_p1, d14_p2
export d14_p1, d14_p2
