#include <main.h>

void print_node_list(struct Node_List** list)
{
	for (int i = 0; i < 3; i++)
	{
		struct Node* n = list[i]->head;
		while (n != NULL)
		{
			printf("Id: %d Memory: %d Bandwidth: %f Available cores: %d\n", n->unique_id, n->memory, n->bandwidth, n->n_available_cores);
			n = n->next;
		}
	}
}

void print_single_node(struct Node* n)
{
	printf("Id: %d Memory: %d Bandwidth: %f Available cores: %d\n", n->unique_id, n->memory, n->bandwidth, n->n_available_cores);
}

void print_job_list(struct Job* list)
{
	//~ if (list == NULL)
	//~ {
		//~ return;
	//~ }
	struct Job* j = list;
	while (j != NULL)
	{
		printf("Id: %d Subtime: %d Delay: %d Walltime: %d Cores: %d Data: %d Data_size: %f Data_category: %d Workload: %d Start_time_from_history: %d Node_from_history: %d\n", j->unique_id, j->subtime, j->delay, j->walltime, j->cores, j->data, j->data_size, j->index_node_list, j->workload, j->start_time_from_history, j->node_from_history);
		j = j->next;
	}
}

void print_decision_in_scheduler(struct Job* j)
{
	printf("Job %d using file %d category %d workload %d will be computed on node %d core(s) ", j->unique_id, j->data, j->index_node_list, j->workload, j->node_used->unique_id);
	for (int i = 0; i < j->cores - 1; i++)
	{
		printf("%d,", j->cores_used[i]);
	}
	printf("%d", j->cores_used[j->cores - 1]);
	printf(" start at time %d and is predicted to finish at time %d.\n", j->start_time, j->end_time);
}

void print_cores_in_specific_node(struct Node* n)
{
	printf("Cores in node %d are: ", n->unique_id);
	for (int i = 0; i < 19; i++)
	{
		printf("%d(%d),", n->cores[i]->unique_id, n->cores[i]->available_time);
	}
	printf("%d(%d).\n", n->cores[19]->unique_id, n->cores[19]->available_time);
}

//~ /* Print in a csv file the results of this job allocation. */
//~ void to_print_job_csv(struct Job* j, node_used, core_ids, time, first_time_day_0)
//~ {
	//~ int time_used = j->end_time - j->start_time
	
	//~ /* Only evaluate jobs from workload 1. */
	//~ if (j->workload == 1)
	//~ {
		//~ // tp = To_print(j->unique_id, j->subtime, node_used, core_ids, time, time_used, j->transfer_time, j->start_time, j->end_time, j->cores, j->waiting_for_a_load_time, j->delay + j->data_size/0.1, j->index_node_list)
		//~ /* Update values */
		
		//~ if (fini all jobs)
		//~ {
			//~ print_csv();
		//~ }
		
	//~ }
		
	//~ #ifdef PRINT_GANTT_CHART
		//~ file_to_open = "outputs/Results_all_jobs_" + scheduler + ".csv"
		//~ f = open(file_to_open, "a")
		//~ # ~ f.write("%d,%d,delay,%f,%d,%f,1,COMPLETED_SUCCESSFULLY,%f,%f,%f,%f,%f,%f," % (j->unique_id, j->unique_id, j->subtime, j->cores, j->walltime, j->start_time, time_used, j->end_time, j->start_time, j->end_time, 1))
		//~ # ~ f.write("%d,%d,delay,%f,%d,%f,1,COMPLETED_SUCCESSFULLY,%f,%f,%f,%f,%f,%f," % (j->unique_id, j->unique_id, j->subtime, j->cores, j->walltime, j->start_time - 1000, time_used, j->end_time - 1000, j->start_time - 1000, j->end_time - 1000, 1))
		//~ f.write("%d,%d,delay,%f,%d,%f,1,COMPLETED_SUCCESSFULLY,%f,%f,%f,%f,%f,%f," % (j->unique_id, j->unique_id, 0, j->cores, j->walltime, j->start_time - first_time_day_0, time_used, j->end_time - first_time_day_0, j->start_time - first_time_day_0, j->end_time - first_time_day_0, 1))
				
		//~ if (len(core_ids) > 1):
			//~ # ~ core_ids.sort()
			//~ for i in range (0, len(core_ids)):
			//~ # ~ for i in core_ids:
				//~ if (i == len(core_ids) - 1):
					//~ f.write("%d" % (node_used*20 + core_ids[i]))
				//~ else:
					//~ # ~ print(node_used)
					//~ # ~ print(len(core_ids))
					//~ # ~ print(i)
					//~ # ~ f.write("%d-" % (node_used*20 + core_ids[i]))
					//~ f.write("%d " % (node_used*20 + core_ids[i]))
		//~ else:
			//~ f.write("%d" % (node_used*20 + core_ids[0]))
		//~ f.write(",-1,\"\"\n")
		//~ f.close()
	//~ #endif
	
	//~ #ifdef PRINT_DISTRIBUTION_QUEUE_TIMES
		// file_to_open = "outputs/Distribution_queue_times_" + scheduler + ".txt"
		// f = open(file_to_open, "a")
		// f.write("%d\n" % (j->start_time - j->subtime))
		// f.close()
	//~ #endif
//~ }

//~ void def print_csv(to_print_list, scheduler)
//~ {
	//~ # For distribution of flow and queue times on each job
	//~ f_queue = open("outputs/Queue_times_" + scheduler + ".txt", "w")
	//~ f_flow = open("outputs/Flow_times_" + scheduler + ".txt", "w")
	//~ f_stretch= open("outputs/Stretch_times_" + scheduler + ".txt", "w")
	
	//~ max_queue_time = 0
	//~ mean_queue_time = 0
	//~ total_queue_time = 0
	//~ max_flow = 0
	//~ mean_flow = 0
	//~ total_flow = 0
	//~ total_transfer_time = 0
	//~ total_waiting_for_a_load_time = 0
	//~ total_waiting_for_a_load_time_and_transfer_time = 0
	//~ makespan = 0
	//~ total_flow_stretch = 0
	//~ total_flow_stretch_with_a_minimum = 0
	//~ mean_flow_stretch = 0
	//~ mean_flow_stretch_with_a_minimum = 0
	//~ core_time_used = 0
	//~ job_exceeding_minimum = 0
	//~ for tp in to_print_list:
		
		//~ # Flow stretch
		//~ total_flow_stretch += (tp.job_end_time - tp.job_subtime)/tp.empty_cluster_time
		
		//~ if tp.job_end_time - tp.job_start_time >= 300: # Ignore jobs of delay less that 5 minutes
			//~ total_flow_stretch_with_a_minimum += (tp.job_end_time - tp.job_subtime)/tp.empty_cluster_time
			//~ job_exceeding_minimum += 1
		
		//~ # ~ print((tp.job_end_time - tp.job_subtime), tp.empty_cluster_time)
		
		//~ # ~ print("print", tp.job_unique_id)
		//~ core_time_used += tp.time_used*tp.job_cores
		//~ # ~ total_queue_time += tp.time - tp.job_subtime
		//~ total_queue_time += tp.job_start_time - tp.job_subtime
		//~ # ~ print("Job", tp.job_unique_id, "waited", tp.job_start_time - tp.job_subtime)
		//~ if (max_queue_time < tp.job_start_time - tp.job_subtime):
			//~ max_queue_time = tp.job_start_time - tp.job_subtime
		//~ # ~ total_flow += tp.time - tp.job_subtime + tp.time_used
		//~ total_flow += tp.job_end_time - tp.job_subtime
		//~ if (max_flow < tp.job_end_time - tp.job_subtime):
			//~ max_flow = tp.job_end_time - tp.job_subtime
		//~ total_transfer_time += tp.transfer_time - tp.waiting_for_a_load_time
		//~ total_waiting_for_a_load_time += tp.waiting_for_a_load_time
		//~ total_waiting_for_a_load_time_and_transfer_time += tp.transfer_time
		//~ # ~ if (makespan < tp.time + tp.time_used):
		//~ if (makespan < tp.job_end_time):
			//~ # ~ makespan = tp.time + tp.time_used
			//~ makespan = tp.job_end_time
		
		//~ # For distribution of flow and queue times on each job to show VS curves
		//~ f_queue.write("%d %d %d %d %d\n" % (tp.job_unique_id, tp.job_start_time - tp.job_subtime, tp.data_type, tp.job_end_time - tp.job_start_time, tp.job_subtime))
		//~ f_flow.write("%d %d %d %d %d\n" % (tp.job_unique_id, tp.job_end_time - tp.job_subtime, tp.data_type, tp.job_end_time - tp.job_start_time, tp.job_subtime))
		//~ f_stretch.write("%d %d %d %d %d\n" % (tp.job_unique_id, (tp.job_end_time - tp.job_subtime)/tp.empty_cluster_time, tp.data_type, tp.job_end_time - tp.job_start_time, tp.job_subtime))
	
	//~ f_queue.close()
	//~ f_flow.close()
	//~ f_stretch.close()
		
	//~ # Compute mean values
	//~ mean_queue_time = total_queue_time/len(to_print_list)
	//~ mean_flow = total_flow/len(to_print_list)
	//~ mean_flow_stretch = total_flow_stretch/len(to_print_list)
	//~ mean_flow_stretch_with_a_minimum = total_flow_stretch_with_a_minimum/job_exceeding_minimum
	//~ file_to_open = "outputs/Results_" + scheduler + ".csv"
	//~ f = open(file_to_open, "a")
	
	//~ # Simplify alorithms names
	//~ if (scheduler == "Fcfs_with_a_score"):
		//~ scheduler = "Fcfs-Score"
	//~ elif (scheduler == "Fcfs_easybf"):
		//~ scheduler = "Fcfs-EasyBf"
	//~ elif (scheduler == "Fcfs_with_a_score_easy_bf"):
		//~ scheduler = "Fcfs-Score-EasyBf"
	
	//~ f.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % (scheduler, str(len(to_print_list)), str(max_queue_time), str(mean_queue_time), str(total_queue_time), str(max_flow), str(mean_flow), str(total_flow), str(total_transfer_time), str(makespan), str(core_time_used), str(total_waiting_for_a_load_time), str(total_waiting_for_a_load_time_and_transfer_time), str(mean_flow_stretch)))
	//~ f.close()
	
	//~ # For flow stretch heat map
	//~ file_to_open = "outputs/Stretch_" + scheduler + ".txt"
	//~ f = open(file_to_open, "w")
	//~ f.write("%s" % (str(mean_flow_stretch)))
	//~ f.close()
	
	//~ # For flow stretch with a minimum heat map
	//~ file_to_open = "outputs/Stretch_with_a_minimum_" + scheduler + ".txt"
	//~ f = open(file_to_open, "w")
	//~ f.write("%s" % (str(mean_flow_stretch_with_a_minimum)))
	//~ f.close()
	
	//~ # For total flow heat map
	//~ file_to_open = "outputs/Total_flow_" + scheduler + ".txt"
	//~ f = open(file_to_open, "w")
	//~ f.write("%s" % (str(total_flow)))
	//~ f.close()
//~ }
