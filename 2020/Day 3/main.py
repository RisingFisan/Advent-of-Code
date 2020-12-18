def main():
    with open("input") as f:
        lines = [line.strip() for line in f.readlines()]

    width = len(lines[0])
    total = 1

    for slope_x, slope_y in [(1,1),(3,1),(5,1),(7,1),(1,2)]:
        (x,y) = (0,0)
        trees = 0
        while y < len(lines):
            if lines[y][x % width] == '#':
                trees += 1
            x += slope_x
            y += slope_y
        
        if slope_x == 3 and slope_y == 1: print(f"Part 1 = {trees}")
        total *= trees
    
    print(f"Part 2 = {total}")

if __name__ == "__main__":
    main()