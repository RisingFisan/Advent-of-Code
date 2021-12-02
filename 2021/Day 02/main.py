from sys import argv
from math import floor
from time import sleep

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = f.readlines()

(hpos, depth) = (0,0)
(hpos2, depth2, aim) = (0,0,0)

MAX_H = 2000
MAX_D = 1000000
TERM_H = 80 # Terminal horizontal length
TERM_D = 20 # Terminal vertical depth

for line in lines:

    # Graphical visualization of part 2
    grid = ["~" * TERM_H] + [' ' * TERM_H for _ in range(19)]
    old_s = list(grid[floor(depth2 * TERM_D / MAX_D)])
    old_s[floor(hpos2 * TERM_H / MAX_H)] = '>' if aim < 300 else ('⦣' if aim < 700 else 'v')
    grid[floor(depth2 * TERM_D / MAX_D)] = ''.join(old_s)
    print('\n'.join(grid) + f"\n{(hpos2, depth2, aim)}", end='\r')
    sleep(0.02)

    match (lambda a, b: (a,int(b)))(*line.split()):
        case ("forward", x):
            # part 1
            hpos += x

            # part 2
            hpos2 += x
            depth2 += aim * x
        case ("down", x):
            # part 1
            depth += x

            # part 2
            aim += x
        case ("up", x):
            # part 1
            depth -= x

            # part 2
            aim -= x
        case _: print(f"Error on line: {line}")

print(f"Part 1: {hpos * depth}")
print(f"Part 2: {hpos2 * depth2}")