/** START ENERGY INCENTIVE **/
#include <main.h>

int endpoint_selection(int job_id, int user_behavior, double** tab_function_machine_credit, int total_number_nodes, double** tab_function_machine_energy, double* duration_on_machine, double* next_available_time_endpoint)
{
	int i = 0;
	/* User behavior: 0 = best credit - 1 = best energy - 2 = best runtime - 3 = random */
	double min = DBL_MAX;
	int min_id = 0;
	
	if (user_behavior == 0)
	{
		/* Just find the best credit from the tab */
		for (i = 0; i < total_number_nodes; i++)
		{
			//~ printf("Checked %f\n", tab_function_machine_credit[job_id][i]);
			if (tab_function_machine_credit[job_id][i] < min)
			{
				min = tab_function_machine_credit[job_id][i];
				min_id = i;
			}
		}
	}
	else if (user_behavior == 1)
	{
		/* Just find the least energy consumed (including idle) */
		for (i = 0; i < total_number_nodes; i++)
		{
			//~ printf("Checked %f\n", tab_function_machine_energy[job_id][i]);
			if (tab_function_machine_energy[job_id][i] < min)
			{
				min = tab_function_machine_energy[job_id][i];
				min_id = i;
			}
		}
	}
	else if (user_behavior == 2)
	{
		/* Just find the earliest finish time */
		for (i = 0; i < total_number_nodes; i++)
		{
			//~ printf("Checked %f\n", duration_on_machine[i]);
			if (duration_on_machine[i] + next_available_time_endpoint[i] < min)
			{
				min = duration_on_machine[i] + next_available_time_endpoint[i];
				min_id = i;
			}
		}
	}
	else if (user_behavior == 3)
	{
		/* Randomly select a node */
		min_id = rand() % total_number_nodes;
	}
	
	//~ printf("Min is with machine %d\n", min_id);
	return min_id;
}

void update_credit(int job_id, double* user_credit, double credit_to_remove)
{
	*user_credit = *user_credit - credit_to_remove;
}

void print_csv_energy_incentive(struct To_Print* head_to_print, int nusers)
{
	FILE *f;
	int job_shared_id = 0; /* To signifie that a job is the same accross al users */
	f = fopen(output_file, "w");
	if (!f)
	{
		perror("Error opening file in print_csv_energy_incentive.\n"); fflush(stdout);
		exit(EXIT_FAILURE);
	}

	fprintf(f, "Job_unique_id, Job_shared_id, User_id, Selected_endpoint, Credit_lost, New_credit, Job_end_time\n");
	while (head_to_print != NULL)
	{
		fprintf(f, "%d, %d, %d, %d, %f, %f, %f", head_to_print->job_unique_id, job_shared_id, head_to_print->user_behavior, head_to_print->selected_endpoint, head_to_print->removed_credit, head_to_print->new_credit, head_to_print->job_end_time_double);
		fprintf(f, "\n");
		if (head_to_print->job_unique_id%nusers == nusers - 1)
		{
			job_shared_id++;
		}
		head_to_print = head_to_print->next;
	}
	
	fclose(f);
}
/** END ENERGY INCENTIVE **/
