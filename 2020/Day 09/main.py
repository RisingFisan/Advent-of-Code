from itertools import combinations;

with open("input") as f:
    numbers = [int(x) for x in f.readlines()]

n = 25
while True:
    if numbers[n] not in [x+y for x,y in combinations(numbers[n-25:n], 2)]:
        ans1 = numbers[n]
        break
    n += 1

print("Part 1 =", ans1)

ans2 = 0

for r in range(2,len(numbers)):
    for i in range(r,len(numbers)):
        if numbers[i-r] > ans1: break
        if sum(numbers[i-r:i]) == ans1:
            ans2 = numbers[i-r] + numbers[i-1]
            break
    if ans2 != 0: break

print("Part 2 =", ans2)