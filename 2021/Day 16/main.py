from __future__ import annotations
from sys import argv
from math import prod

with open(argv[1] if len(argv) > 1 else "input") as f:
    binary = ''.join(bin(int(x, base=16))[2:].rjust(4, '0') for x in f.read().strip())

class Packet:
    def __init__(self, version, type) -> None:
        self.version = version
        self.type = type
        self.number = None
        self.children : list[Packet] = list()
    
    def add_child(self, child : Packet):
        self.children.append(child)

    def set_number(self, number):
        if self.type == 4:
            if self.number == None:
                self.number = number
            else:
                raise TypeError("Packet already has a number")
        else:
            raise TypeError(f"Packets of type {self.type} can't set a number manually")

    def get_number(self) -> int:
        match self.type:
            case 0: 
                self.number = sum(c.get_number() for c in self.children)
            case 1:
                self.number = prod(c.get_number() for c in self.children)
            case 2:
                self.number = min(c.get_number() for c in self.children)
            case 3:
                self.number = max(c.get_number() for c in self.children)
            case 5:
                self.number = int(self.children[0].get_number() > self.children[1].get_number())
            case 6:
                self.number = int(self.children[0].get_number() < self.children[1].get_number())
            case 7:
                self.number = int(self.children[0].get_number() == self.children[1].get_number())
        return self.number

    def __str__(self) -> str:
        header = f"Version: {self.version}; Type ID: {self.type}; "
        if self.type == 4:
            return header + f"Number: {self.number}"
        else:
            return header + "\nChildren:\n" + '\n'.join('\n'.join('\t' + c for c in str(child).splitlines()) for child in self.children)

packet : Packet = None

def read_packet(binary) -> tuple[Packet, str]:
    packet_version = int(binary[:3], base=2)
    packet_type = int(binary[3:6], base=2)
    binary = binary[6:]

    packet = Packet(packet_version, packet_type)

    if packet_type == 4:
        number = ""
        while True:
            b = binary[:5]
            binary = binary[5:]
            
            number += b[1:]
            if b[0] == '0':
                break
            
        packet.set_number(int(number, base=2))
    else:
        length_type = binary[0]
        binary = binary[1:]
        if length_type == '0': # length in bits
            length = int(binary[:15], base=2)
            binary = binary[15:]

            while length > 0:
                (sub_p, new_binary) = read_packet(binary)

                length -= len(binary) - len(new_binary)
                binary = new_binary

                packet.add_child(sub_p)
        elif length_type == '1': # length in packets
            length = int(binary[:11], base=2)
            binary = binary[11:]

            for _ in range(length):
                (sub_p, new_binary) = read_packet(binary)

                packet.add_child(sub_p)

                binary = new_binary

    return (packet, binary)

(packet, _) = read_packet(binary)

# for packet in packets:
#     print(packet)

def part1(packet : Packet):
    vn = packet.version
    for child in packet.children:
        vn += part1(child)
    return vn

print(f"Part 1: {part1(packet)}")
print(f"Part 2: {packet.get_number()}")