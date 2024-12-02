import std/re, strutils, sequtils, strformat

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
let realdata = readFile("input.txt").to_matrix

proc line_safe(line: seq[int]): bool =
    var allPos, allNeg = true
    for i in 1..<line.len:
        var diff = line[i] - line[i-1]
        if (abs(diff) < 1 or abs(diff) > 3): return false
        if (diff >= 0): allNeg = false
        if (diff < 0): allPos = false

    return allPos or allNeg

proc line_safeish(line: seq[int]): bool =
    for x in 0..<line.len:
        var nline = line
        nline.delete(x)
        if (line_safe(nline)): return true
    return false

echo fmt"""
Test 1: {testdata.countIt(line_safe(it))}
Real 1: {realdata.countIt(line_safe(it))}

Test 2: {testdata.countIt(line_safeish(it))}
Real 2: {realdata.countIt(line_safeish(it))}
"""
