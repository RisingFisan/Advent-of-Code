from sys import argv

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = f.readlines()

graph = dict()
part1 = list()
part2 = list()

for line in lines:
    a, b = line.strip().split('-')
    l = graph.setdefault(a, list())
    l.append(b)
    l = graph.setdefault(b, list())
    l.append(a)

def paths(path : list, visited : set):
    global part1, graph

    p = path[-1]
    if not p.isupper():
        visited.add(p)
    for x in graph[p]:
        if x == "end":
            part1.append(path + [x])
        elif x not in visited:
            paths(path + [x], visited.copy())
        

paths(["start"], set())

print(len(part1))

def paths2(path : list, visited : set, oneSmallCave : bool):
    global part2, graph

    p = path[-1]
    if not p.isupper():
        if p in visited:
            oneSmallCave = True
        visited.add(p)
    for x in graph[p]:
        if x == "end":
            part2.append(path + [x])
        elif x not in visited or (not oneSmallCave and x != "start"):
            paths2(path + [x], visited.copy(), oneSmallCave)

paths2(["start"], set(), False)

print(len(part2))
