from sys import argv

with open(argv[1] if len(argv) > 1 else "input") as f:
    lines = f.readlines()

part1 = 0
part2 = 0

for inpt, outpt in (x.strip().split(' | ') for x in lines):
    digits = [None for _ in range(10)]
    signals = [frozenset(x) for x in inpt.split()]

    # 0 1 2 3 4 5 6 7 8 9
    for signal in signals:
        match len(signal):
            case 2: digits[1] = signal
            case 3: digits[7] = signal
            case 4: digits[4] = signal
            case 7: digits[8] = signal

    signals.remove(digits[1])
    signals.remove(digits[7])
    signals.remove(digits[4])
    signals.remove(digits[8])

    # 0 2 3 5 6 9
    for signal in signals:
        if len(signal) == 5 and signal.intersection(digits[1]) == digits[1]:
            digits[3] = signal
        elif len(signal) == 6 and signal.intersection(digits[4]) == digits[4]:
            digits[9] = signal
        elif signal.union(digits[1]) == digits[8]:
            digits[6] = signal
        elif signal.intersection(digits[7]) == digits[7]:
            digits[0] = signal

    signals.remove(digits[9])
    signals.remove(digits[3])
    signals.remove(digits[6])
    signals.remove(digits[0])

    # 2 5
    for signal in signals:
        if signal.intersection(digits[9]) == signal:
            digits[5] = signal
        else:
            digits[2] = signal

    results = {letters: i for (i,letters) in enumerate(digits)}

    value = [results[frozenset(digit)] for digit in outpt.split()]
    part1 += len([x for x in value if x in [1,4,7,8]])
    part2 += int(''.join(str(x) for x in value))


print(f"Part 1: {part1}")
print(f"Part 2: {part2}")
