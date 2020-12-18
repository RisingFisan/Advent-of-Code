def main():
    with open("input") as f:
        lines = f.readlines()

    ans1 = part1(lines)
    
    print(ans1)

    ans2 = part2(lines)

    print(ans2)

def part1(lines):
    valid = 0

    for line in lines:
        (lims,letter,string) = line.split()
        (n,N) = [int(x) for x in lims.split("-",1)]
        letter = letter[0]
        count = len([x for x in string if x == letter])
        if n <= count <= N: valid += 1

    return valid

def part2(lines):
    valid = 0

    for line in lines:
        (lims,letter,string) = line.split()
        (n,N) = [int(x) for x in lims.split("-",1)]
        letter = letter[0]
        try: 
            if (string[n-1] == letter) != (string[N-1] == letter): valid += 1
        except IndexError: 
            continue

    return valid

if __name__ == "__main__":
    main()

