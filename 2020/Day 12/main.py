import enum

class Direction(enum.Enum):
    north = (0,1)
    south = (0,-1)
    east = (1,0)
    west = (-1,0)

move = lambda x, y: (x[0] + y[0], x[1] + y[1])
multiply = lambda x, a: (x[0] * a, x[1] * a)
rotate_left = lambda x: (-x[1], x[0])
rotate_right = lambda x: (x[1], -x[0])

def main():
    with open("input") as f:
        lines = [x.strip() for x in f.readlines()]

    ans1 = navigate(lines, Direction.east.value, part1=True)
    print("Part 1 =", abs(ans1[0]) + abs(ans1[1]))

    ans2 = navigate(lines, (10,1), part1=False)
    print("Part 2 =", abs(ans2[0]) + abs(ans2[1]))

def navigate(instrs, waypoint : tuple[int, int], part1):
    pos = (0,0)

    for instr in instrs:
        action = instr[0]
        value = int(instr[1:])

        if action == 'N':
            if part1:
                pos = move(pos,multiply(Direction.north.value,value))
            else:
                waypoint = move(waypoint,multiply(Direction.north.value,value))

        elif action == 'S':
            if part1:
                pos = move(pos,multiply(Direction.south.value,value))
            else:
                waypoint = move(waypoint,multiply(Direction.south.value,value))

        elif action == 'E':
            if part1:
                pos = move(pos,multiply(Direction.east.value,value))
            else:
                waypoint = move(waypoint,multiply(Direction.east.value,value))

        elif action == 'W':
            if part1:
                pos = move(pos,multiply(Direction.west.value,value))
            else:
                waypoint = move(waypoint,multiply(Direction.west.value,value))

        elif action == 'L':
            if value >= 90:
                waypoint = rotate_left(waypoint)
            if value >= 180:
                waypoint = rotate_left(waypoint)
            if value == 270:
                waypoint = rotate_left(waypoint)

        elif action == 'R':
            if value >= 90:
                waypoint = rotate_right(waypoint)
            if value >= 180:
                waypoint = rotate_right(waypoint)
            if value == 270:
                waypoint = rotate_right(waypoint)

        elif action == 'F':
            pos = move(pos,multiply(waypoint,value))
        
    return pos


if __name__ == "__main__":
    main()