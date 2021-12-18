from __future__ import annotations
from sys import argv
from itertools import permutations


with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = [x.strip() for x in f.readlines()]

number = "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]"

class Pair():
    def __init__(self, left, right) -> None:
        self.left : int | Pair = left
        self.right : int | Pair = right

    def __str__(self) -> str:
        return f"[{self.left},{self.right}]"

    @classmethod
    def fromString(cls, s : str) -> int | Pair:
        if s.isdigit():
            return int(s)
        s = s[1:-1]
        l = ""
        bracket_level = 0
        while True:
            c = s[0]
            s = s[1:]
            match c:
                case ',':
                    if bracket_level == 0:
                        break
                case '[': bracket_level += 1
                case ']': bracket_level -= 1
                case _: pass
            l += c
        return cls(Pair.fromString(l), Pair.fromString(s))

    @classmethod
    def add_pairs(cls, p1 : Pair, p2 : Pair):
        return cls(p1, p2)

    def explode(self):
        res = self.__explode_aux(0)
        return res is not None

    def __explode_aux(self, i):
        if i == 4:
            return (self.left, self.right)

        if type(self.left) == int:
            resL = None
        else:
            resL = self.left.__explode_aux(i+1)

        if resL is None:
            if type(self.right) == int:
                resR = None
            else:
                resR = self.right.__explode_aux(i+1)

            if resR is None:
                return None
            else:
                (l,r) = resR
                if l is not None:
                    if r is not None:
                        self.right = 0
                    if type(self.left) == int:
                        self.left += l
                    else:
                        self.left.add(l, False)
                    return (None,r)
                return (l,r)
        else:
            (l,r) = resL
            if r is not None:
                if l is not None:
                    self.left = 0
                if type(self.right) == int:
                    self.right += r
                else:
                    self.right.add(r, True)
                return (l,None)
            return (l,r)
    
    def add(self, n : int, to_left : bool):
        if to_left:
            if type(self.left) == int:
                self.left += n
            else:
                self.left.add(n, to_left)
        else:
            if type(self.right) == int:
                self.right += n
            else:
                self.right.add(n, to_left)

    def split(self):
        if type(self.left) == int:
            if self.left >= 10:
                n = self.left // 2
                self.left = Pair(n, self.left - n)
                return True
            else:
                sl = False
        else:
            sl = self.left.split()

        if sl:
            return sl

        if type(self.right) == int:
            if self.right >= 10:
                n = self.right // 2
                self.right = Pair(n, self.right - n)
                return True
            else:
                sr = False
        else:
            sr = self.right.split()

        return sr

    def reduce(self):
        while True:
            # print(self)
            exploded = self.explode()
            if exploded:
                # print("AFTER EXPLODE:\t", end='')
                continue
            split = self.split()
            if not split:
                break
            # else:
                # print("AFTER SPLIT:\t", end='')

    def magnitude(self):
        if type(self.left) == int:
            ml = self.left
        else:
            ml = self.left.magnitude()
        
        if type(self.right) == int:
            mr = self.right
        else:
            mr = self.right.magnitude()

        return 3 * ml + 2 * mr
        
        
x = Pair.fromString(lines[0])

for line in lines[1:]:
    x = Pair.add_pairs(x, Pair.fromString(line))
    x.reduce()

print(x)
print(f"Part 1: {x.magnitude()}")

part2 = 0

for l1, l2 in permutations(lines, 2):
    p1 = Pair.fromString(l1)
    p2 = Pair.fromString(l2)
    p = Pair.add_pairs(p1, p2)
    p.reduce()
    n = p.magnitude()
    if n > part2:
        part2 = n
        

print(f"Part 2: {part2}")