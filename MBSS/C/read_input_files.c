#include <main.h>

void read_cluster(char* input_node_file)
{
	node_list = malloc(3*sizeof(*node_list));
	for (int i = 0; i < 3; i++)
	{
		node_list[i] = malloc(sizeof(*node_list));
		node_list[i]->head = NULL;
		node_list[i]->tail = NULL;
	}
	total_number_nodes = 0;
	
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
		if (new->memory == 128)
		{
			insert_tail_node_list(node_list[0], new);
		}
		else if (new->memory == 256)
		{
			insert_tail_node_list(node_list[1], new);
		}
		else if (new->memory == 1024)
		{
			insert_tail_node_list(node_list[2], new);
		}
		else
		{
			printf("Error cluster\n");
			exit(EXIT_FAILURE);
		}
		total_number_nodes += 1;
	}
 	fclose(f);
}

//~ struct Job* read_workload(char* input_job_file, int constraint_on_sizes)
void read_workload(char* input_job_file, int constraint_on_sizes)
{
	job_list = malloc(sizeof(*job_list));
	job_list->head = NULL;
	job_list->tail = NULL;
	job_list_to_start_from_history = malloc(sizeof(*job_list_to_start_from_history));
	job_list_to_start_from_history->head = NULL;
	job_list_to_start_from_history->tail = NULL;
	scheduled_job_list = malloc(sizeof(*scheduled_job_list));
	scheduled_job_list->head = NULL;
	scheduled_job_list->tail = NULL;
	
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
		
		new->start_time = 0; 
		new->end_time = 0; 
		new->end_before_walltime = false;
		new->node_used = NULL;
		new->cores_used= NULL;
		new->transfer_time = 0;
		new->waiting_for_a_load_time = 0;
		new->next = NULL;
		
		/* Add in job list or job to start from history */
		if (new->workload != -2)
		{
			insert_tail_job_list(job_list, new);
		}
		else
		{
			if (job_list_to_start_from_history->head == NULL)
			{
				job_list_to_start_from_history->head = new;
				job_list_to_start_from_history->tail = new;
			}
			else
			{
				/* Want to insert it so the start time are sorted. */
				struct Job *temp = job_list_to_start_from_history->head;
				/* Is it our new head ? */
				if(temp->start_time_from_history > new->start_time_from_history)
				{
					new->next = job_list_to_start_from_history->head;
					job_list_to_start_from_history->head = new;
				}
				else
				{
					while(temp != NULL)
					{
						if(temp->next->start_time_from_history > new->start_time_from_history)
						{
							new->next = temp->next;
							temp->next = new;
							break;
						}
						temp = temp->next;
					}
				}
			}		
		}
	}
	fclose(f);
}

int get_nb_job_to_evaluate(struct Job* l)
{
	struct Job *j = l;
	int count = 0;
	while (j != NULL)
	{
		if (j->workload == 1)
		{
			count += 1;
		}
		j = j->next;
		//~ printf("here\n");
	}
	return count;
}

int get_first_time_day_0(struct Job* l)
{
	struct Job *j = l;
	while (j->workload != 0)
	{
		j = j->next;
	}
	return j->subtime;
}

void write_in_file_first_times_all_day(struct Job* l, int first_subtime_day_0)
{
	struct Job *j = l;
	bool first_before_0 = false;
	bool first_day_1 = false;
	bool first_day_2 = false;
	int first_subtime_before_0 = 0;
	int first_subtime_day_1 = 0;
	int first_subtime_day_2 = 0;
	
	while (j != NULL)
	{
		if (j->workload == -1 && first_before_0 == false)
		{
			first_before_0 = true;
			first_subtime_before_0 = j->subtime;
		}
		else if (j->workload == 1 && first_day_1 == false)
		{
			first_day_1 = true;
			first_subtime_day_1 = j->subtime - first_subtime_day_0;
		}
		else if (j->workload == 2 && first_day_2 == false)
		{
			first_day_2 = true;
			first_subtime_day_2 = j->subtime - first_subtime_day_0;
		}
		j = j->next;
	}
	
	FILE *f = fopen("../outputs/Start_end_evaluated_slice.txt", "w");
	if (!f)
	{
		perror("fopen");
        exit(EXIT_FAILURE);
	}
	fprintf(f, "%d %d %d %d", first_subtime_before_0, 0, first_subtime_day_1, first_subtime_day_2);
	fclose(f);
}
