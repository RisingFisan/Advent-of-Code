from math import prod

with open("input") as f:
    minutes = int(f.readline())
    bus_IDs = {int(x): num for num,x in enumerate(f.readline().strip().split(',')) if x != 'x'}

i = minutes
ans1 = None
while not ans1:
    for numID in bus_IDs:
        if i % numID == 0:
            ans1 = (i - minutes) * numID
            break
    i += 1

print("Part 1 =",ans1)

ans2 = inc = 1
for i in range(len(bus_IDs)):
    IDs = list(bus_IDs.keys())[:i+1]

    j = ans2
    tempAns = None
    tempAns2 = None
    while not tempAns2:
        x = j
        for numID in IDs:
            if (j + bus_IDs[numID]) % numID != 0:
                x = None
                break
        if x is not None:
            if tempAns is None:
                tempAns = x
            else:
                tempAns2 = x
                break
        j += inc
    ans2 = tempAns
    inc = tempAns2 - tempAns

print("Part 2 =", ans2)
