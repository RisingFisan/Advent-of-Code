from sys import argv

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = [int(x) for x in f.readlines()]

part1 = 0
prev = None
for line in lines:
    if prev != None and line > prev:
        part1 += 1
    prev = line

print(f"Part 1 = {part1}")

part2 = 0
prev = None
windows = [ sum(x) for x in zip(lines, lines[1:], lines[2:]) ]
for window in windows:
    if prev != None and window > prev:
        part2 += 1
    prev = window

print(f"Part 2 = {part2}")


# Compact version:

# with open(argv[1] if len(argv) > 1 else "input") as f: 
#     lines = [int(x) for x in f.readlines()]
#     print(f"Part 1 = {sum([ int(b > a) for (a,b) in zip(lines, lines[1:]) ])}")
#     print(f"Part 2 = {sum([ int(b > a) for (a,b) in (lambda x: zip(x, x[1:]))([ sum(x) for x in zip(lines, lines[1:], lines[2:]) ]) ])}")
