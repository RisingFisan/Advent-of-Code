from sys import argv
import re

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = f.readlines()

p = re.compile("x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)")

range_x = None
range_y = None
range_z = None

for i, line in enumerate(lines):
    xi, xf, yi, yf, zi, zf = [int(x) for x in p.search(line).groups()]
    if not range_x:
        range_x = set(range(xi, xf + 1))
    else:
        if line.startswith("on"):
            range_x.update(range(xi, xf + 1))
        else:
            range_x.difference_update(range(xi, xf + 1))

    if not range_y:
        range_y = set(range(yi, yf + 1))
    else:
        if line.startswith("on"):
            range_y.update(range(yi, yf + 1))
        else:
            range_y.difference_update(range(yi, yf + 1))

    if not range_z:
        range_z = set(range(zi, zf + 1))
    else:
        if line.startswith("on"):
            range_z.update(range(zi, zf + 1))
        else:
            range_z.difference_update(range(zi, zf + 1))
    
    print(range_x)

part1 = 0

for x in range(-50, 51):
    if x in range_x:
        for y in range(-50, 51):
            if y in range_y:
                for z in range(-50, 51):
                    if z in range_z:
                        part1 += 1
                        print(x,y,z)

print(f"Part 1: {part1}")