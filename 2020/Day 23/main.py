cups = dict()

with open("input") as f:
    line = [int(x) for x in f.readline().strip()]

for i in range(len(line)):
    cups[line[i]] = line[(i+1) % len(line)]

def play(cups : dict[int,int], moves, max_n):
    current_cup = line[0]

    for i in range(moves):
        c1 = cups[current_cup]
        c2 = cups[c1]
        c3 = cups[c2]

        next_cup = lambda x: x - 1 if x > 1 else max_n

        cups[current_cup] = cups[c3]
        cn = next_cup(current_cup)
        while cn in {c1,c2,c3}:
            cn = next_cup(cn)
        
        temp = cups[cn]
        cups[cn] = c1
        cups[c3] = temp

        current_cup = cups[current_cup]

cups1 = cups.copy()

play(cups1,100,9)

ans1 = ""
temp = cups1[1]
while temp != 1:
    ans1 += str(temp)
    temp = cups1[temp]

print("Part 1 =", ans1)

for i in range(10,1000000):
    cups[i] = i+1

cups[line[-1]] = 10
cups[1000000] = line[0]

play(cups,10000000,1000000)

ans2 = cups[1] * cups[cups[1]]

print("Part 2 =", ans2)