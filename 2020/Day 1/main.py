import itertools

# Note: Alt versions are slightly faster than the normal versions, but they use the itertools library

def part1(numbers : list[int]):
    for i in range(len(numbers)):
        for j in range(i,len(numbers)):
            if numbers[i] + numbers[j] == 2020:
                return numbers[i] * numbers[j]

def part2(numbers : list[int]):
    for i in range(len(numbers)):
        for j in range(i,len(numbers)):
            for k in range(j,len(numbers)):
                if numbers[i] + numbers[j] + numbers[k] == 2020:
                    return numbers[i] * numbers[j] * numbers[k]
            
def part1_alt(numbers : list[int]):
    for (i,j) in itertools.combinations(numbers, 2):
        if i + j == 2020:
            return i * j

def part2_alt(numbers : list[int]):
    for (i,j,k) in itertools.combinations(numbers, 3):
        if i + j + k == 2020:
            return i * j * k
            
def main():
    with open("input") as f:
        numbers = [int(x) for x in f.readlines()]

    ans1 = part1_alt(numbers)
    print(f"Answer to part 1 = {ans1}")

    ans2 = part2_alt(numbers)
    print(f"Answer to part 2 = {ans2}")

if __name__ == "__main__":
    main()