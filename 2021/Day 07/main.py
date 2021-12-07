from sys import argv

with open(argv[1] if len(argv) > 1 else "input") as f:
    crabs = [int(x) for x in f.read().split(',')]

minX = min(crabs)
maxX = max(crabs)

part1 = 1e9

for i in range(minX, maxX):
    s = sum(abs(crab - i) for crab in crabs)
    if s < part1:
        part1 = s

print(f"Part 1: {part1}")

part2 = 1e9

for i in range(minX, maxX):
    # sum(range(x+1)) = x * (x + 1) // 2
    s = sum((lambda d: d * (d + 1) // 2)(abs(crab - i)) for crab in crabs)
    if s < part2:
        part2 = s

print(f"Part 2: {part2}")