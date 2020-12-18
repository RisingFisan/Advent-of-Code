import re

with open("input") as f:
    lines = [x.strip() for x in f.readlines()]

def solve(eq,part2):
    operations = eq.split()
    while len(operations) > 1:
        if part2 and '+' in operations:
            plus_i = operations.index('+')
            operations = operations[:plus_i - 1] + [str(eval(''.join(operations[plus_i-1:plus_i+2])))] + operations[plus_i+2:]  
        else:
            operations = [str(eval(''.join(operations[:3])))] + operations[3:] 
    return operations[0]

def solver(lines, part2):
    total = 0
    for line in lines:
        new_line = line
        # print(new_line)
        while len(matches := re.split(r"\(([\d\s\+\*]+)\)",new_line)) > 1:
            new_line = ''.join((solve(x,part2) if x[0].isdigit() and x[-1].isdigit() else x) for x in matches if len(x) > 0)
            # print(new_line)
        total += int(solve(new_line,part2))
    return total

print("Part 1 =", solver(lines,False))
print("Part 2 =", solver(lines,True))