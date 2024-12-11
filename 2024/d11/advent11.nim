import memo, strformat, strutils

const input = [8793800, 1629, 65, 5, 960, 0, 138983, 85629]

proc even_digits(number: int64): bool =
    let numstr = number.intToStr
    numstr.len mod 2 == 0

proc split_number(number: int64): array[2, int64] =
    let numstr = number.intToStr
    [numstr.substr(0, (numstr.len / 2).toInt - 1).parseBiggestInt, numstr.substr((numstr.len / 2).toInt, numstr.len).parseBiggestInt]

proc blink(n: int, number: int64): int64 {.memoized.} =
    if (n == 0): 1
    else:
        if number == 0: blink(n-1, 1)
        elif even_digits(number):
            let split: array[2, int64] = split_number(number)
            blink(n-1, split[0]) + blink(n-1, split[1])
        else: blink(n-1, number * 2024)

proc solve(n: int, input: openArray[int]): int64 =
    for i in input:
        result += blink(n, i)

echo fmt"""
25 blinks: {solve(25, input)}
75 blinks: {solve(75, input)}
"""
