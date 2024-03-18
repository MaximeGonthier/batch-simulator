/** START ENERGY INCENTIVE **/
#include <main.h>

int endpoint_selection(int job_id, int user_behavior, double** tab_function_machine_credit, int total_number_nodes, double** tab_function_machine_energy, double* duration_on_machine, double** next_available_time_endpoint)
{
	int i = 0;
	/* User behavior: 0 = best credit - 1 = best energy - 2 = best runtime - 3 = random - 4 worst credit - 5 = Only theta - 6 = Only midway - 7 = Only faster */
	double min = DBL_MAX;
	int min_id = -1;
	
	if (user_behavior == 0)
	{
		/* Find the best credit from the tab */
		for (i = 0; i < total_number_nodes; i++)
		{
			if (tab_function_machine_credit[job_id][i] < min && tab_function_machine_energy[job_id][i] != -1)
			{
				min = tab_function_machine_credit[job_id][i];
				min_id = i;
			}
		}
	}
	else if (user_behavior == 1)
	{
		/* Find the least energy consumed (including idle) */
		for (i = 0; i < total_number_nodes; i++)
		{
			if (tab_function_machine_energy[job_id][i] < min && tab_function_machine_energy[job_id][i] != -1)
			{
				min = tab_function_machine_energy[job_id][i];
				min_id = i;
			}
		}
	}
	else if (user_behavior == 2)
	{
		/* Find the earliest finish time */
		for (i = 0; i < total_number_nodes; i++)
		{
			//~ printf("duration_on_machine %d: %f next_available_time_endpoint: %f\n", i, duration_on_machine[i], next_available_time_endpoint[user_behavior][i]);
			if (duration_on_machine[i] + next_available_time_endpoint[user_behavior][i] < min && tab_function_machine_energy[job_id][i] != -1)
			{
				min = duration_on_machine[i] + next_available_time_endpoint[user_behavior][i];
				min_id = i;
			}
		}
	}
	else if (user_behavior == 3)
	{
		/* Find the number of nodes we can choose from */
		int total_number_nodes_to_choose_from = total_number_nodes;
		for (i = 0; i < total_number_nodes; i++)
		{
			if (tab_function_machine_energy[job_id][i] == -1)
			{
				total_number_nodes_to_choose_from -= 1;
			}
		}
		
		/* Randomly select a number between 0 and this number */
		min_id = rand() % total_number_nodes_to_choose_from;
		/* Get the corresponding node by ignoring impossible combinations nodes */
		for (i = 0; i < total_number_nodes; i++)
		{
			if (tab_function_machine_energy[job_id][i] != -1)
			{
				if (min_id == 0)
				{
					min_id = i;
					break;
				}
				min_id -= 1;
			}
		}
	}
	else if (user_behavior == 4)
	{
		/* Find the worst credit from the tab */
		min = -1;
		for (i = 0; i < total_number_nodes; i++)
		{
			if (tab_function_machine_credit[job_id][i] > min && tab_function_machine_energy[job_id][i] != -1)
			{
				min = tab_function_machine_credit[job_id][i];
				min_id = i;
			}
		}
	}
	else if (user_behavior == 5)
	{
		/* Always use the theta endpoint */
		min_id = 0;
	}
	else if (user_behavior == 6)
	{
		/* Always use the midway endpoint */
		min_id = 1;
	}
	//~ else if (user_behavior == 7)
	//~ {
		//~ /* Always use the desktop endpoint */
		//~ min_id = 2;
	//~ }
	else if (user_behavior == 7)
	{
		/* Always use the faster endpoint */
		min_id = 3;
	}
	else if (user_behavior == 8)
	{
		/* Mixed user that select eft if the job can complete twice as fast. Else choose energy. */
		int min_credit_id = 0;
		int min_completion_time_id = 0;
		double min_credit_completion_time = 0;
		double min_completion_time = DBL_MAX;
		/* Find what endpoint would give the best credit. */
		for (i = 0; i < total_number_nodes; i++)
		{
			if (tab_function_machine_credit[job_id][i] < min && tab_function_machine_energy[job_id][i] != -1)
			{
				min = tab_function_machine_credit[job_id][i];
				min_credit_id = i;
				min_credit_completion_time = duration_on_machine[i] + next_available_time_endpoint[user_behavior][i];
			}
		}
		/* Find what endpoint would give the smallest completion time. */
		for (i = 0; i < total_number_nodes; i++)
		{
			if (duration_on_machine[i] + next_available_time_endpoint[user_behavior][i] < min_completion_time && tab_function_machine_energy[job_id][i] != -1)
			{
				min_completion_time = duration_on_machine[i] + next_available_time_endpoint[user_behavior][i];
				min_completion_time_id = i;
			}
		}
		if (min_completion_time == DBL_MAX || min_credit_completion_time == 0)
		{
			printf("Something went wrong mixed user\n");
			exit(EXIT_FAILURE);
		}
		//~ printf("%f and %f\n", min_completion_time, min_credit_completion_time);
		if (min_completion_time <= min_credit_completion_time/2)
		{
			min_id = min_completion_time_id;
		}
		else
		{
			min_id = min_credit_id;
		}
	}
	else if (user_behavior == 9) /* Runtime user. Always choose the endpoint with the lowest runtime. Do not consider queues. */
	{
		/* Find the earliest finish time */
		for (i = 0; i < total_number_nodes; i++)
		{
			if (duration_on_machine[i] < min && tab_function_machine_energy[job_id][i] != -1)
			{
				min = duration_on_machine[i];
				min_id = i;
			}
		}
	}
	
	if (min_id == -1)
	{
		printf("Error, min_id = -1 meaning that no endpoint have been choosen!\n");
		exit(EXIT_FAILURE);
	}
	//~ printf("user_behavior = %d, min is with machine %d\n", user_behavior, min_id);
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

	fprintf(f, "Job_unique_id, Job_shared_id, User_id, Selected_endpoint, Credit_lost, New_credit, Job_end_time, Energy_used_watt_hours, Number_of_cores_hours_used, Queue_time, Mean_duration_on_machines, Number_of_cores_used, Carbon_used_in_grams\n");
	while (head_to_print != NULL)
	{
		fprintf(f, "%d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %d, %f", head_to_print->job_unique_id, job_shared_id, head_to_print->user_behavior, head_to_print->selected_endpoint, head_to_print->removed_credit, head_to_print->new_credit, head_to_print->job_end_time_double, head_to_print->energy_used_watt_hours, head_to_print->core_hours_used, head_to_print->queue_time, head_to_print->mean_duration_on_machine, head_to_print->job_cores, head_to_print->carbon_used);
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
