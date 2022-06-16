#include <main.h>
//~ #include <sys/stat.h>

struct Node* read_cluster(char* input_node_file)
{
	struct Node *list = NULL;
	
	FILE *f = fopen(input_node_file, "r");

	if (!f)
	{
		perror("fopen");
        exit(EXIT_FAILURE);
	}
    
    char s[100];
    char id[100];
    char memory[100];
    char bandwidth[100];
    char core[100];
    while (fscanf(f, "%s %s %s %s %s %s %s %s %s %s", s, s, id, s, memory, s, bandwidth, s, core, s) == 10)
	{
		struct Node *new = (struct Node*) malloc(sizeof(struct Node));
		new->unique_id = atoi(id);
		new->memory = atoi(memory);
		new->bandwidth = atof(bandwidth);
		new->n_available_cores = atoi(core);
		new->data = NULL;
		new->cores = NULL;
		new->next = NULL;
		
		if (list == NULL)
		{
			list = new;
		}
		else
		{
			struct Node *lastNode = list;
			while(lastNode->next != NULL)
			{
				lastNode = lastNode->next;
			}
			lastNode->next = new;
		}
	}
 	fclose(f);
	
	return list;
}

struct Job* read_workload(char* input_job_file, int constraint_on_sizes)
{
	struct Job *job_list = NULL;
	
	FILE *f = fopen(input_job_file, "r");
	if (!f)
	{
		perror("fopen");
        exit(EXIT_FAILURE);
	}
	
	int index_node = 0;
	char s[100];
    char id[100];
    char subtime[100];
    char delay[100];
    char walltime[100];
    char cores[100];
    char data[100];
    char data_size[100];
    char workload[100];
    char start_time_from_history[100];
    char start_node_from_history[100];
    
    while (fscanf(f, "%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s", s, s, id, s, subtime, s, delay, s, walltime, s, cores, s, s, s, data, s, data_size, s, workload, s, start_time_from_history, s, start_node_from_history, s) == 24)
	{
		struct Job *new = (struct Job*) malloc(sizeof(struct Job));
		new->unique_id = atoi(id);
		new->subtime = atoi(subtime);
		new->delay = atoi(delay);
		new->walltime = atoi(walltime);
		new->cores = atoi(cores);
		new->data = atoi(data);
		new->data_size = atof(data_size);
		new->workload = atoi(workload);
		new->start_time_from_history = atoi(start_time_from_history);
		new->node_from_history = atoi(start_node_from_history);
		
		/* Get index_node */
		if (constraint_on_sizes != 0)
		{
			if ((atof(data_size)*10)/(atoi(cores)*10) == 0.0)
			{
				index_node = 0;
			}
			else if ((atof(data_size)*10)/(atoi(cores)*10) == 6.4)
			{
				index_node = 0;
			}
			else if ((atof(data_size)*10)/(atoi(cores)*10) == 12.8)
			{
				index_node = 1;
			}
			else if ((atof(data_size)*10)/(atoi(cores)*10) == 51.2)
			{
				index_node = 2;
			}
			else
			{
				perror("data size");
				exit(EXIT_FAILURE);
			}
		}
		else
		{
			index_node = 0;
		}
		new->index_node_list = index_node;
		
		/* To get number of jobs to evaluate */
		if (atoi(workload) == 1)
		{
			//~ printf("HER\n");
			nb_job_to_evaluate += 1;
		}
		
		/* Add in job list */
		if (job_list == NULL)
		{
			job_list = new;
		}
		else
		{
			struct Job *lastNode = job_list;
			while(lastNode->next != NULL)
			{
				lastNode = lastNode->next;
			}
			lastNode->next = new;
		}
	}

	fclose(f);
	return job_list;
}

//~ def read_workload(input_job_file, constraint_on_sizes, write_all_jobs):
	
	//~ nb_job_to_evaluate = 0
	
	//~ job_list = []
	//~ job_list_to_start_from_history = []
	//~ # ~ job_list_0 = []
	//~ # ~ job_list_1 = []
	//~ # ~ job_list_2 = []
	
	//~ # ~ if (write_all_jobs == 3):
	//~ first_before_0 = False
	//~ first_day_0 = False
	//~ first_day_1 = False
	//~ first_day_2 = False
	//~ first_subtime_before_0 = 0
	//~ first_subtime_day_0 = 0
	//~ first_subtime_day_1 = 0
	//~ first_subtime_day_2 = 0
	
	//~ # ~ first_subtime_to_plot = 0
	//~ # ~ last_subtime_to_plot = 0
	
	//~ with open(input_job_file) as f:
		//~ line = f.readline()
		//~ while line:
			//~ r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24 = line.split() # split it by whitespace
			
			//~ # Getting index of node_list depending on size if constraint is enabled
			//~ if (constraint_on_sizes != 0):
				//~ if ((float(r17)*10)/(float(r11)*10) == 0.0):
					//~ index_node = 0
				//~ elif ((float(r17)*10)/(float(r11)*10) == 6.4):
					//~ index_node = 0
				//~ elif ((float(r17)*10)/(float(r11)*10) == 12.8):
					//~ index_node = 1
				//~ elif ((float(r17)*10)/(float(r11)*10) == 51.2):
					//~ index_node = 2
				//~ else:
					//~ print("Error", (float(r17)*10)/(float(r11)*10), "is a wrong input job data size. Line is:", line)
					//~ exit
			//~ else:
				//~ index_node = 0
			
			//~ # To get number of jobs to evaluate
			//~ if (int(r19) == 1):
				//~ nb_job_to_evaluate += 1
				
			//~ # ~ # To compute stats on cluster usage
			//~ # ~ if (write_all_jobs == 3 and (first_job_slice_to_evaluate == 0 or first_job_slice_to_evaluate == 1)):
				//~ # ~ if (int(r19) == -1 and first_job_slice_to_evaluate == 0):
					//~ # ~ first_job_slice_to_evaluate = 1
					//~ # ~ first_subtime_to_plot = int(r5)
				//~ # ~ elif (int(r19) == 1 and first_job_slice_to_evaluate == 1):
					//~ # ~ last_subtime_to_plot = int(r5)
				//~ # ~ elif (int(r19) == 2 and first_job_slice_to_evaluate == 1):
					//~ # ~ first_job_slice_to_evaluate = 2
			//~ # To compute stats on cluster usage
			//~ # ~ if write_all_jobs == 3:
			//~ if int(r19) == -1 and first_before_0 == False:
				//~ first_before_0 = True
				//~ first_subtime_before_0 = int(r5)
			//~ elif int(r19) == 0 and first_day_0 == False:
				//~ first_day_0 = True
				//~ first_subtime_day_0 = int(r5)
			//~ elif int(r19) == 1 and first_day_1 == False:
				//~ first_day_1 = True
				//~ first_subtime_day_1 = int(r5)
			//~ elif int(r19) == 2 and first_day_2 == False:
				//~ first_day_2 = True
				//~ first_subtime_day_2 = int(r5)
			
			//~ j = Job(int(r3), int(r5), int(r7), int(r9), int(r11), int(r15), float(r17), index_node, 0, 0, False, None, list(), 0, 0, int(r19), int(r21), int(r23))
			
			//~ # ~ if int(r19) == 0:
				//~ # ~ job_list_0.append(j)
			//~ # ~ elif int(r19) == 1:
				//~ # ~ job_list_1.append(j)
			//~ # ~ elif int(r19) == 2:
				//~ # ~ job_list_2.append(j)
			//~ # ~ else:
				//~ # ~ print("Error read")
				//~ # ~ exit(1)
			
			//~ if (int(r19) == -2):
				//~ job_list_to_start_from_history.append(j)
			//~ else:
				//~ job_list.append(j)
			
			//~ line = f.readline()	
			
		//~ f.close
	
	//~ if write_all_jobs == 3:
		//~ f = open("outputs/Start_end_evaluated_slice.txt", "w")
		//~ f.write("%d %d %d %d" %(first_subtime_before_0, first_subtime_day_0 - first_subtime_day_0, first_subtime_day_1 - first_subtime_day_0, first_subtime_day_2 - first_subtime_day_0))
		//~ f.close()
	
	//~ return job_list, nb_job_to_evaluate, first_subtime_day_0, job_list_to_start_from_history
	//~ # ~ return job_list, first_subtime_to_plot, nb_job_to_evaluate
	//~ # ~ return job_list_0, job_list_1, job_list_2, first_subtime_to_plot, nb_job_to_evaluate
