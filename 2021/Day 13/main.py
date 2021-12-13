from sys import argv
import re

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = f.readlines()

p1 = re.compile(r'(\d+),(\d+)')
p2 = re.compile(r'fold along (x|y)=(\d+)')
dots = set()
folds = list()

points = True
for line in lines:
    if points:
        m = p1.match(line)
        if m:
            (x,y) = m.groups()
            dots.add((int(x),int(y)))
        else:
            points = False
    else:
        m = p2.match(line)
        coord, v = m.groups()
        folds.append((coord,int(v)))

# max_x = max(p[0] for p in dots)
# max_y = max(p[1] for p in dots)

# for y in range(max_y+1):
#     for x in range(max_x+1):
#         print("#" if (x,y) in dots else ".", end='')
#     print('')
# print("\nXXXXXXXXXXXXXXXX\n")

for i, (coord, v) in enumerate(folds):
    if coord == 'x':
        new_dots = dots.copy()
        for (x,y) in dots:
            if x > v:
                diff = x - v
                new_dots.remove((x,y))
                new_dots.add((v - diff,y))
    else:
        new_dots = dots.copy()
        for (x,y) in dots:
            if y > v:
                diff = y - v
                new_dots.remove((x,y))
                new_dots.add((x,v - diff))
    dots = new_dots
    if i == 0:
        print(f"Part 1: {len(dots)}")

max_x = max(p[0] for p in new_dots)
max_y = max(p[1] for p in new_dots)

for y in range(max_y+1):
    for x in range(max_x+1):
        print("#" if (x,y) in new_dots else " ", end='')
    print('')


