import re

rules = dict()
tickets = list()

with open("input") as f:
    while (line := f.readline()) != '\n': # Warning: only valid in Python 3.8+
        m : re.Match = re.match(r"([a-z\s]+): (\d+)-(\d+) or (\d+)-(\d+)",line)
        name, a, b, c, d = m.groups()
        rules[name] = {range(int(a),int(b)+1),range(int(c),int(d)+1)}

    f.readline()
    my_ticket = [int(x) for x in f.readline().strip().split(',')]

    f.readline()
    f.readline()
    for line in f.readlines():
        tickets.append([int(x) for x in line.strip().split(',')])

ans1 = 0

valid_tickets = list()

for ticket in tickets:
    valid = True
    for field in ticket:
        validField = False
        for rule1, rule2 in rules.values():
            if field in rule1 or field in rule2:
                validField = True
        if not validField:
            valid = False
            ans1 += field
    if valid:
       valid_tickets.append(ticket) 

print("Part 1 =", ans1)

rules_index = dict()
for rule in rules:
    rules_index[rule] = set()
    for i in range(len(my_ticket)):
        if all(any(ticket[i] in rnge for rnge in rules[rule]) for ticket in valid_tickets) and i not in rules_index.values():
            rules_index[rule].add(i)

seen = set()

while any(len(rule_index) > 1 for rule_index in rules_index.values()):
    for rule in rules_index:
        if len(rules_index[rule]) == 1 and rule not in seen:
            seen.add(rule)
            for rule_x in rules_index:
                if rule_x != rule: rules_index[rule_x].difference_update(rules_index[rule])

for rule in rules_index:
    rules_index[rule] = rules_index[rule].pop()

ans2 = 1

for rule in rules_index:
    if "departure" in rule:
        ans2 *= my_ticket[rules_index[rule]]

print("Part 2 =", ans2)