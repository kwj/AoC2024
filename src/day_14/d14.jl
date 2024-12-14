
module Day14

import Statistics: var

const WIDTH = 101
const HEIGHT = 103

function parse_file(fname::String)
    re = r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)"
    tpl = stack(
        map(readlines(joinpath(@__DIR__, fname))) do line
            parse.(Int, match(re, line).captures)
        end
    ) |> eachrow

    tpl[1] .+ 1, tpl[2] .+ 1, tpl[3], tpl[4]
end

function new_state(p::AbstractVector{Int}, v::AbstractVector{Int}, m::Int, t::Int)
    mod1.(p + t .* v, m)
end

function d14_p1(fname::String = "input")
    px, py, vx, vy = parse_file(fname)

    grid = zeros(Int, WIDTH, HEIGHT)
    for pos in eachrow(hcat(new_state(px, vx, WIDTH, 100), new_state(py, vy, HEIGHT, 100)))
        grid[CartesianIndex(pos...)] += 1
    end

    # [grid]
    #   +---------- H
    #   | n1 | n3 |
    #   |----+----|
    #   | n2 | n4 |
    #   |----------
    #   W
    #
    # Note: WIDTH and HEIGHT are odd numbers
    n1 = grid[1:(WIDTH ÷ 2), 1:(HEIGHT ÷ 2)] |> sum
    n2 = grid[(WIDTH ÷ 2 + 2):end, 1:(HEIGHT ÷ 2)] |> sum
    n3 = grid[1:(WIDTH ÷ 2), (HEIGHT ÷ 2 + 2):end] |> sum
    n4 = grid[(WIDTH ÷ 2 + 2):end, (HEIGHT ÷ 2 + 2):end] |> sum

    n1 * n2 * n3 * n4
end

function d14_p2(fname::String = "input")
    px, py, vx, vy = parse_file(fname)

    # I guess that the picture will be complete when robots are gathered.
    # I therefore search for the timings when the variances of
    # px and py are smallest in the first cycle of each.
    tx = argmin(t -> var(new_state(px, vx, WIDTH, t)), 0:(WIDTH - 1))
    ty = argmin(t -> var(new_state(py, vy, HEIGHT, t)), 0:(HEIGHT - 1))

    # Assume that `T` is the answer:
    #   T ≡ tx (modulo WIDTH)
    #   T ≡ ty (modulo HEIGHT)

    # Check the answer is exist or not
    (d, p, _) = gcdx(WIDTH, HEIGHT)
    @assert mod(tx, d) == mod(ty, d) "There is no solution"

    # We can solve this problem using the Chinese remainder theorem.
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
    mod(tx + div(ty - tx, d) * WIDTH * p, WIDTH * HEIGHT)
end

end #module

using .Day14: d14_p1, d14_p2
export d14_p1, d14_p2
