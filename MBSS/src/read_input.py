# ~ from dataclasses import dataclass


# ~ @dataclass
# ~ class Job:
    # ~ id: int

# ~ print(p)  # Point(x=1.5, y=2.5, z=0.0)
def main(input_file, job_list):
	
	with open(input_file) as f:
		line = f.readline()
		while line:
			line = f.readline()
			print(line)
        
	job = Job(1)
	job_list.append(job)
	job = Job(2)
	job_list.append(job)
	return job_list
