# test cases for example inputs on Advent of Code 2024

@testset verbose = true "Advent of Code 2024 (examples)" begin
    @testset "Day 1 / Part 1" begin
        @test d01_p1("input0") == 11
    end
    @testset "Day 1 / Part 2" begin
        @test d01_p2("input0") == 31
    end

    @testset "Day 2 / Part 1" begin
        @test d02_p1("input0") == 2
    end
    @testset "Day 2 / Part 2" begin
        @test d02_p2("input0") == 4
    end

    @testset "Day 3 / Part 1" begin
        @test d03_p1("input0") == 161
    end
    @testset "Day 3 / Part 2" begin
        @test d03_p2("input1") == 48
    end

    @testset "Day 4 / Part 1" begin
        @test d04_p1("input0") == 18
    end
    @testset "Day 4 / Part 2" begin
        @test d04_p2("input0") == 9
    end

    @testset "Day 5 / Part 1" begin
        @test d05_p1("input0") == 143
    end
    @testset "Day 5 / Part 2" begin
        @test d05_p2("input0") == 123
    end

    @testset "Day 6 / Part 1" begin
        @test d06_p1("input0") == 41
    end
    @testset "Day 6 / Part 2" begin
        @test d06_p2("input0") == 6
    end

    @testset "Day 7 / Part 1" begin
        @test d07_p1("input0") == 3749
    end
    @testset "Day 7 / Part 2" begin
        @test d07_p2("input0") == 11387
    end

    @testset "Day 8 / Part 1" begin
        @test d08_p1("input0") == 14
    end
    @testset "Day 8 / Part 2" begin
        @test d08_p2("input0") == 34
    end

    @testset "Day 9 / Part 1" begin
        @test d09_p1("input0") == 1928
    end
    @testset "Day 9 / Part 2" begin
        @test d09_p2("input0") == 2858
    end

    @testset "Day 10 / Part 1" begin
        @test d10_p1("input0") == 36
    end
    @testset "Day 10 / Part 2" begin
        @test d10_p2("input0") == 81
    end

    # There is no example input data for Day 11 (Part 2) on AoC 2024.
    @testset "Day 11 / Part 1" begin
        @test d11_p1("input0") == 55312
    end

    @testset "Day 12 / Part 1" begin
        @test d12_p1("input0") == 140
        @test d12_p1("input1") == 1930
    end
    @testset "Day 12 / Part 2" begin
        @test d12_p2("input0") == 80
        @test d12_p2("input1") == 1206
    end

    # There is no example answer for Day 13 (Part 2) on AoC 2024.
    @testset "Day 13 / Part 1" begin
        @test d13_p1("input0") == 480
    end

    # There is no example input data for Day 14 (Part 2) on AoC 2024.
    @testset "Day 14 / Part 1" begin
        @test d14_p1("input0", WIDTH = 11, HEIGHT = 7) == 12
    end

    @testset "Day 15 / Part 1" begin
        @test d15_p1("input0") == 10092
        @test d15_p1("input1") == 2028
    end
    @testset "Day 15 / Part 2" begin
        @test d15_p2("input0") == 9021
    end

    @testset "Day 16 / Part 1" begin
        @test d16_p1("input0") == 7036
        @test d16_p1("input1") == 11048
    end
    @testset "Day 16 / Part 2" begin
        @test d16_p2("input0") == 45
        @test d16_p2("input1") == 64
    end

    @testset "Day 17 / Part 1" begin
        @test d17_p1("input0") == "4,6,3,5,6,3,5,2,1,0"
    end
    @testset "Day 17 / Part 2" begin
        @test d17_p2("input1") == 117440
    end

    @testset "Day 18 / Part 1" begin
        @test d18_p1("input0", X_SIZE = 7, Y_SIZE = 7, NUM_FALLING_OBJS = 12) == 22
    end
    @testset "Day 18 / Part 2" begin
        @test d18_p2("input0", X_SIZE = 7, Y_SIZE = 7, NUM_FALLING_OBJS = 12) == "6,1"
    end

    @testset "Day 19 / Part 1" begin
        @test d19_p1("input0") == 6
    end
    @testset "Day 19 / Part 2" begin
        @test d19_p2("input0") == 16
    end

    @testset "Day 20 / Part 1" begin
        @test d20_p1("input0", thr = 1) == 44
        @test d20_p1("input0", thr = 20) == 5
    end
    @testset "Day 20 / Part 2" begin
        @test d20_p2("input0", thr = 50) == 285
        @test d20_p2("input0", thr = 70) == 41
    end

    # There is no example answer for Day 21 (Part 2) on AoC 2024.
    @testset "Day 21 / Part 1" begin
        @test d21_p1("input0") == 126384
    end

    @testset "Day 22 / Part 1" begin
        @test d22_p1("input0") == 37327623
    end
    @testset "Day 22 / Part 2" begin
        @test d22_p2("input1") == 23
    end

    @testset "Day 23 / Part 1" begin
        @test d23_p1("input0") == 7
    end
    @testset "Day 23 / Part 2" begin
        @test d23_p2("input0") == "co,de,ka,ta"
    end

    # There is no example input data for Day 24 (Part 2) on AoC 2024.
    @testset "Day 24 / Part 1" begin
        @test d24_p1("input0") == 4
        @test d24_p1("input1") == 2024
    end

    @testset "Day 25 / Part 1" begin
        @test d25_p1("input0") == 3
    end
end
