import time

with open("input") as f:
    lines = f.readlines()

ids = set()

max_row = 127
max_column = 7
max_id = 0

for line in lines:
    row = int(line[:7].replace("F","0").replace("B","1"),2)
    column = int(line[7:].replace("L","0").replace("R","1"),2)
    id = row * 8 + column
    if id > max_id:
        max_id = id
    ids.add(id)

print("Part 1 =", max_id)

idX = None

for row in range(max_row + 1):
    for column in range(max_column + 1):
        id = row * 8 + column
        if id in ids:
            print("#",end='')
        else:
            if id - 1 in ids and id + 1 in ids:
                idX = id
                print('\033[92mX\033[0m',end='')
            else:
                print(".",end='')
    print("")
    time.sleep(0.1)

print("Part 2 =", idX)
