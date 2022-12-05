from sys import argv
from collections import deque
import re
import time

start = time.time_ns()

with open(argv[1] if len(argv) > 1 else "input.txt") as f:
    crates_s, instructions = f.read().split("\n\n")

crates : dict[int, deque] = dict()
for line in crates_s.split('\n')[:-1]:
    for j,c in enumerate(line[1::4]):
        if c != ' ':
            crates.setdefault(j+1, deque()).appendleft(c)

crates_p2 = { k: v.copy() for k,v in crates.items() }

for line in instructions.split('\n'):
    if line:
        move, from_, to = map(int, re.search(r"move (\d+) from (\d+) to (\d+)", line).groups())
        taken = [ crates[from_].pop() for _ in range(0,move) ]
        taken_p2 = [ crates_p2[from_].pop() for _ in range(0,move) ]
        crates[to].extend(taken)
        crates_p2[to].extend(reversed(taken_p2))

print(f"Part 1: {''.join([stack[-1] for _,stack in sorted(crates.items())])}")

print(f"Part 2: {''.join([stack[-1] for _,stack in sorted(crates_p2.items())])}")

end = time.time_ns()

print(f"Time (uSecs): {(end - start) // 1000}")