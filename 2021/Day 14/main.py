from sys import argv

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = f.readlines()

template = lines.pop(0).strip()
lines.pop(0)

rules = dict()
for line in lines:
    a, b = line.split(' -> ')
    rules[a] = b.strip()

ocurrences = dict()
for letter in template:
    n = ocurrences.get(letter,0)
    ocurrences[letter] = n + 1

pairs = dict()
for (a,b) in zip(template, template[1:]):
    n = pairs.get(a+b,0)
    pairs[a+b] = n + 1

for i in range(40):
    new_pairs = dict()
    for pair in pairs.copy():
        n = rules[pair]
        curx = pairs[pair]
        
        o = ocurrences.get(n,0)
        ocurrences[n] = o + curx

        x = new_pairs.get(pair[0] + n, 0)
        new_pairs[pair[0] + n] = x + curx
        x = new_pairs.get(n + pair[1], 0)
        new_pairs[n + pair[1]] = x + curx
    pairs = new_pairs
    
    if i == 9 or i == 39:
        ocrrs = sorted(ocurrences.values())
        print(f"Part {'1' if i == 10 else '2'}: {ocrrs[-1] - ocrrs[0]}")