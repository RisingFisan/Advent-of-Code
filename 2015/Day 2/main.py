import re, itertools
from functools import reduce
from operator import mul

def part1(presents):
    total_area = 0
    for present in presents:
        areas = [a*b for a,b in itertools.permutations(present,2)]
        total_area += sum(areas) + min(areas)
    print(f"Answer to part 1: {total_area} square feet")

def part2(presents):
    total_length = 0
    for present in presents:
        perimeters = [2 * (a+b) for a,b in itertools.permutations(present,2)]
        volume = reduce(mul,present) # Similar to a foldl1 in haskell: foldl1 mul present = product present
        total_length += min(perimeters) + volume
    print(f"Answer to part 2: {total_length} feet")

if __name__ == "__main__":
    with open("Day2Input.txt") as file:
        presents = [[int(num) for num in re.findall("[0-9]+",line)] for line in file.readlines()]
    part1(presents)
    part2(presents)