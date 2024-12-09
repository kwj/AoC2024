# Advent of Code 2024

URL: https://adventofcode.com/2024

## Requirement

I used the Julia programming language.

* [Julia](https://julialang.org/) (confirmed to work with Julia v1.11.2)

The following package was then used.

- [Combinatorics](https://github.com/JuliaMath/Combinatorics.jl) v1.0.2

## Solutions

* [Day 1: Historian Hysteria!](./src/day_01) d01_p1(), d01_02()
* [Day 2: Red-Nosed Reports](./src/day_02) d02_p1(), d02_02()
* [Day 3: Mull It Over](./src/day_03) d03_p1(), d03_02()
* [Day 4: Ceres Search](./src/day_04) d04_p1(), d04_02()
* [Day 5: Print Queue](./src/day_05) d05_p1(), d05_02()
* [Day 6: Guard Gallivant](./src/day_06) d06_p1(), d06_02()
* [Day 7: Bridge Repair](./src/day_07) d07_p1(), d07_02()
* [Day 8: Resonant Collinearity](./src/day_08/) d08_p1(), d08_p2()
* [Day 9: Disk Fragmenter](./src/day_09/) d09_p1(), d09_p2()
* [Day 10: Hoof It](./src/day_10/) d10_p1(), d10_p2()
* [Day 11: Plutonian Pebbles](./src/day_11/) d11_p1(), d11_p2()
<!--
* [Day 12: ](./src/day_12/)
* [Day 13: ](./src/day_13/)
* [Day 14: ](./src/day_14/)
* [Day 15: ](./src/day_15/)
* [Day 16: ](./src/day_16/)
* [Day 17: ](./src/day_17/)
* [Day 18: ](./src/day_18/)
* [Day 19: ](./src/day_19/)
* [Day 20: ](./src/day_20/)
* [Day 21: ](./src/day_21/)
* [Day 22: ](./src/day_22/)
* [Day 23: ](./src/day_23/)
* [Day 24: ](./src/day_24/)
* [Day 25: ](./src/day_25/)
-->

## How to use

### [First time only] Setup dependencies for this project

```console
$ sh solve.sh init
```

### Place puzzle input data files into each solution folder in advance

For example, if the input file for Day 1 is `input`:

```console
$ ls src/day_01/
d01.jl  input
$
```

### Start Julia REPL

```console
$ sh solve.sh
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.11.2 (2024-12-01)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>
```

### Run solutions

For example, both parts of Day 1 have their own solutions.

```julia
julia> d01_p1("input")
****

julia> d01_p2("input")
****
```


## Note

There are no puzlle input data files in this repository.
Please get them from the AoC 2024 site.

Please see [here](https://adventofcode.com/about#faq_copying) for the reasons.
