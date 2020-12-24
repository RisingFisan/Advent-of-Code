rules = dict()

with open("input") as f:
    while (line := f.readline()) != "\n":
        rule_num, nums = line.strip().split(': ')
        if not nums.strip('"').isalpha():
            rules[int(rule_num)] = list()
            for match in nums.split(' | '):
                values = [int(x) for x in match.split()]
                rules[int(rule_num)].append(values)
        else:
            rules[int(rule_num)] = nums.strip('"')
    lines = [x.strip() for x in f.readlines()]

def obeys(msg, rule):
    matches = rules[rule]

    if isinstance(matches,str):
        if len(msg) > 0 and msg[0] == matches:
            return {msg[1:]}
        else: return set()

    msgs = set()

    for match in matches:
        xs = {msg}
        for value in match:
            new_xs = set()
            for x in xs:
                response = obeys(x, value)         
                if len(response) > 0:
                    new_xs.update(response)
            xs = new_xs
        if len(xs) > 0:
            msgs.update(xs)
    return msgs

ans1 = 0
for line in lines:
    r = obeys(line,0)
    if r == {""}:
        ans1 += 1

print("Part 1 =", ans1)

rules[8] = [[42],[42,8]]
rules[11] = [[42,31],[42,11,31]]

ans2 = 0
for line in lines:
    r = obeys(line,0)
    if "" in r:
        ans2 += 1

print("Part 2 =", ans2)