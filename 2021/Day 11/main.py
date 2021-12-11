from sys import argv

with open(argv[1] if len(argv) > 1 else "input") as f:
    octopi = [[int(x) for x in line.strip()] for line in f.readlines()]

max_x = len(octopi[0]) - 1
max_y = len(octopi) - 1
total_octopi = (max_x + 1) * (max_y + 1)

neighbors = dict()
part1 = 0

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

i = 0
while True:
    part2 = 0
    queue = list()
    for y in range(max_y + 1):
        for x in range(max_x + 1):
            v = octopi[y][x]
            if v == 9:
                part2 += 1
                octopi[y][x] = 0
                queue.append((x,y))
            else:
                octopi[y][x] = v + 1
    while len(queue) > 0:
        (x,y) = queue.pop(0)
        for yy in range(max(y-1,0),min(y+1,max_y)+1):
            for xx in range(max(x-1,0),min(x+1,max_x)+1):
                if (xx,yy) != (x,y):
                    v = octopi[yy][xx]
                    if v != 0:
                        if v == 9:
                            part2 += 1
                            octopi[yy][xx] = 0
                            queue.append((xx,yy))
                        else:
                            octopi[yy][xx] = v + 1
    i += 1
    part1 += part2
    if i == 100:
        print(f"Part 1: {part1}")
    if part2 == total_octopi:
        # print('\n'.join([''.join([str(x) for x in line]) for line in octopi]))
        print(f"Part 2: {i}")
        break


