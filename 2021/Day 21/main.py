from functools import reduce
from sys import argv
from itertools import count, product

with open(argv[1] if len(argv) > 1 else "input") as f:
    p1 = int(f.readline().strip()[-1])
    p2 = int(f.readline().strip()[-1])

poss = [p1,p2]
scores = [0,0]

dice = count(1, 1)
roll_dice = lambda: (dice.__next__(),dice.__next__(),dice.__next__())

i = 0
turn = 0
while scores[0] < 1000 and scores[1] < 1000:
    pos = sum(roll_dice())
    poss[turn] = (poss[turn] + pos) % 10
    if poss[turn] == 0: poss[turn] = 10
    scores[turn] += poss[turn]

    turn = (turn + 1) % 2
    i += 3

print(f"Part 1: {i * min(scores)}")

scores = dict()
scores[(0,0)] = { (p1,p2): 1 }

turn = 0
j = 0

while True:
    stop = True
    new_scores = dict()
    for (a,b) in scores:
        if a < 21 and b < 21:
            stop = False
            for positions, universes in scores[(a,b)].items():
                for roll in [(r,rr,rrr) for r in range(1,4) for rr in range(1,4) for rrr in range(1,4)]:
                    i = sum(roll)
                    nn = (positions[turn] + i) % 10
                    if nn == 0: nn = 10
                    npos = (positions[0] if turn == 1 else nn, positions[1] if turn == 0 else nn)
                    nscore = (a + nn if turn == 0 else a, b + nn if turn == 1 else b)
                    x = new_scores.setdefault(nscore, dict()).get(npos, 0)

                    new_scores[nscore][npos] = x + universes
        else:
            for positions, universes in scores[(a,b)].items():
                x = new_scores.setdefault((a,b), dict()).get(positions, 0)
                new_scores[(a,b)][positions] = x + universes
    scores = new_scores

    if stop:
        break

    j += 1
    turn = (turn + 1) % 2

def add_score(acc, x):
    (a,b) = acc
    ((p1,p2), d) = x
    n = sum(d.values())
    return (a+n,b) if p1 > p2 else (a, b+n)

print(f"Part 2: {max(reduce(add_score, scores.items() ,(0,0)))}")