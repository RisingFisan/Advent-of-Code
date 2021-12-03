from sys import argv
from statistics import mode

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = f.readlines()

gamma = ""
for i in range(len(lines[0].strip())):
    gamma += mode([ line[i] for line in lines ])

epsilon = ''.join([ '1' if x == '0' else '0' for x in gamma ])

gamma_num = int(gamma, base=2)
epsilon_num = int(epsilon, base=2)

print(f"Part 1: {gamma_num * epsilon_num}")

o_gen_rating = lines.copy()
i = 0
while len(o_gen_rating) != 1:
    ones = [ line[i] for line in o_gen_rating ].count('1')
    zeros = len(o_gen_rating) - ones
    if ones >= zeros:
        keep_bit = '1'
    else:
        keep_bit = '0'
    o_gen_rating = [ line for line in o_gen_rating if line[i] == keep_bit ]
    i += 1

co2_scrubber_rating = lines.copy()
i = 0
while len(co2_scrubber_rating) != 1:
    ones = [ line[i] for line in co2_scrubber_rating ].count('1')
    zeros = len(co2_scrubber_rating) - ones
    if ones < zeros:
        keep_bit = '1'
    else:
        keep_bit = '0'
    co2_scrubber_rating = [ line for line in co2_scrubber_rating if line[i] == keep_bit ]
    i += 1

o_gen_number = int(o_gen_rating[0], base=2)
co2_scrubber_number = int(co2_scrubber_rating[0], base=2)

print(f"Part 2: {o_gen_number * co2_scrubber_number}")