from sys import argv
from functools import reduce
from itertools import combinations
from copy import deepcopy

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = [l.strip() for l in f.readlines()]

class State():
    def __init__(self, vars : dict[str, int] = None, model_number : list[int] = None):
        if vars is None:
            self.vars = {'w': 0, 'x': 0, 'y': 0, 'z': 0}
        else:
            self.vars = vars.copy()
        
        if model_number is None:
            self.model_number = list()
        else:
            self.model_number = model_number.copy()

    def add(self, a : str, b : str):
        self.vars[a] = self.vars[a] + (int(b) if b.lstrip('-').isdigit() else self.vars[b])
        return True

    def mul(self, a : str, b : str):
        self.vars[a] = self.vars[a] * (int(b) if b.lstrip('-').isdigit() else self.vars[b])
        return True

    def div(self, a : str, b : str):
        if b == '0':
            return False
        self.vars[a] = self.vars[a] // (int(b) if b.lstrip('-').isdigit() else self.vars[b])
        return True

    def mod(self, a : str, b : str):
        if '-' in a or '-' in b or b == '0':
            return False
        self.vars[a] = self.vars[a] % (int(b) if b.lstrip('-').isdigit() else self.vars[b])
        return True

    def eql(self, a : str, b : str):
        self.vars[a] = int(self.vars[a] == (int(b) if b.lstrip('-').isdigit() else self.vars[b]))
        return True

    def __hash__(self) -> int:
        if len(self.model_number) == 0:
            return 0
        return int(''.join(str(x) for x in self.model_number))

    def __eq__(self, other : object) -> bool:
        if type(other) != type(self): return False
        return self.vars.items() == other.vars.items()


states : set[State] = set()
states.add(State())

for line in lines:
    print(line)
    match line.split():
        case "inp", x:
            new_states = set()
            for state in states:
                for i in range(1,10):
                    new_state = deepcopy(state)
                    new_state.vars[x] = i
                    new_state.model_number.append(i)
                    new_states.add(new_state)
            states = new_states
        case "add", a, b:
            for state in states:
                state.add(a, b)
        case "mul", a, b:
            for state in states:
                state.mul(a, b)
        case "div", a, b:
            invalid_states = set()
            for state in states:
                if not state.div(a, b):
                    invalid_states.add(state)
            states.difference_update(invalid_states)
        case "mod", a, b:
            invalid_states = set()
            for state in states:
                if not state.mod(a, b):
                    invalid_states.add(state)
            states.difference_update(invalid_states)
        case "eql", a, b:
            for state in states:
                state.eql(a, b)

part1 = list()

for state in states:
    if state.vars['z'] == 0:
        part1.append(state.model_number)

print(part1)