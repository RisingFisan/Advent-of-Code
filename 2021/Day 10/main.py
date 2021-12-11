from sys import argv
from statistics import median

with open(argv[1] if len(argv) > 1 else 'input') as f:
    lines = f.readlines()

score = 0
scoreboard = {
    ')': 3,
    ']': 57,
    '}': 1197,
    '>': 25137
}

score2 = dict()
scoreboard2 = {
    '(': 1,
    '[': 2,
    '{': 3,
    '<': 4
}

for i, line in enumerate(lines):
    stack = list()
    corrupted = False
    for char in line.strip():
        if char in "([{<":
            stack.append(char)
        elif char in ")]}>":
            prev = stack.pop()
            if prev + char not in ["()","<>","{}","[]"]:
                corrupted = True
                print(f"Line {i}: Expected {(lambda x: {'(': ')', '[': ']', '{': '}', '<': '>'}.get(x))(prev)}, but found {char} instead.")
                score += scoreboard[char]
    if not corrupted:
        score2[i] = 0
        while len(stack) > 0:
            char = stack.pop()
            score2[i] = (score2[i] * 5) + scoreboard2[char]

print(f"Part 1: {score}")
print(f"Part 2: {median(score2.values())}")