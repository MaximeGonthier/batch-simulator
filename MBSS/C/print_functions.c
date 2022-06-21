#include <main.h>

void print_node_list(struct Node_List** list)
{
	for (int i = 0; i < 3; i++)
	{
		struct Node* n = list[i]->head;
		while (n != NULL)
		{
			printf("Id: %d Memory: %d Bandwidth: %f Available cores: %d\n", n->unique_id, n->memory, n->bandwidth, n->n_available_cores); fflush(stdout);
			n = n->next;
		}
	}
}

void print_data_intervals(struct Interval_List** list)
{
	printf("Intervals are:\n"); fflush(stdout);
	for (int i = 0; i < 3; i++)
	{
		struct Node* n = list[i]->head;
		while (n != NULL)
		{
			printf("Node %d:", n->unique_id); fflush(stdout);
			struct Data* d = n->data;
			while (d != NULL)
			{
				printf(" %d (", d->unique_id); fflush(stdout);
				struct Interval* i = d->intervals;
				while (i != NULL)
				{
					printf(" %d", i->time); fflush(stdout);
					i = i->next;
				}
				printf(" )"); fflush(stdout);
				d = d->next;
			}
			n = n->next;
			printf("\n"); fflush(stdout);
		}
	}
}

void print_single_node(struct Node* n)
{
	printf("Id: %d Memory: %d Bandwidth: %f Available cores: %d\n", n->unique_id, n->memory, n->bandwidth, n->n_available_cores); fflush(stdout);
}

void print_job_list(struct Job* list)
{
	struct Job* j = list;
	while (j != NULL)
	{
		printf("Id: %d Subtime: %d Delay: %d Walltime: %d Cores: %d Data: %d Data_size: %f Data_category: %d Workload: %d Start_time_from_history: %d Node_from_history: %d\n", j->unique_id, j->subtime, j->delay, j->walltime, j->cores, j->data, j->data_size, j->index_node_list, j->workload, j->start_time_from_history, j->node_from_history); fflush(stdout);
		j = j->next;
	}
}

void print_time_list(struct Next_Time* list, int end_or_start)
{
	if (list == NULL)
	{
		return;
	}
	if (end_or_start == 1)
	{
		printf("Next ending times are:"); fflush(stdout);
	}
	else
	{
		printf("Next starting times are:"); fflush(stdout);
	}
	struct Next_Time* nt = list;
	while (nt != NULL)
	{
		printf(" %d", nt->time); fflush(stdout);
		nt = nt->next;
	}
	printf("\n"); fflush(stdout);
}

void print_decision_in_scheduler(struct Job* j)
{
	printf("Job %d using file %d category %d workload %d will be computed on node %d core(s) ", j->unique_id, j->data, j->index_node_list, j->workload, j->node_used->unique_id); fflush(stdout);
	for (int i = 0; i < j->cores - 1; i++)
	{
		printf("%d,", j->cores_used[i]); fflush(stdout);
	}
	printf("%d", j->cores_used[j->cores - 1]); fflush(stdout);
	printf(" start at time %d and is predicted to finish at time %d.\n", j->start_time, j->end_time); fflush(stdout);
}

void print_cores_in_specific_node(struct Node* n)
{
	printf("Cores in node %d are: ", n->unique_id); fflush(stdout);
	for (int i = 0; i < 19; i++)
	{
		printf("%d(%d),", n->cores[i]->unique_id, n->cores[i]->available_time); fflush(stdout);
	}
	printf("%d(%d).\n", n->cores[19]->unique_id, n->cores[19]->available_time); fflush(stdout);
}

/* Print in a csv file the results of this job allocation */
void to_print_job_csv(struct Job* job, int time)
{
	char* file_to_open;
	int time_used = job->end_time - job->start_time;
	
	/* Only evaluate jobs from workload 1 */
	if (job->workload == 1)
	{
		struct To_Print* new = (struct To_Print*) malloc(sizeof(struct To_Print));
		new->next = NULL;
		new->job_unique_id = job->unique_id;
		new->job_subtime = job->subtime;
		new->time = time;
		new->time_used = time_used;
		new->transfer_time = job->transfer_time;
		new->job_start_time = job->start_time;
		new->job_end_time = job->end_time;
		new->job_cores = job->cores;
		new->waiting_for_a_load_time = job->waiting_for_a_load_time;
		new->empty_cluster_time = job->delay + (job->data_size)/0.1;
		new->data_type = job->index_node_list;
		insert_tail_to_print_list(jobs_to_print_list, new);
	}
	
	#ifdef PRINT_GANTT_CHART
	int i = 0;
	file_to_open = malloc(100*sizeof(char));
	strcpy(file_to_open, "outputs/Results_all_jobs_");
	strcat(file_to_open, scheduler);
	strcat(file_to_open, ".csv");
	FILE* f = fopen(file_to_open, "a");
	if (!f)
	{
		printf("Error opening file Results_all_jobs_scheduler.csv\n");
		exit(EXIT_FAILURE);
	}
	fprintf(f, "%d,%d,delay,%f,%d,%d,1,COMPLETED_SUCCESSFULLY,%d,%d,%d,%d,%d,%d,", job->unique_id, job->unique_id, 0.0, job->cores, job->walltime, job->start_time - first_subtime_day_0, time_used, job->end_time - first_subtime_day_0, job->start_time - first_subtime_day_0, job->end_time - first_subtime_day_0, 1);
	/* Printing the cores used. */
	if (job->cores > 1)
	{
		for (i = 0; i < job->cores; i++)
		{
			if (i == job->cores - 1)
			{
				fprintf(f, "%d", job->node_used->unique_id*20 + job->cores_used[i]);
			}
			else
			{
				fprintf(f, "%d ", job->node_used->unique_id*20 + job->cores_used[i]);
			}
		 }
	}
	else
	{
		fprintf(f, "%d", job->node_used->unique_id*20 + job->cores_used[0]);
	}
	fprintf(f, ",-1,\"\"\n");
	fclose(f);
	free(file_to_open);
	#endif
	
	#ifdef PRINT_DISTRIBUTION_QUEUE_TIMES
	file_to_open = malloc(100*sizeof(char));
	strcpy(file_to_open, "outputs/Distribution_queue_times_");
	strcat(file_to_open, scheduler);
	strcat(file_to_open, ".txt");
	f = fopen(file_to_open, "a");
	if (!f)
	{
		perror("Error opening file.\n");
		exit(EXIT_FAILURE);
	}
	fprintf(f, "%d\n", job->start_time - job->subtime);
	fclose(f);
	free(file_to_open);
	#endif
}

/* Print in a file the final results. Only called once at the end of the simulation. */
void print_csv(struct To_Print* head_to_print)
{
	/* For distribution of flow and queue times on each job. */
	char* file_to_open = malloc(100*sizeof(char));
	strcpy(file_to_open, "outputs/Queue_times_");
	strcat(file_to_open, scheduler);
	strcat(file_to_open, ".txt");
	FILE* f_queue = fopen(file_to_open, "w");
	if (!f_queue)
	{
		perror("Error opening file.\n");
		exit(EXIT_FAILURE);
	}
	
	file_to_open = malloc(100*sizeof(char));
	strcpy(file_to_open, "outputs/Flow_times_");
	strcat(file_to_open, scheduler);
	strcat(file_to_open, ".txt");
	FILE* f_flow = fopen(file_to_open, "w");
	if (!f_flow)
	{
		perror("Error opening file.\n");
		exit(EXIT_FAILURE);
	}
		
	file_to_open = malloc(100*sizeof(char));
	strcpy(file_to_open, "outputs/Stretch_times_");
	strcat(file_to_open, scheduler);
	strcat(file_to_open, ".txt");
	FILE* f_stretch = fopen(file_to_open, "w");
	if (!f_stretch)
	{
		perror("Error opening file.\n");
		exit(EXIT_FAILURE);
	}
		
	/* Values evaluated. */
	float max_queue_time = 0;
	float mean_queue_time = 0;
	float total_queue_time = 0;
	float max_flow = 0;
	float mean_flow = 0;
	float total_flow = 0;
	float total_transfer_time = 0;
	float total_waiting_for_a_load_time = 0;
	float total_waiting_for_a_load_time_and_transfer_time = 0;
	float makespan = 0;
	float total_flow_stretch = 0;
	float total_flow_stretch_with_a_minimum = 0;
	float mean_flow_stretch = 0;
	float mean_flow_stretch_with_a_minimum = 0;
	float core_time_used = 0;
	
	
	while (head_to_print != NULL)
	{
		/* Flow stretch */
		total_flow_stretch += (head_to_print->job_end_time - head_to_print->job_subtime)/head_to_print->empty_cluster_time;
		
		if (head_to_print->job_end_time - head_to_print->job_start_time < 300) /* For jobs less than 5 min long. */
		{
			/* calculer stretch et tronquer a 1 pour les petits jobs. */
			if ((head_to_print->job_end_time - head_to_print->job_subtime)/head_to_print->empty_cluster_time < 1)
			{
				total_flow_stretch_with_a_minimum += 1;
			}
			else
			{
				total_flow_stretch_with_a_minimum += (head_to_print->job_end_time - head_to_print->job_subtime)/head_to_print->empty_cluster_time;
			}
		}
		else
		{
			total_flow_stretch_with_a_minimum += (head_to_print->job_end_time - head_to_print->job_subtime)/head_to_print->empty_cluster_time;
		}
				
		core_time_used += head_to_print->time_used*head_to_print->job_cores;
		total_queue_time += head_to_print->job_start_time - head_to_print->job_subtime;
		if (max_queue_time < head_to_print->job_start_time - head_to_print->job_subtime)
		{
			max_queue_time = head_to_print->job_start_time - head_to_print->job_subtime;
		}
		total_flow += head_to_print->job_end_time - head_to_print->job_subtime;
		if (max_flow < head_to_print->job_end_time - head_to_print->job_subtime)
		{
			max_flow = head_to_print->job_end_time - head_to_print->job_subtime;
		}
		//~ total_transfer_time += head_to_print->transfer_time - head_to_print->waiting_for_a_load_time;
		total_transfer_time += head_to_print->transfer_time;
		total_waiting_for_a_load_time += head_to_print->waiting_for_a_load_time;
		//~ total_waiting_for_a_load_time_and_transfer_time += head_to_print->transfer_time;
		total_waiting_for_a_load_time_and_transfer_time += head_to_print->transfer_time + head_to_print->waiting_for_a_load_time;
		if (makespan < head_to_print->job_end_time)
		{
			makespan = head_to_print->job_end_time;
		}
		
		/* For distribution of flow and queue times on each job to show VS curves */
		fprintf(f_queue, "%d %d %d %d %d\n", head_to_print->job_unique_id, head_to_print->job_start_time - head_to_print->job_subtime, head_to_print->data_type, head_to_print->job_end_time - head_to_print->job_start_time, head_to_print->job_subtime);
		fprintf(f_flow, "%d %d %d %d %d\n", head_to_print->job_unique_id, head_to_print->job_end_time - head_to_print->job_subtime, head_to_print->data_type, head_to_print->job_end_time - head_to_print->job_start_time, head_to_print->job_subtime);
		fprintf(f_stretch, "%d %f %d %d %d\n", head_to_print->job_unique_id, (head_to_print->job_end_time - head_to_print->job_subtime)/head_to_print->empty_cluster_time, head_to_print->data_type, head_to_print->job_end_time - head_to_print->job_start_time, head_to_print->job_subtime);
		head_to_print = head_to_print->next;
	}
	fclose(f_queue);
	fclose(f_flow);
	fclose(f_stretch);
		
	/* Compute mean values */
	mean_queue_time = total_queue_time/nb_job_to_evaluate;
	mean_flow = total_flow/nb_job_to_evaluate;
	mean_flow_stretch = total_flow_stretch/nb_job_to_evaluate;
	mean_flow_stretch_with_a_minimum = total_flow_stretch_with_a_minimum/nb_job_to_evaluate;
	
	/* Main file of reults */
	file_to_open = malloc(100*sizeof(char));
	strcpy(file_to_open, "outputs/Results_");
	strcat(file_to_open, scheduler);
	strcat(file_to_open, ".csv");
	FILE* f = fopen(file_to_open, "a");
	if (!f)
	{
		perror("Error opening file.\n");
		exit(EXIT_FAILURE);
	}
	fprintf(f, "%s,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n", scheduler, nb_job_to_evaluate, max_queue_time, mean_queue_time, total_queue_time, max_flow, mean_flow, total_flow, total_transfer_time, makespan, core_time_used, total_waiting_for_a_load_time, total_waiting_for_a_load_time_and_transfer_time, mean_flow_stretch);
	fclose(f);
	
	/* For flow stretch heat map */
	file_to_open = malloc(100*sizeof(char));
	strcpy(file_to_open, "outputs/Stretch_");
	strcat(file_to_open, scheduler);
	strcat(file_to_open, ".txt");
	f = fopen(file_to_open, "w");
	if (!f)
	{
		perror("Error opening file.\n");
		exit(EXIT_FAILURE);
	}
	fprintf(f, "%f", mean_flow_stretch);
	fclose(f);
	
	/* For flow stretch with a minimum heat map */
	file_to_open = malloc(100*sizeof(char));
	strcpy(file_to_open, "outputs/Stretch_with_a_minimum_");
	strcat(file_to_open, scheduler);
	strcat(file_to_open, ".txt");
	f = fopen(file_to_open, "w");
	if (!f)
	{
		perror("Error opening file.\n");
		exit(EXIT_FAILURE);
	}
	fprintf(f, "%f", mean_flow_stretch_with_a_minimum);
	fclose(f);
	
	/* For total flow heat map */
	file_to_open = malloc(100*sizeof(char));
	strcpy(file_to_open, "outputs/Total_flow_");
	strcat(file_to_open, scheduler);
	strcat(file_to_open, ".txt");
	f = fopen(file_to_open, "w");
	if (!f)
	{
		perror("Error opening file.\n");
		exit(EXIT_FAILURE);
	}
	fprintf(f, "%f", total_flow);
	fclose(f);
	
	free(file_to_open);
}
