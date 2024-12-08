module AoC2024

solutions = [
    "day_01/d01.jl",
    "day_02/d02.jl",
    "day_03/d03.jl",
    "day_04/d04.jl",
    "day_05/d05.jl",
    "day_06/d06.jl",
    "day_07/d07.jl",
    "day_08/d08.jl",
]

for sol in solutions
    include(joinpath(@__DIR__, sol))
end

end # module AoC2024
