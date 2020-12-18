from string import ascii_lowercase
from functools import reduce

with open("input") as f:
    groups = f.read().split("\n\n")

(ans1,ans2) = (0,0)

for group in groups:
    part1 : set[str] = set()
    part2 : set[str] = set(ascii_lowercase)
    for question in group.split():
        part1.update(question)
        part2.intersection_update(question)
    ans1 += len(part1)
    ans2 += len(part2)

# One liner versions:

# ans1 = sum(len(reduce(lambda acc, x: set.union(acc,set(x)), group.split(), set())) for group in groups)
# ans2 = sum(len(reduce(lambda acc, x: set.intersection(set(acc),set(x)), group.split())) for group in groups)

print("Part 1 =", ans1)
print("Part 2 =", ans2)