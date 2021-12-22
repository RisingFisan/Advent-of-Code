from sys import argv
import re

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = f.readlines()

p = re.compile("x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)")

class Cuboid():
    def __init__(self, xi, xf, yi, yf, zi, zf) -> None:
        self.xi = xi
        self.xf = xf
        self.yi = yi
        self.yf = yf
        self.zi = zi
        self.zf = zf

    def __str__(self) -> str:
        return f"x={self.xi}..{self.xf},y={self.yi}..{self.yf},z={self.zi}..{self.zf}"

    def cut(self, coord, value, keep_on_left):
        match coord:
            case 'x':
                # print("XXX", self)
                return (Cuboid(self.xi, value if keep_on_left else value - 1, self.yi, self.yf, self.zi, self.zf), Cuboid(value + 1 if keep_on_left else value, self.xf, self.yi, self.yf, self.zi, self.zf))
            case 'y':
                return (Cuboid(self.xi, self.xf, self.yi, value if keep_on_left else value - 1, self.zi, self.zf), Cuboid(self.xi, self.xf, value + 1 if keep_on_left else value, self.yf, self.zi, self.zf))
            case 'z':
                return (Cuboid(self.xi, self.xf, self.yi, self.yf, self.zi, value if keep_on_left else value - 1), Cuboid(self.xi, self.xf, self.yi, self.yf, value + 1 if keep_on_left else value, self.zf))

cuboids : set[Cuboid] = set()

for i, line in enumerate(lines):
    # print(i)
    xi, xf, yi, yf, zi, zf = [int(x) for x in p.search(line).groups()]
    c = Cuboid(xi, xf, yi, yf, zi, zf)
    # print(f"NEW CUBOID: {c}")
    new_cuboids = set()
    for cx in cuboids:
        if c.xf < cx.xi or c.xi > cx.xf or c.yf < cx.yi or c.yi > cx.yf or c.zf < cx.zi or c.zi > cx.zf:
            new_cuboids.add(cx)
            continue
        if c.xi in range(cx.xi, cx.xf + 1):
            if c.xi > cx.xi:
                # print(f"CUTTING {cx} ON xi={c.xi}")
                c1, c2 = cx.cut('x', c.xi, False)
                # print(f"RESULT OF CUT: {c1} AND {c2}")
                new_cuboids.add(c1)
                cx = c2
        if c.xf in range(cx.xi, cx.xf + 1):
            if c.xf < cx.xf:
                # print(f"CUTTING {cx} ON xf={c.xf}")
                c1, c2 = cx.cut('x', c.xf, True)
                # print(f"RESULT OF CUT: {c1} AND {c2}")
                new_cuboids.add(c2)
                cx = c1

        if c.yi in range(cx.yi, cx.yf + 1):
            if c.yi > cx.yi:
                # print(f"CUTTING {cx} ON yi={c.yi}")
                c1, c2 = cx.cut('y', c.yi, False)
                # print(f"RESULT OF CUT: {c1} AND {c2}")
                new_cuboids.add(c1)
                cx = c2
        if c.yf in range(cx.yi, cx.yf + 1):
            if c.yf < cx.yf:
                # print(f"CUTTING {cx} ON yf={c.yf}")
                c1, c2 = cx.cut('y', c.yf, True)
                # print(f"RESULT OF CUT: {c1} AND {c2}")
                new_cuboids.add(c2)
                cx = c1

        if c.zi in range(cx.zi, cx.zf + 1):
            if c.zi > cx.zi:
                # print(f"CUTTING {cx} ON zi={c.zi}")
                c1, c2 = cx.cut('z', c.zi, False)
                # print(f"RESULT OF CUT: {c1} AND {c2}")
                new_cuboids.add(c1)
                cx = c2
        if c.zf in range(cx.zi, cx.zf + 1):
            if c.zf < cx.zf:
                # print(f"CUTTING {cx} ON zf={c.zf}")
                c1, c2 = cx.cut('z', c.zf, True)
                # print(f"RESULT OF CUT: {c1} AND {c2}")
                new_cuboids.add(c2)
                cx = c1

    if line.startswith("on"):
        new_cuboids.add(c)
    cuboids = new_cuboids.copy()
    # print(*cuboids, sep='\n')
    # temp = 0
    # for cuboid in cuboids:
    #     for x in range(cuboid.xi, cuboid.xf + 1):
    #         for y in range(cuboid.yi, cuboid.yf + 1):
    #             for z in range(cuboid.zi, cuboid.zf + 1):
    #                 print((x,y,z))
    #                 temp += 1   
    # print(temp)

    
part1 = 0
part2 = 0

for cuboid in cuboids:
    if cuboid.xf < -50 or cuboid.xi > 50:
        deltax1 = 0
    else:
        deltax1 = max(cuboid.xf, -50) - min(cuboid.xi,50) + 1

    if cuboid.yf < -50 or cuboid.yi > 50:
        deltay1 = 0
    else:
        deltay1 = max(cuboid.yf, -50) - min(cuboid.yi,50) + 1

    if cuboid.zf < -50 or cuboid.zi > 50:
        deltaz1 = 0
    else:
        deltaz1 = max(cuboid.zf, -50) - min(cuboid.zi,50) + 1

    part1 += deltax1 * deltay1 * deltaz1

    deltax = cuboid.xf - cuboid.xi + 1
    deltay = cuboid.yf - cuboid.yi + 1
    deltaz = cuboid.zf - cuboid.zi + 1

    part2 += deltax * deltay * deltaz

print(f"Part 1: {part1}")
print(f"Part 2: {part2}")