import queue
import re

tiles = dict()

with open("input") as f:
    while (line_no := f.readline()) != "":
        tile = int(line_no.strip('\r\n :').split()[1])
        tiles[tile] = list()
        while (line := f.readline()) != "\n":
            tiles[tile].append(line.strip())

image = dict()
patterns = dict()

border = -1
top = 0
bottom = 1
left = 2
right = 3

get_top = lambda pattern: pattern[0]
get_bottom = lambda pattern: pattern[-1]
get_left = lambda pattern: [line[0] for line in pattern]
get_right = lambda pattern: [line[-1] for line in pattern]

flipped_h = lambda pattern: [line[::-1] for line in pattern]
flipped_v = lambda pattern: [pattern[-1-i] for i in range(len(pattern))]

def rotate(pattern,n):
    new_pattern = list()
    if n == 1:
        for i in range(len(pattern)):
            new_pattern.append(''.join([line[i] for line in pattern][::-1]))
    elif n == 2:
        for i in range(len(pattern)):
            new_pattern.append(pattern[-1-i][::-1])
    elif n == 3:
        for i in range(len(pattern)):
            new_pattern.append(''.join([line[-1-i] for line in pattern]))
    return new_pattern

for tile in tiles:
    image[tile] = [border for _ in range(4)]

x = list(tiles.keys())[0]
patterns[x] = tiles[x]
fixed_tiles = set()
q = queue.Queue()
q.put(x)

while not q.empty():
    x = q.get()
    pattern_x = patterns[x]
    fixed_tiles.add(x)
    matches = 0
    for tile in set(tiles.keys()).difference(fixed_tiles):
        states = list()
        if tile in patterns:
            states.append(patterns[tile])
        else:
            pattern = tiles[tile]
            for state in [pattern, flipped_h(pattern), flipped_v(pattern)]:
                for rotation in [state, rotate(state,1), rotate(state,2), rotate(state,3)]:
                    states.append(rotation)
        matched = False
        for state in states:
            if get_top(state) == get_bottom(pattern_x):
                image[x][bottom] = tile
                image[tile][top] = x
                matched = True

            elif get_bottom(state) == get_top(pattern_x):
                image[x][top] = tile
                image[tile][bottom] = x
                matched = True

            elif get_right(state) == get_left(pattern_x):
                image[x][left] = tile
                image[tile][right] = x
                matched = True

            elif get_left(state) == get_right(pattern_x):
                image[x][right] = tile
                image[tile][left] = x
                matched = True

            if matched:
                if tile not in patterns:
                    q.put(tile)
                    patterns[tile] = state
                break
        if matched:
            matches += 1
        if matches == 4:
            break

ans1 = 1
width = 0
height = 0

for tile in image:
    if image[tile].count(border) == 2:
        ans1 *= tile
    if image[tile][top] == border:
        width += 1
    if image[tile][left] == border:
        height += 1

print("Part 1 =", ans1)

final_image = [ [' ' for _ in range(8 * width)] for _ in range(8 * height)]

def fill(pattern, h_offset, v_offset):
    for i in range(8):
        for j in range(8):
            final_image[8 * v_offset + i][8 * h_offset + j] = pattern[i + 1][j + 1]

visited = set()

init = [x for x in image if image[x][top] == border and image[x][left] == border][0]
q = queue.Queue()
q.put((init,0,0))
visited.add(init)

while not q.empty():
    x = q.get()
    fill(patterns[x[0]],x[1],x[2])
    x_top = image[x[0]][top]
    x_bottom = image[x[0]][bottom]
    x_left = image[x[0]][left]
    x_right = image[x[0]][right]
    if x_top != border and x_top not in visited:
        q.put((x_top,x[1],x[2]-1))
        visited.add(x_top)
    if x_bottom != border and x_bottom not in visited:
        q.put((x_bottom,x[1],x[2]+1))
        visited.add(x_bottom)
    if x_left != border and x_left not in visited:
        q.put((x_left,x[1]-1,x[2]))
        visited.add(x_left)
    if x_right != border and x_right not in visited:
        q.put((x_right,x[1]+1,x[2]))
        visited.add(x_right)

ans2 = 0
max_monsters = 0

# print('\n'.join(''.join(line) for line in final_image))
# print(image)

for state in [final_image, flipped_h(final_image), flipped_v(final_image)]:
    for rotation in [state, rotate(state,1), rotate(state,2), rotate(state,3)]:
        monsters = 0
        for i in range(len(final_image) - 3):
            m2 = re.finditer(r"(?=#(.{4}##){3}#)",''.join(rotation[i+1]))
            while mx := next(m2,None):
                m3 = re.finditer(r"(?=(.#.){6})",''.join(rotation[i+2]))
                while my := next(m3,None):
                    if my != None and mx.start() == my.start() and rotation[i][mx.start() + 18] == '#':
                        monsters += 1
                        break

        if monsters > max_monsters:
            # print('\n'.join(''.join(line) for line in rotation))
            max_monsters = monsters
            ans2 = sum([line.count('#') for line in rotation]) - (15 * monsters)

print("Part 2 =", ans2)

            