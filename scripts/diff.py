import sys

ids = []
for line in open(sys.argv[1]):
    ids.append(line.rstrip())

for line in open(sys.argv[2]):
    name = line.rstrip()
    if name not in ids:
        print(name)
