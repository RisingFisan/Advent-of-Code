from sys import argv
from math import prod

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = [[int(x) for x in line.strip()] for line in f.readlines()]

max_x = len(lines[0]) - 1
max_y = len(lines) - 1

low_points = list()
neighbors = dict()

for y in range(max_y + 1):
    for x in range(max_x + 1):
        d = neighbors.setdefault((x,y),list())
        if x > 0:
            d.append((x-1,y))
        if x < max_x:
            d.append((x+1,y))
        if y > 0:
            d.append((x,y-1))
        if y < max_y:
            d.append((x,y+1))

for (xp,yp) in neighbors:
    if min([lines[y][x] for (x,y) in neighbors[(xp,yp)]]) > lines[yp][xp]:
        low_points.append((xp,yp))

print(f"Part 1: {sum(lines[y][x]+1 for (x,y) in low_points)}")

basins = list()

for p in low_points:
    visited = set()
    queue = list()
    queue.append(p)
    while len(queue) > 0:
        pp = queue.pop(0)
        visited.add(pp)
        for (x,y) in neighbors[pp]:
            if (x,y) not in visited and lines[y][x] < 9:
                queue.append((x,y))
    basins.append(visited)

print(f"Part 2: {prod(sorted([len(x) for x in basins],reverse=True)[:3])}")