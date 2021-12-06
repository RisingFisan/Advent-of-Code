from sys import argv
import re
import numpy as np
from PIL import Image

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = f.readlines()

c = re.compile("(\d+),(\d+) -> (\d+),(\d+)")

board = dict()

for line in lines:
    x1, y1, x2, y2 = [int(x) for x in c.match(line).groups()]
    if x1 == x2 or y1 == y2:
        for y in range(min(y1,y2),max(y1,y2)+1):
            for x in range(min(x1,x2),max(x1,x2)+1):
                v = board.get((x,y), 0)
                board[(x,y)] = v + 1

part1 = 0

# minx = min(x[0] for x in board)
# miny = min(x[1] for x in board)
# maxx = max(x[0] for x in board)
# maxy = max(x[1] for x in board)

# for y in range(miny,maxy + 1):
#     for x in range(minx, maxx + 1):
#         print(board.get((x,y),0), end='')
#     print("")

for n in board.values():
    if n > 1:
        part1 += 1

print(f"Part 1: {part1}")

for line in lines:
    x1, y1, x2, y2 = [int(x) for x in c.match(line).groups()]
    if x1 != x2 and y1 != y2 and abs(x2 - x1) == abs(y2 - y1):
        for n in range(abs(x2 - x1) + 1):
            x = x1 + n if x2 > x1 else x1 - n
            y = y1 + n if y2 > y1 else y1 - n
            v = board.get((x,y), 0)
            board[(x,y)] = v + 1

part2 = 0

for n in board.values():
    if n > 1:
        part2 += 1

print(f"Part 2: {part2}")

minx = min(x[0] for x in board)
miny = min(x[1] for x in board)
maxx = max(x[0] for x in board)
maxy = max(x[1] for x in board)
maxn = max(n for n in board.values())

values = list()

for y in range(miny,maxy + 1):
    l = list()
    values.append(l)
    for x in range(minx, maxx + 1):
        n = board.get((x,y),0)
        l.append((n * 255 / maxn,0,255 if n > 1 else 0))

pixels : np.ndarray = np.array(values, dtype=np.uint8)
new_image = Image.fromarray(pixels)
new_image.save("part2.png")
