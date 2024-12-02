import std/re, strutils, sugar, sequtils, strformat

let newline = re"\n"
let whitespace = re"\s+"

proc to_matrix(input: string): seq[seq[int]] =
    for line in input.split(newline):
        var lineseq: seq[int] = @[]
        for x in line.split(whitespace):
            lineseq.add(x.parseInt)
        result.add(lineseq)

let testdata = """7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9""".to_matrix

proc line_safe(line: seq[int]): bool =
    var diffs: seq[int] = @[]
    for i in 1..<line.len:
        diffs.add(line[i] - line[i-1])
    var allPos = true
    var allNeg = true
    for i in diffs:
        if (abs(i) < 1 or abs(i) > 3): return false
        if (i >= 0): allNeg = false
        if (i < 0): allPos = false

    return allPos or allNeg

let realdata = readFile("input.txt").to_matrix

echo fmt"""
Test 1: {testdata.filterIt(line_safe(it)).len}
Real 1: {realdata.filterIt(line_safe(it)).len}

Test 2: TODO
Real 2: TODO
"""
