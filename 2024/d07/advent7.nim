import re, strutils, sequtils, strformat, sugar

const testdata = """190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"""

let num_match = re"\d+"

proc numbers(line: string): seq[int] = 
    for x in line.findAll(num_match):
        result.add(x.parseInt)

func solve_equation(solution: int, value: int, values: seq[int]): bool = 
    if (value > solution): false
    elif (values.len == 0): solution == value
    else:
        var nvalues = values
        nvalues.delete(0)
        @[solve_equation(solution, value + values[0], nvalues),
        solve_equation(solution, value * values[0], nvalues)].anyIt(it == true)

func concat_number(val1: int, val2: int): int =
    var val1str = val1.intToStr
    let val2str = val2.intToStr
    val1str.add(val2str)
    val1str.parseInt

func solve_equation2(solution: int, value: int, values: seq[int]): bool = 
    if (value > solution): false
    elif (values.len == 0): solution == value
    else:
        var nvalues = values
        nvalues.delete(0)
        @[solve_equation2(solution, value + values[0], nvalues),
        solve_equation2(solution, value * values[0], nvalues),
        solve_equation2(solution, value.concat_number(values[0]), nvalues)].anyIt(it == true)

proc calculate(equation_fn: (int, int, seq[int]) -> bool, input: string): int =
    for x in input.splitLines:
        let nums = numbers(x)
        if (equation_fn(nums[0], nums[1], nums[2..<nums.len])):
            result += nums[0]

echo fmt"""
Test 1: {calculate(solve_equation, testdata)}
Real 1: {calculate(solve_equation, readFile("input.txt").strip())}
Test 2: {calculate(solve_equation2, testdata)}
Real 2: {calculate(solve_equation2, readFile("input.txt").strip())}
"""
