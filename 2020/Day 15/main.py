import time

with open("input") as f:
    numbers = [int(x) for x in f.readline().strip().split(',')]

# spoken = dict()
spoken = [-1 for _ in range(30000001)]

for i,number in enumerate(numbers[:-1]):
    spoken[number] = i

last_spoken = numbers[-1]

i = len(numbers)
while i < 2020:
    temp = last_spoken
    # if last_spoken in spoken:
    if spoken[last_spoken] != -1:
        last_spoken = i - 1 - spoken[last_spoken]
    else:
        last_spoken = 0
    spoken[temp] = i - 1
    i += 1

print("Part 1 =", last_spoken)

start = time.time()
while i < 30000000:
    temp = last_spoken
    # if last_spoken in spoken:
    if spoken[last_spoken] != -1:
        last_spoken = i - 1 - spoken[last_spoken]
    else:
        last_spoken = 0
    spoken[temp] = i - 1
    i += 1
end = time.time()
print("Part 2 =", last_spoken, f"\tTime = {end-start}s")
