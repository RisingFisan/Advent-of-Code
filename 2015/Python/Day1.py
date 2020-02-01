def get_input():
    with open("Day1Input.txt") as file:
        char = file.read(1)
        while char:
            yield char
            char = file.read(1)

def main():
    floor = 0
    answer_part2 = 0
    for pos, inst in enumerate(get_input(),1):
        floor += 1 if inst == "(" else -1
        if floor == -1 and not answer_part2:
            answer_part2 = pos
    print(f"Answer to part 1: {floor}")
    print(f"Answer to part 2: {answer_part2}")

if __name__ == "__main__":
    main()