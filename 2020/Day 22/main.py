from collections import deque

def main():
    player1 = deque()
    player2 = deque()

    with open("input") as f:
        f.readline()
        while True:
            line = f.readline()
            if line == '\n': break
            player1.appendleft(int(line.strip()))
        f.readline()
        for line in f.readlines():
            player2.appendleft(int(line.strip()))

    print("Part 1 =", part1(player1.copy(),player2.copy()))
    print("Part 2 =", part2(player1,player2))

def part1(player1 : deque, player2 : deque):
    while len(player1) > 0 and len(player2) > 0:
        card1 = player1.pop()
        card2 = player2.pop()
        if card1 > card2:
            player1.appendleft(card1)
            player1.appendleft(card2)
        elif card2 > card1:
            player2.appendleft(card2)
            player2.appendleft(card1)

    winner = player1 if len(player2) == 0 else player2

    score = 0

    while len(winner) > 0:
        size = len(winner)
        score += size * winner.pop()

    return score

def part2(player1 : deque, player2 : deque):
    winner_n = recursive_combat(player1, player2)

    winner = player1 if winner_n == 1 else player2

    score = 0

    while len(winner) > 0:
        size = len(winner)
        score += size * winner.pop()

    return score

def recursive_combat(p1 : deque, p2 : deque):
    previous_rounds_1 = list()
    previous_rounds_2 = list()

    while len(p1) > 0 and len(p2) > 0:
        if p1 in previous_rounds_1 and p2 in previous_rounds_2:
            return 1
        previous_rounds_1.append(p1.copy())
        previous_rounds_2.append(p2.copy())

        card1 = p1.pop()
        card2 = p2.pop()

        winner_n = 0
        if len(p1) >= card1 and len(p2) >= card2:
            winner_n = recursive_combat(deque(p1[-i] for i in range(card1,0,-1)),deque(p2[-i] for i in range(card2,0,-1)))
        else:
            if card1 > card2:
                winner_n = 1
            elif card2 > card1:
                winner_n = 2
        if winner_n == 1:
            p1.appendleft(card1)
            p1.appendleft(card2)
        elif winner_n == 2:
            p2.appendleft(card2)
            p2.appendleft(card1)
    
    return 1 if len(p2) == 0 else 2

if __name__ == "__main__":
    main()