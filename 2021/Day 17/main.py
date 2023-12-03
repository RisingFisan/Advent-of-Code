from sys import argv
import re
import time

with open(argv[1] if len(argv) > 1 else "input") as f:
    (minX, maxX, minY, maxY) = [int(x) for x in re.match(r'target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)', f.read()).groups()]

part1 = 0
part2 = 0
t = time.time()

(velX, velY) = (1,minY)

while velY < abs(minY):
    success = False
    velX = 1
    while velX <= maxX:
        (x,y) = (0,0)
        (vx, vy) = (velX, velY)
        part1Temp = y
        while x <= maxX and y >= minY:
            (x,y) = (x + vx, y + vy)
            if vx > 0: vx -= 1
            elif vx < 0: vx += 1
            vy -= 1
            if y > part1Temp: 
                part1Temp = y

            if x in range(minX, maxX+1) and y in range(minY, maxY+1):
                part2 += 1
                success = True
                if part1Temp > part1:
                    part1 = part1Temp
                break
        velX += 1
    velY += 1

print(f"Part 1: {part1}")
print(f"Part 2: {part2}")