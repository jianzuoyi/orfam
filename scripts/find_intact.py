import sys

not_pseudo_ids = []
for line in open(sys.argv[2]):
    not_pseudo_ids.append(line.rstrip())

print("not pseudo ids %s" % len(not_pseudo_ids))
for line in open(sys.argv[1]):
    intact_id = line.rstrip()
    if intact_id in not_pseudo_ids:
        print(intact_id)
    
        
