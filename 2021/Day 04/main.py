from sys import argv

with open(argv[1] if len(argv) > 1 else "input") as f:
    boards = f.read().split('\n\n')

numbers = [ int(x) for x in boards.pop(0).split(',') ]

class Board:
    def __init__(self, s : str) -> None:
        self.grid = [ [ False for _ in range(5) ] for _ in range(5) ]
        self.positions = dict()
        for i, line in enumerate(s.splitlines()):
            for j, n in enumerate(line.split()):
                self.positions[int(n)] = (i,j)

boards = [ Board(b) for b in boards ]

winning_boards = list()

part1 = 0
part2 = 0

for number in numbers:
    for board in boards:
        match board.positions.get(number):
            case (i,j): board.grid[i][j] = True
            case None: pass
        for i in range(5):
            if all( board.grid[i] ) or all( l[i] for l in board.grid ):
                if part1 == 0:
                    for n, (i,j) in board.positions.items():
                        if not board.grid[i][j]:
                            part1 += n
                    part1 *= number
                winning_boards.append(board)
                break
        
    if len(boards) == 1 and len(winning_boards) == 1:
        for n, (i,j) in board.positions.items():
            if not board.grid[i][j]:
                part2 += n
        part2 *= number

    for b in winning_boards:
        boards.remove(b)
    winning_boards = list()


print(f"Part 1: {part1}")
print(f"Part 2: {part2}")