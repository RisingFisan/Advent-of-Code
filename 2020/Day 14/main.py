from itertools import product

with open("input") as f:
    lines = [line.strip().split(' = ') for line in f.readlines()]

def main():
    print("Part 1 =", decode(lines,part1=True))
    print("Part 2 =", decode(lines,part1=False))

def decode(lines, part1 : bool):
    mem = dict()
    mask = '0' * 36

    for instr,value in lines:
        if "mask" in instr:
            mask = value
        else:
            if part1:
                exec(f"{instr} = {int(''.join([(x if mask[i] == 'X' else mask[i]) for i,x in enumerate(format(int(value),'036b'))]),2)}")
            else:
                addr = [(x if mask[i] == '0' else mask[i]) for i,x in enumerate(format(int(''.join(x for x in instr if x.isdigit())),"036b"))]
                addrs = list()
                # n_x = addr.count("X")
                # for pr in product(range(2),repeat=n_x):
                #     new_addr = ''
                #     i = 0
                #     for bit in addr:
                #         if bit == 'X':
                #             new_addr += str(pr[i])
                #             i += 1
                #         else:
                #             new_addr += bit
                #     addrs.add(new_addr)
                addrs.append(list())
                for bit in addr:
                    if bit == 'X':
                        for addr_x in addrs.copy():
                            addrs.remove(addr_x)
                            addrs.append(addr_x + ['0'])
                            addrs.append(addr_x + ['1'])
                    else:
                        for addr_x in addrs:
                            addr_x.append(bit)
                for n_addr in addrs:
                    mem[int(''.join(n_addr),2)] = int(value)

    return sum(mem.values())

if __name__ == "__main__":
    main()