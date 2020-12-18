import queue
from re import sub

fst = lambda x: x[0]
snd = lambda x: x[1]

def main():
    with open("input") as f:
        lines = f.readlines()

    rules : dict[str,list[tuple[str,int]]] = dict()

    for line in lines: 
        bag, bags = line.strip(" \n\r\t.").split(" bags contain ",1)
        rules[bag] = list()
        if "no other bags" not in bags:
            for containedBag in bags.split(", "):
                substrings = [x for x in containedBag.split() if "bag" not in x]
                rules[bag].append((' '.join(substrings[1:]),int(substrings[0])))

    ans1 = part1(rules)

    print("Part 1 =", ans1)

    ans2 = part2(rules)

    print("Part 2 =", ans2)

def part1(rules : dict[str,list[tuple[str,int]]]):
    total = 0

    for color in rules:
        if "shiny gold" in color: continue
        bagQueue = queue.Queue()
        for item in rules[color]: bagQueue.put(fst(item))
        while not bagQueue.empty():
            bag = bagQueue.get()
            if "shiny gold" in bag:
                total += 1
                break
            for subBag in rules[bag]:
                bagQueue.put(fst(subBag))

    return total
    

def part2(rules : dict[str,list[tuple[str,int]]]):
    bagQueue = queue.Queue()
    total = 0
    for subBag in rules["shiny gold"]: bagQueue.put(subBag)
    while not bagQueue.empty():
        curBag, curBagNum = bagQueue.get()
        total += curBagNum
        for subBag,subBagNum in rules[curBag]:
            bagQueue.put((subBag,curBagNum*subBagNum))

    return total


# Slower version of part 1, creates a dict of each bag's parents, i.e., which bags contain a specific bag. Since we only need to know which bags contain
# the "shiny gold" bag, this version is a bit "overkill", but if we needed to know which bags contain every other kind of bag, this would be the best version.

def part1_alt(rules : dict[str,list[tuple[str,int]]]):
    parents = dict()
    visited = set()

    for color in rules:
        if color in visited: continue
        visited.add(color)
        bagQueue = queue.Queue()
        for item,_ in rules[color]: 
            bagQueue.put(item)
            parents.setdefault(item,set()).add(color)
        while not bagQueue.empty():
            bag = bagQueue.get()
            visited.add(bag)
            for subBag,_ in rules[bag]:
                parents.setdefault(subBag,set()).add(bag)
                bagQueue.put(subBag)
    
    totalBags = set()

    bagQueue = queue.Queue()
    bagQueue.put("shiny gold")
    while not bagQueue.empty():
        bag = bagQueue.get()
        for parent in parents.get(bag,list()):
            totalBags.add(parent)
            bagQueue.put(parent)

    return len(totalBags)


if __name__ == "__main__":
    main()