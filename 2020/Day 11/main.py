import time

with open("input") as f:
    lines = [list(line.strip()) for line in f.readlines()]

# print("\n".join(''.join(line) for line in lines),"\n")

floor = '.'
empty = "L"
occupied = '#'
height = len(lines)
width = len(lines[0])

def main():
    start = time.time()
    ans1 = part1(lines.copy())
    end = time.time()

    print("Part 1 =", ans1, f"\tTime = {end-start}s")

    start = time.time()
    ans2 = part2(lines.copy())
    end = time.time()

    print("Part 2 =", ans2, f"\tTime = {end-start}s")

def part1(lines):
    while True:
        # time.sleep(0.5)
        new_lines = [line.copy() for line in lines]
        n_changes = 0
        for i in range(height):
            for j in range(width):
                if lines[i][j] == floor: continue
                occupied_seats = 0
                for y,x in {(i,j+1),(i,j-1),(i+1,j),(i-1,j),(i+1,j+1),(i-1,j-1),(i-1,j+1),(i+1,j-1)}:
                    if x in range(width) and y in range(height):
                        if lines[y][x] == occupied:
                            occupied_seats += 1
                if lines[i][j] == empty and occupied_seats == 0:
                    new_lines[i][j] = occupied
                    n_changes += 1
                elif lines[i][j] == occupied and occupied_seats >= 4:
                    new_lines[i][j] = empty
                    n_changes += 1
        lines = new_lines
        # print("\n".join(''.join(line) for line in lines),"\n")
        if n_changes == 0:
            break
    return sum([[x for x in line].count(occupied) for line in lines])

def part2(lines):
    while True:
        # time.sleep(0.5)
        new_lines = [line.copy() for line in lines]
        n_changes = 0
        for i in range(height):
            for j in range(width):
                if lines[i][j] == floor: continue
                occupied_seats = 0
                for inc_i,inc_j in {(1,1),(1,-1),(-1,1),(-1,-1),(1,0),(0,1),(0,-1),(-1,0)}:
                    x,y = j,i
                    while True:
                        x += inc_j
                        y += inc_i
                        if not 0 <= x < width or not 0 <= y < height:
                            break
                        elif lines[y][x] != floor:
                            if lines[y][x] == occupied:
                                occupied_seats += 1
                            break
                if lines[i][j] == empty and occupied_seats == 0:
                    new_lines[i][j] = occupied
                    n_changes += 1
                elif lines[i][j] == occupied and occupied_seats >= 5:
                    new_lines[i][j] = empty
                    n_changes += 1
        lines = new_lines
        # print("\n".join(''.join(line) for line in lines),"\n")
        if n_changes == 0:
            break
    return sum([[x for x in line].count(occupied) for line in lines])

if __name__ == "__main__":
    main()