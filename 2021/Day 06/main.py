from sys import argv

with open(argv[1] if len(argv) > 1 else "input") as f:
    numbers = [int(x) for x in f.read().split(',')]

# for day in range(80):
#     for i in range(len(numbers)):
#         if numbers[i] == 0:
#             numbers.append(8)
#             numbers[i] = 6
#         else:
#             numbers[i] -= 1

numbers1 = [n-80 for n in numbers]
part1 = 0

while True:
    changes = False
    try:
        n = numbers1.pop(0)
        if n < 0:
            new_n = n % 7
            offset = 6 - new_n
            for j in range(abs(n // 7)):
                numbers1.append(8 - offset - 7 * j)
        part1 += 1
    except IndexError:
        break

print(f"Part 1: {part1}")

# for day in range(256 - 80):
#     print(80+day)
#     for i in range(len(numbers)):
#         if numbers[i] == 0:
#             numbers.append(8)
#             numbers[i] = 6
#         else:
#             numbers[i] -= 1

# print(f"Part 2: {len(numbers)}")

numbers2 = [n-256 for n in numbers]
part2 = 0

while True:
    changes = False
    try:
        n = numbers2.pop(0)
        if n < 0:
            new_n = n % 7
            offset = 6 - new_n
            for j in range(abs(n // 7)):
                numbers2.append(8 - offset - 7 * j)
        part2 += 1
    except IndexError:
        break

print(f"Part 2: {len(numbers)}")