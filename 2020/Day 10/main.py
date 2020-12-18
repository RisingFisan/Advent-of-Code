from functools import reduce
import queue

def main():
    with open("input") as f:
        lines = sorted(int(x) for x in f.readlines())

    diff = lambda x: abs(x[0] - x[1])

    ans1 = (lambda x: x[0] * x[1]) (reduce(lambda acc, x: (acc[0],acc[1] + 1) if diff(x) == 3 else ((acc[0] + 1,acc[1]) if diff(x) == 1 else acc), zip([0] + lines,lines),(0,1)))

    print("Part 1 =", ans1)

    d = dict()
    for i in [0]+lines:
        d[i] = set()
        for j in lines:
            if 0 < diff((i,j)) <= 3 and j > i:
                d[i].add(j)
            elif j > i + 3: break

    ans2 = calc_paths(0,d)

    print("Part 2 =", ans2)

cache = dict()

def calc_paths(point, d):
    if len(d[point]) == 0: return 1
    if point in cache: return cache[point]
    cache[point] = sum(calc_paths(x,d) for x in d[point])
    return cache[point]
    
if __name__ == "__main__":
    main()