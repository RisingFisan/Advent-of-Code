import re

def main():
    with open("input") as f:
        entries = f.read().split('\n\n')

    passports = list()

    for entry in entries:
        passport = dict()
        for field in entry.split():
            key, value = field.split(':')
            passport[key] = value
        passports.append(passport)

    valid_passports = part1(passports)

    print(f"Part 1 = {len(valid_passports)}")

    valid_passports_values = part2_alt(valid_passports)

    print(f"Part 2 = {len(valid_passports_values)}")

def part1(passports : list[dict[str,str]]):
    valid = list()
    fields = {'byr','iyr','eyr','hgt','hcl','ecl','pid'}
    for passport in passports:
        if len(fields.intersection(passport)) == len(fields):
            valid.append(passport)
    return valid

def part2(passports : list[dict[str,str]]):
    valid = list()
    for passport in passports:
        if not "1920" <= passport.get('byr') <= "2002": continue
        if not "2010" <= passport.get('iyr') <= "2020": continue
        if not "2020" <= passport.get('eyr') <= "2030": continue
        height = passport.get('hgt')
        if      (not height.endswith("cm") or not "150" <= height[:3] <= "193")\
            and (not height.endswith("in") or not  "59" <= height[:2] <= "76"): continue

        hair_color = passport.get('hcl')
        if hair_color[0] != "#" or not all(x in "0123456789abcdef" for x in hair_color[1:].lower()): continue

        if passport.get('ecl') not in {"amb","blu","brn","gry","grn","hzl","oth"}: continue

        pid = passport.get('pid')
        if not pid.isdigit() or len(pid) != 9: continue

        valid.append(passport)
    return valid

def part2_alt(passports : list[dict[str,str]]):
    valid = list()
    for passport in passports:
        if not re.fullmatch("19[2-9]\d|200[0-2]",passport.get('byr')): continue
        if not re.fullmatch("201\d|2020",passport.get('iyr')): continue
        if not re.fullmatch("202\d|2030",passport.get('eyr')): continue
        if not re.fullmatch("(1[5-8]\d|19[0-3])cm|(59|6\d|7[0-6])in",passport.get('hgt')): continue
        if not re.fullmatch("#[0-9a-f]{6}",passport.get('hcl')): continue
        if not re.fullmatch("(amb|blu|brn|gry|grn|hzl|oth)",passport.get('ecl')): continue
        if not re.fullmatch("\d{9}",passport.get('pid')): continue

        valid.append(passport)
    return valid

if __name__ == "__main__":
    main()