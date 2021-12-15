from sys import argv
from collections import deque

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = f.readlines()

risks = dict()

for y, line in enumerate(lines):
    for x, r in enumerate(line.strip()):
        risks[(x,y)] = int(r)
    len_x = x + 1
len_y = y + 1

def find_path(risks, len_x, len_y):
    parents = dict()
    risks_path = dict()
    visited = set()

    q = set()
    x = (0,0)
    risks_path[(0,0)] = 0
    q.add(x)

    while len(q) > 0:
        (min_p, _) = sorted(((p,risks_path[p]) for p in q), key=lambda x: x[1])[0]
        x = min_p
        q.remove(x)
        visited.add(x)
        r = risks_path[x]
        neighbors = set(y for y in [(x[0]-1,x[1]),(x[0]+1,x[1]),(x[0],x[1]-1),(x[0],x[1]+1)] if y[0] in range(0,len_x) and y[1] in range(0,len_y)).difference(visited)
        q.update(neighbors)
        for p in neighbors:
            risk = risks[p]
            past_risk = risks_path.get(p, None)
            if past_risk is None or r + risk < past_risk:
                risks_path[p] = r + risk
                parents[p] = x
    return risks_path

part1 = find_path(risks, len_x, len_y)

print(f"Part 1: {part1[(len_x-1,len_y-1)]}")

for y in range(len_y):
    for x in range(len_x):
        for mult_x in range(1,5):
            new_r = risks[(x,y)] + mult_x
            while new_r >= 10:
                new_r -= 9
            risks[(x + len_x * mult_x,y)] = new_r
    for x in range(len_x * 5):
        for mult_y in range(1,5):
            new_r = risks[(x,y)] + mult_y
            while new_r >= 10:
                new_r -= 9
            risks[(x,y + len_y * mult_y)] = new_r
        
# with open("new_input", "w") as f:
#     for y in range(len_y * 5):
#         for x in range(len_x * 5):
#             f.write(str(risks[(x,y)]))
#         f.write("\n")

part2 = find_path(risks, len_x * 5, len_y * 5)

print(f"Part 2: {part2[(len_x*5-1,len_y*5-1)]}")

