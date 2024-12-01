import std/nre, std/strutils, std/algorithm, std/strformat, std/tables

const testdata = """3   4
4   3
2   5
1   3
3   9
3   3
"""

let num_matcher = re"\d+"

proc get_lists(input: string): array[2, seq[int]] =
    var flip = true
    var list_a: seq[int] = @[]
    var list_b: seq[int] = @[]
    for match in input.findAll(num_matcher):
        if flip: list_a.add(match.parseInt)
        else: list_b.add(match.parseInt)
        flip = not flip
    [list_a, list_b]

proc total_difference(list_a: seq[int], list_b: seq[int]): int =
    let sorted_a = sorted(list_a)
    let sorted_b = sorted(list_b)
    for i in 0 ..< list_a.len:
        result += abs(sorted_a[i] - sorted_b[i])

proc similarity_score(list_a: seq[int], list_b: seq[int]): int =
    let frequencies = list_b.toCountTable
    for x in list_a:
        result += x * frequencies.getOrDefault(x, 0)

let test_lists = get_lists(testdata)
let real_lists = get_lists(readFile("input.txt"))

echo fmt"""
Test 1: {total_difference(test_lists[0], test_lists[1])}
Real 1: {total_difference(real_lists[0], real_lists[1])}
Test 2: {similarity_score(test_lists[0], test_lists[1])}
Real 2: {similarity_score(real_lists[0], real_lists[1])}
"""
