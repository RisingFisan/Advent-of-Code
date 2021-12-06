from sys import argv

with open(argv[1] if len(argv) > 1 else "input") as f:
    numbers = [int(x) for x in f.read().split(',')]

states = {
    0: 0,
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0
}

for n in numbers:
    states[n] += 1

for i in range(80):
    tmp = states[0]
    for i in range(8):
        states[i] = states[i+1]
    states[6] += + tmp
    states[8] = tmp

print(f"Part 1: {sum(states.values())}")

for i in range(256 - 80):
    tmp = states[0]
    for i in range(8):
        states[i] = states[i+1]
    states[6] += + tmp
    states[8] = tmp

print(f"Part 2: {sum(states.values())}")
    