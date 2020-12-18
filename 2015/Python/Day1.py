from functools import reduce
import time

def get_input():
    with open("Day1Input.txt") as file:
        char = file.read(1)
        while char:
            yield char
            char = file.read(1)

def main():
    floor = 0
    answer_part2 = 0
    for pos, inst in enumerate(get_input(),1):
        floor += 1 if inst == "(" else -1
        if floor == -1 and not answer_part2:
            answer_part2 = pos
    print(f"Answer to part 1: {floor}")
    print(f"Answer to part 2: {answer_part2}")

# Slightly slower version, uses a reduce method (aka foldl in haskell).
def main2():
    (floor, _, answer_part2) = reduce(lambda acc, inst: ((acc[0] + 1) if (inst == "(") else (acc[0] - 1), acc[1] + 1, acc[1] if acc[0] == -1 and not acc[2] else acc[2]), get_input(),(0,0,0))
    print(f"Answer to part 1: {floor}")
    print(f"Answer to part 2: {answer_part2}")

if __name__ == "__main__":
    main()