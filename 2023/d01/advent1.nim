import strutils, std/nre, std/sugar, std/tables, zero_functional

const testdata1 = """1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"""

const testdata2 = """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"""

let digitspattern = re"[0-9]"
let pattern = re"(?=([0-9]|one|two|three|four|five|six|seven|eight|nine|zero))"

const conversion = {
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
    "zero": "0"
}.toTable

proc numbersOnLine(text: string): seq[string] =
    ## Find all numbers in a string, including digits and strings ("one")
    ## Also will find overlapping numbers ("oneight" = ["one", "eight"])
    collect:
        for match in text.findIter(pattern): match.captures[0]
proc digitsOnLine(text: string): seq[string] =
    ## Find all digits in a string
    text.findAll(digitspattern)
proc convertNumbers(strings: seq[string]): seq[string] =
    ## Attempt to convert a string into a number ("one" = "1")
    ## Digits are not converted ("1" = "1")
    collect:
        for x in items(strings):
            conversion.getOrDefault(x, x)

proc sumData(matcher: (string) -> seq[string], lines: seq[string]): int =
  lines -->
  map(matcher)
  .map(convertNumbers)
  .map([it[0], it[it.len - 1]])
  .map(it.join("").parseInt)
  .reduce(it.accu + it.elem)
  
# proc sumData(matcher: (string) -> seq[string], lines: seq[string]): int =
#   lines.map(matcher)
#   .map(convertNumbers)
#   .mapIt([it[0], it[it.len - 1]])
#   .mapIt(it.join("").parseInt)
#   .foldl((acc, elem) -> acc + elem)

echo "Test 1: " & sumData(digitsOnLine, testdata1.splitLines()).intToStr
echo "Input 1: " & sumData(digitsOnLine, readFile("input1.txt").strip.splitLines).intToStr
echo "Test 2: " & sumData(numbersOnLine, testdata2.splitLines()).intToStr
echo "Input 2: " & sumData(numbersOnLine, readFile("input1.txt").strip.splitLines).intToStr
