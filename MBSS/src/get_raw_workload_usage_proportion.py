# python3 src/get_raw_workload_usage_proportion.py converted_workload

import sys

f = sys.argv[1]

core_time_required = 0
core_time_required_workload_minus_2 = 0
core_time_required_workload_minus_1 = 0
core_time_required_workload_0 = 0
core_time_required_workload_1 = 0
core_time_required_workload_2 = 0
core_time_total = 486*20*3*24*60*60

first_time_day_0 = -1

with open(f) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24 = line.split()
				
		if (int(r19) == 0):
			first_time_day_0 = int(r5)
			break
	
		line = f.readline()
f.close

print("first_time_day_0:", first_time_day_0)

f = sys.argv[1]
with open(f) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24 = line.split()
				
		# ~ duration = float(r7)
		# ~ if (duration + t > 3*24*60*60):
			# ~ duration = 3*24*60*60 - t
						
		if (int(r19) == -2):
			core_time_required_workload_minus_2 += float(r11)*(max(1, float(r7) - first_time_day_0 - float(r23)) + float(r17)*0.1)
		if (int(r19) == -1):
			core_time_required_workload_minus_1 += float(r11)*(float(r7) + float(r17)*0.1)
		if (int(r19) == 0):
			core_time_required_workload_0 += float(r11)*(float(r7) + float(r17)*0.1)
		if (int(r19) == 1):
			core_time_required_workload_1 += float(r11)*(float(r7) + float(r17)*0.1)
		if (int(r19) == 2):
			core_time_required_workload_2 += float(r11)*(float(r7) + float(r17)*0.1)
			
		line = f.readline()
f.close

core_time_required = core_time_required_workload_minus_2 + core_time_required_workload_minus_1 + core_time_required_workload_0 + core_time_required_workload_1 + core_time_required_workload_2

print("core_time_required:", core_time_required, "core_time_total:", core_time_total, "core_time_required_workload_1:", core_time_required_workload_1)

print("Core time required is", (core_time_required*100)/core_time_total, "% of the total core time")
print("Core time required from jobs started before day 0 is", (core_time_required_workload_minus_2*100)/core_time_total + (core_time_required_workload_minus_1*100)/core_time_total, "% of the total core time")
print("Core time required from Day 0 is", (core_time_required_workload_0*100)/core_time_total, "% of the total core time")
print("Core time required from Day 1 is", (core_time_required_workload_1*100)/core_time_total, "% of the total core time")
print("Core time required from Day 2 is", (core_time_required_workload_2*100)/core_time_total, "% of the total core time")
