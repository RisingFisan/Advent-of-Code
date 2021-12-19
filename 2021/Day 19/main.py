from sys import argv
import re
from itertools import combinations, permutations
from math import sqrt, perm, ceil

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = f.readlines()

p1 = re.compile("\-+ scanner (\d+)")
p2 = re.compile("(-?\d+),(-?\d+),(-?\d+)")

scannersInput = dict()
positions = dict()
distancesM = dict()
distancesE = dict()
common_n = perm(12,2) // 2

final_beacons = dict()

curScanner = None
for line in lines:
    m = p1.match(line)
    if m:
        curScanner = int(m.group(1))
        scannersInput[curScanner] = set()
    else:
        m = p2.match(line)
        if m:
            scannersInput[curScanner].add(tuple(int(x) for x in m.groups()))

final_beacons[0] = scannersInput[0].copy()

for n, beacons in scannersInput.items():
    distancesE[n] = set(sqrt(sum((a[i] - b[i]) ** 2 for i in range(3))) for (a,b) in permutations(beacons, 2))

positions[0] = (0,0,0)

rotate = lambda a, b, c: (a, c, -b)
turn_around = lambda a, b, c: (-a, -b, c)
turn_to_y = lambda a, b, c: (b, -a, c)
turn_to_z = lambda a, b, c: (-c, b, a)
calc_pos = lambda a, b: (a[0] + b[0], a[1] + b[1], a[2] + b[2])

while positions.keys() != scannersInput.keys():
    pc = positions.copy()
    for n in scannersInput:
        if n in positions: continue
        for np in pc:
            if len(distancesE[n].intersection(distancesE[np])) >= common_n:
                beaconsP = final_beacons[np]
                beacons = scannersInput[n].copy()
                distancesP = set((lambda a, b: (b[0] - a[0], b[1] - a[1], b[2] - a[2]))(a,b) for (a,b) in permutations(beaconsP, 2))
                matched = False
                for c in "xyz": # which direction is the bitch facing
                    for _ in range(2): # turn around
                        for _ in range(4): # rotate
                            distancesX = set((lambda a, b: (b[0] - a[0], b[1] - a[1], b[2] - a[2]))(a,b) for (a,b) in permutations(beacons, 2))
                            if len(distancesX.intersection(distancesP)) >= common_n:
                                matched = True
                                for (a,b) in permutations(beaconsP, 2):
                                    for (c,d) in permutations(beacons, 2):
                                        if (b[0] - a[0], b[1] - a[1], b[2] - a[2]) == (d[0] - c[0], d[1] - c[1], d[2] - c[2]):
                                            positions[n] = (a[0] - c[0], a[1] - c[1], a[2] - c[2])
                                            break
                                    if n in positions:
                                        break
                                final_beacons[n] = set()
                                for b in beacons:
                                    final_beacons[n].add(calc_pos(positions[n], b))
                            if matched:
                                break
                            beacons = set(rotate(*x) for x in beacons)
                        if matched:
                            break
                        beacons = set(turn_around(*x) for x in beacons)

                    if matched:
                        break

                    if c == 'x':
                        beacons = set(turn_to_y(*x) for x in beacons)
                    elif c == 'y':
                        beacons = set(turn_to_z(*x) for x in beacons)

print(f"Part 1: {len(set.union(*final_beacons.values()))}")

part2 = 0

for s1, s2 in combinations(positions.values(), 2):
    md = sum(abs(s1[i] - s2[i]) for i in range(3))
    if md > part2:
        part2 = md

print(f"Part 2: {part2}")