from itertools import chain

ingredients_list = list()
allergens_list = list()

with open("input") as f:
    for line in f.readlines():
        ing,alrg = line.split(" (contains ")
        ingredients_list.append(set(ing.split()))
        alrg_set = set(alrg.strip(" \n\r)").split(', '))
        allergens_list.append(alrg_set)

possible_allergens = dict()

for i, allergens in enumerate(allergens_list):
    for allergen in allergens:
        if allergen not in possible_allergens:
            possible_allergens[allergen] = ingredients_list[i].copy()
        else:
            possible_allergens[allergen].intersection_update(ingredients_list[i])

total_allergens = set(chain.from_iterable(possible_allergens.values()))

ans1 = 0

for ingredients in ingredients_list:
    ans1 += len(ingredients.difference(total_allergens))

print("Part 1 =", ans1)

while True:
    keep_going = False
    for allergen in possible_allergens:
        if len(possible_allergens[allergen]) == 1:
            for allergen2 in possible_allergens:
                if allergen != allergen2:
                    new_set = possible_allergens[allergen2].difference(possible_allergens[allergen])
                    if new_set != possible_allergens[allergen2]:
                        possible_allergens[allergen2] = new_set
                        keep_going = True
    if not keep_going:
        break

ans2 = ','.join(possible_allergens[x].pop() for x in sorted(possible_allergens.keys()))
print("Part 2 =", ans2)