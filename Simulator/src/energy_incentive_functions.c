/** START ENERGY INCENTIVE **/
#include <main.h>

int endpoint_selection(int job_id, int user_behavior, double** tab_function_machine_credit, int total_number_nodes, double** tab_function_machine_energy, double* duration_on_machine)
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
			printf("Checked %f\n", tab_function_machine_credit[job_id][i]);
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
			printf("Checked %f\n", tab_function_machine_energy[job_id][i]);
			if (tab_function_machine_energy[job_id][i] < min)
			{
				min = tab_function_machine_energy[job_id][i];
				min_id = i;
			}
		}
	}
	else if (user_behavior == 2)
	{
		/* Just find the fastest runtime */
		for (i = 0; i < total_number_nodes; i++)
		{
			printf("Checked %f\n", duration_on_machine[i]);
			if (duration_on_machine[i] < min)
			{
				min = duration_on_machine[i];
				min_id = i;
			}
		}
	}
	else if (user_behavior == 3)
	{
		/* Randomly select a node */
		min_id = rand() % total_number_nodes;
	}
	
	printf("Min is with machine %d\n", min_id);
	return min_id;
}

void update_credit(int job_id, double* user_credit, double credit_to_remove)
{
	*user_credit = *user_credit - credit_to_remove;
}

void print_csv_energy_incentive(struct To_Print* head_to_print)
{
	FILE *f;
	f = fopen(output_file, "w");
	if (!f)
	{
		perror("Error opening file in print_csv_energy_incentive.\n"); fflush(stdout);
		exit(EXIT_FAILURE);
	}

	fprintf(f, "Job_id, User_id, Selected_endpoint, Credit_lost, New_credit\n");
	while (head_to_print != NULL)
	{
		fprintf(f, "%d, %d, %d, %f, %f", head_to_print->job_unique_id, head_to_print->user_behavior, head_to_print->selected_endpoint, head_to_print->removed_credit, head_to_print->new_credit);
		//~ if (head_to_print->job_id%nusers == 0)
		//~ {
		fprintf(f, "\n");
		//~ }
		head_to_print = head_to_print->next;
	}
	
	fclose(f);
}
/** END ENERGY INCENTIVE **/
