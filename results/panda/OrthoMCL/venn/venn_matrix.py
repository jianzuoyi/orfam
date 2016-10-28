import sys

print("panda polar_bear dog mouse")
for line in open("insect_groups.txt"):
    cols = line.strip().split()
    ail = 0
    urs = 0
    mus = 0
    dog = 0
    for i in range(1, len(cols)):
        if cols[i][0:3] == 'ail':
            ail += 1
        elif cols[i][0:3] == 'urs':
            urs += 1
        elif cols[i][0:3] == 'dog':
            dog += 1
        elif cols[i][0:3] == 'mus':
            mus += 1
        
    print(str(ail) + " " + str(urs) + " " + str(dog) + " " + str(mus))
