# python3 make_a_converted_workload_sparse.py input_file density

# Imports
import sys
import random

input_file = sys.argv[1]
density = int(sys.argv[2])
output_file = input_file + "_sparse_" + str(density)

# list to store file lines
lines = []
# read file
with open(input_file, 'r') as fp:
    # read an store all lines into list
    lines = fp.readlines()

# Write file
with open(output_file, 'w') as fp:
    # iterate each line
    for number, line in enumerate(lines):
        # delete line 5 and 8. or pass any Nth line you want to remove
        # note list index starts from 0
        if (random.randint(0, 100) < density or number == 0):
            fp.write(line)
