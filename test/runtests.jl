using AoC2024
using Test

# read test cases for solutions
include.(filter(contains(r"tc.*.jl$"), readdir("./")))
