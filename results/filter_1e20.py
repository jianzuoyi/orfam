import sys

for line in open(sys.argv[1]):
    cols = line.rstrip().split()
    e = float(cols[5])
    if e < float('1e-20'):
        start = float(cols[3])
        end = float(cols[4])
        aa = (end-start+1)/3
        if aa > 150:
            print(line.rstrip())
