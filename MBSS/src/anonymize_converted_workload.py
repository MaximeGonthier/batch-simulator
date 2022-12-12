# Anonymize a converted workload by modifying the names of the users
# python3 src/anonymize_converted_workload.py converted_workload

# Imports
import sys
# ~ from math import *
import random
import string
# ~ import operator
# ~ from dataclasses import dataclass

def get_random_string(length):
    # choose from all lowercase letter
    letters = string.ascii_lowercase
    result_str = ''.join(random.choice(letters) for i in range(length))
    # ~ print("Random string of length", length, "is:", result_str)
    return result_str
    
f_input = sys.argv[1]
f_output = open(f_input + "_anonymous", "w")

# ~ current_user = 0
random_string_list = []

with open(f_input) as f_input:
	line = f_input.readline()
	last_user = ""
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24 = line.split()
		
		if (r13 != last_user):
			anonymous_string = get_random_string(8)
			while(anonymous_string in random_string_list):
				print(anonymous_string)
				anonymous_string = get_random_string(8)
				print("same string, re-roll")
			random_string_list.append(anonymous_string)
			last_user = r13
				
		f_output.write("{ id: %d subtime: %d delay: %d walltime: %d cores: %d user: %s data: %d data_size: %f workload: %d start_time_from_history: %d start_node_from_history: %d }\n" % ( int(r3), int(r5), int(r7), int(r9), int(r11), anonymous_string, int(r15), float(r17), int(r19), int(r21), int(r23) ) )
		line = f_input.readline()

f_input.close()
f_output.close()
