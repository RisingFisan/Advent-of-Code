from sys import argv

with open(argv[1] if len(argv) > 1 else "input.txt") as f:
    matrix = [ [ int(x) for x in line.strip()] for line in f.readlines() ]

height = len(matrix)
width = len(matrix[0])

visible = (height + width - 2) * 2
max_visibility = 0

for j in range(1, height - 1):
    for i in range(1, width - 1):
        e = matrix[j][i]

        visible_dirs = False
        visibility = 1

        for dir in [
          matrix[j][i-1::-1], # left
          matrix[j][i+1:],  # right
          map(lambda row: row[i], matrix[j-1::-1]), # top
          map(lambda row: row[i], matrix[j+1:])]: # bottom
            visibility_dir = 0
            visible_dir = True

            for a in dir:
                visibility_dir += 1
                if a >= e:
                    visible_dir = False
                    break

            visible_dirs = visible_dirs or visible_dir
            visibility *= visibility_dir
                
        if visible_dirs: visible += 1

        max_visibility = max(max_visibility, visibility)

print(f"Part 1: {visible}")
print(f"Part 2: {max_visibility}")