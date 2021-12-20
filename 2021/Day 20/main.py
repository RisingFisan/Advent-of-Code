from sys import argv

with open(argv[1] if len(argv) > 1 else "input") as f:
    algorithm = f.readline().strip()
    lines = f.readlines()[1:]

input_image = dict()

min_x = 0
min_y = 0

for y, line in enumerate(lines):
    for x, c in enumerate(line.strip()):
        input_image[(x,y)] = c
    max_x = x
max_y = y

output_image = dict()

for n in range(50):
    for y in range(min_y - 1, max_y + 2):
        for x in range(min_x - 1, max_x + 2):
            bits = ''.join(''.join(input_image.setdefault((i,j),'.' if n % 2 == 0 else algorithm[0]) for i in range(x-1, x+2)) for j in range(y-1,y+2))
            final_bit = algorithm[int(''.join('0' if b == '.' else '1' for b in bits), base=2)]
            output_image[(x,y)] = final_bit
    #         print(final_bit, end='')
    #     print('')
    # print("\n\n")

    min_x -= 1
    max_x += 1
    min_y -= 1
    max_y += 1
    input_image = output_image.copy()

    if n == 1:
        print(f"Part 1: {list(input_image.values()).count('#')}")

print(f"Part 2: {list(input_image.values()).count('#')}")