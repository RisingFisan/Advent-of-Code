import re, time

with open("input") as f:
    lines = [re.findall("e|se|ne|w|nw|sw",line.strip()) for line in f.readlines()]


# My old coordinate system used 3 axes, like a cube, the new one uses doubled coordinates, and it's around 22% faster.
# moves = {"e":(1,-1,0),"se":(0,-1,1),"sw":(-1,0,1),"w":(-1,1,0),"nw":(0,1,-1),"ne":(1,0,-1)}
moves = {"e":(2,0),"se":(1,1),"sw":(-1,1),"w":(-2,0),"nw":(-1,-1),"ne":(1,-1)}
tiles = dict()

move = lambda x, y: (x[0]+y[0],x[1]+y[1])
neighbors = lambda x: set(move(x,moves[dir]) for dir in moves)

for line in lines:
    start = (0,0)
    for dir in line:
        start = move(start,moves[dir])
    curtile = tiles.get(start,"w")
    tiles[start] = "b" if curtile == "w" else "w"

print("Part 1 =",list(tiles.values()).count("b"))

start = time.time()

for i in range(100):
    for tile in tiles.copy():
        t_neighbors = neighbors(tile)
        if tiles[tile] == 'b' or [tiles.get(n,"w") for n in t_neighbors].count("b") > 0:
            for n in t_neighbors:
                if n not in tiles:
                    tiles[n] = "w"
    
    new_tiles = dict()

    for tile in tiles:
        t_neighbors = neighbors(tile)
        black_neighbors = [tiles.get(n,"w") for n in t_neighbors].count("b")
        if tiles[tile] == "b" and (black_neighbors == 0 or black_neighbors in range(3,7)):
            new_tiles[tile] = "w"
        elif tiles[tile] == "w" and black_neighbors == 2:
            new_tiles[tile] = "b"
        else:
            new_tiles[tile] = tiles[tile]
    tiles = new_tiles
    print("Day", i+1, "=", list(tiles.values()).count("b"))

end = time.time()

print("Part 2 =",list(tiles.values()).count("b"))
print(f"Time = {end-start}s")
