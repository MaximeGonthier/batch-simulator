# Compute and plot stat of a converted workload
# { id: 1 subtime: 0 delay: 388923 walltime: 388800 cores: 20 user: marvin data: 1 data_size: 128.000000 workload: -2 start_time_from_history: 3164092 start_node_from_history: 337 }

import sys
import pandas as pd
from matplotlib import pyplot as plt
import numpy as np
from matplotlib.lines import Line2D

FILENAME = sys.argv[1]

f_input = open(FILENAME, "r")

min_flow_no_transfers = 0
min_flow_all_transfers = 0
# ~ total_flow += head_to_print->job_end_time - head_to_print->job_subtime;
line = f_input.readline()
while line:
	# ~ print(line)
	r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24 = line.split()
		
	# subtime + delay - subtime
	min_flow_no_transfers += int(str(5)) + int(str(7)) - int(str(5))
	# subtime + delay + transfer time - subtime
	min_flow_all_transfers += int(str(5)) + int(str(7)) + float(str(17))/0.1 - int(str(5))

	line = f_input.readline()

print("min_flow_no_transfers:", min_flow_no_transfers, "min_flow_all_transfers:", min_flow_all_transfers)
