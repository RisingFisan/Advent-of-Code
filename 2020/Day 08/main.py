class Console:
    def __init__(self, instrs):
        self.acc = 0
        self.instructions = [inst.split() for inst in instrs]
        self.ip = 0 # Instruction pointer

    def run_inst(self):
        try:
            curInst = self.instructions[self.ip][0]
            parameter = int(self.instructions[self.ip][1])
        except IndexError:
            raise RuntimeError("Segmentation fault (core dumped)")

        if curInst == "acc":
            self.acc += parameter
            self.ip += 1
        elif curInst == "jmp":
            self.ip += parameter
        elif curInst == "nop":
            self.ip += 1
        else:
            raise RuntimeError("Unknown instruction")

        return self.ip == len(self.instructions)

    def run(self, n=1):
        i = 0
        prev_ips = {0}
        while not self.run_inst():
            if self.ip in prev_ips:
                i += 1
                if i == n:
                    return -1
                else: prev_ips = {self.ip}
            else: prev_ips.add(self.ip)
        return i

def main():
    with open("input") as f:
        instructions = f.readlines()

    console = Console(instructions)

    console.run()

    print("Part 1 =", console.acc)

    i = 0
    for i in range(len(instructions)):
        if "jmp" in instructions[i]:
            console = Console(instructions[:i] + ["nop " + ''.join(instructions[i].split()[1:])] + instructions[i+1:])
        elif "nop" in instructions[i]:
            console = Console(instructions[:i] + ["jmp " + ''.join(instructions[i].split()[1:])] + instructions[i+1:])
        if console.run() != -1:
            break
    
    print("Part 2 =", console.acc, "after changing instruction", i, "from", "nop to jmp" if "nop" in instructions[i] else "jmp to nop", instructions[i][4:])

if __name__ == "__main__":
    main()

