neighbors = lambda p: set((x,y,z) for x in {p[0]-1,p[0],p[0]+1} for y in {p[1]-1,p[1],p[1]+1} for z in {p[2]-1,p[2],p[2]+1}).difference({p})

hyper_neighbors = lambda p: set((x,y,z,w) for x in {p[0]-1,p[0],p[0]+1} for y in {p[1]-1,p[1],p[1]+1}
                                          for z in {p[2]-1,p[2],p[2]+1} for w in {p[3]-1,p[3],p[3]+1}).difference({p})

def main():
    grid = list()

    with open("input") as f:
        for line in f.readlines():
            row = list()
            for elem in line.strip():
                row.append(elem)
            grid.append(row)

    print("Part 1 =", part1([ [line.copy() for line in grid] ]))

    print("Part 2 =", part2([ [ [line.copy() for line in grid] ] ]))

def part1(cubes):
    max_x = len(cubes[0][0])
    max_y = len(cubes[0])
    max_z = 0

    for _ in range(6):
        max_x += 2
        max_y += 2
        max_z += 2
        new_cubes = list()
        # new_cubes = [[['.' for x in range(min_x,max_x+1)] for y in range(min_y,max_y+1)] for z in range(min_z,max_z+1)]
        for z in range(max_z+1):
            grid = list()
            for y in range(max_y+1):
                line = list()
                for x in range(max_x+1):
                    n = 0
                    for xn,yn,zn in neighbors((x,y,z)):
                        try:
                            if zn > 0 and yn > 0 and xn > 0 and cubes[zn-1][yn-1][xn-1] == '#':
                                n += 1
                        except: pass
                    try:
                        if z > 0 and y > 0 and x > 0: pos = cubes[z-1][y-1][x-1]
                        else: pos = '.'
                    except IndexError:
                        pos = '.'
                    if ( pos == '#' and n in range(2,4) ) or ( pos == '.' and n == 3 ):
                        line.append('#')
                    else:
                        line.append('.')
                grid.append(line)
            new_cubes.append(grid)

        cubes = new_cubes             

    ans = 0

    for z in range(len(cubes)):
        # print("z =", z)
        for y in range(len(cubes[0])):
            # print(''.join(cubes[z][y]))
            ans += cubes[z][y].count('#')

    return ans

def part2(hyper_cubes):
    max_x = len(hyper_cubes[0][0][0])
    max_y = len(hyper_cubes[0][0])
    max_z = 0
    max_w = 0

    for _ in range(6):
        max_x += 2
        max_y += 2
        max_z += 2
        max_w += 2
        new_hyper_cubes = list()
        # new_cubes = [[['.' for x in range(min_x,max_x+1)] for y in range(min_y,max_y+1)] for z in range(min_z,max_z+1)]
        for w in range(max_w + 1):
            cube = list()
            for z in range(max_z+1):
                grid = list()
                for y in range(max_y+1):
                    line = list()
                    for x in range(max_x+1):
                        n = 0
                        for xn,yn,zn,wn in hyper_neighbors((x,y,z,w)):
                            try:
                                if wn > 0 and zn > 0 and yn > 0 and xn > 0 and hyper_cubes[wn-1][zn-1][yn-1][xn-1] == '#':
                                    n += 1
                            except: pass
                        try:
                            if w > 0 and z > 0 and y > 0 and x > 0: pos = hyper_cubes[w-1][z-1][y-1][x-1]
                            else: pos = '.'
                        except IndexError:
                            pos = '.'
                        if ( pos == '#' and n in range(2,4) ) or ( pos == '.' and n == 3 ):
                            line.append('#')
                        else:
                            line.append('.')
                    grid.append(line)
                cube.append(grid)
            new_hyper_cubes.append(cube)
        hyper_cubes = new_hyper_cubes             

    ans = 0

    for w in range(len(hyper_cubes)):
        for z in range(len(hyper_cubes[0])):
            # print("z =", z)
            for y in range(len(hyper_cubes[0][0])):
                # print(''.join(cubes[z][y]))
                ans += hyper_cubes[w][z][y].count('#')

    return ans

if __name__ == "__main__":
    main()
