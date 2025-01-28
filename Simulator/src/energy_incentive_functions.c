/** START ENERGY INCENTIVE **/
#include <main.h>

int endpoint_selection(int job_id, int user_behavior, double** tab_function_machine_credit, int total_number_nodes, double** tab_function_machine_energy, double* duration_on_machine, double** next_available_time_endpoint, double* carbon_rates, double** carbon_intensity_one_hour_slices_per_machine, bool is_credit)
{
	int i = 0;
	/* User behavior: 0 = best credit - 1 = best energy - 2 = best runtime - 3 = random - 4 worst credit - 5 = Only theta - 6 = Only midway - 7 = Only faster */
	double min = DBL_MAX;
	int min_id = -1;
	double tab_function_machine_credit_predicted = 0;
	double avg_carbon_intensity = 0;

	if (user_behavior == 0)
	{
		/* Find the best credit from the tab */
		for (i = 0; i < total_number_nodes; i++)
		{
			if (is_credit == false) {
				/** Varying carbon intensity **/
				double current_time = next_available_time_endpoint[user_behavior][i];
				int job_length = duration_on_machine[i];
				int *slice_indices = NULL;
				double *proportions = NULL;
				int num_slices;
				int current_slice;
				avg_carbon_intensity = 0;

				get_slices(current_time, job_length, &current_slice, &slice_indices, &proportions, &num_slices);
				
				//~ printf("Job starts at %.2f seconds and lasts %d seconds.\n", current_time, job_length);
				//~ printf("The job starts in slice %d.\n", current_slice);
				for (int j = 0; j < num_slices; j++) {
					//~ printf("Slice %d: %.2f%% of the job\n", slice_indices[j], proportions[j] * 100);
					if (slice_indices[j] < 0 || proportions[j] < 0) { printf("ERROR user_behavior = %d\n", user_behavior); exit(1); }
					avg_carbon_intensity += carbon_intensity_one_hour_slices_per_machine[j][i]*proportions[j];
					//~ printf("avg_carbon_intensity = %f\n", avg_carbon_intensity);
				}
				tab_function_machine_credit_predicted = tab_function_machine_credit[job_id][i]*((avg_carbon_intensity + carbon_rates[i])/1000);
				//~ printf("tab_function_machine_credit_predicted = %f\n", tab_function_machine_credit_predicted);
				free(slice_indices);
				free(proportions);
			}
			else {
				tab_function_machine_credit_predicted = tab_function_machine_credit[job_id][i];
			}
			
			if (tab_function_machine_credit_predicted < min && tab_function_machine_energy[job_id][i] != -1)
			{
				min = tab_function_machine_credit_predicted;
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
			if (is_credit == false) {
				/** Varying carbon intensity **/
				double current_time = next_available_time_endpoint[user_behavior][i];
				int job_length = duration_on_machine[i];
				int *slice_indices = NULL;
				double *proportions = NULL;
				int num_slices;
				int current_slice;
				avg_carbon_intensity = 0;

				get_slices(current_time, job_length, &current_slice, &slice_indices, &proportions, &num_slices);
				
				//~ printf("Job starts at %.2f seconds and lasts %d seconds.\n", current_time, job_length);
				//~ printf("The job starts in slice %d.\n", current_slice);
				for (int j = 0; j < num_slices; j++) {
					//~ printf("Slice %d: %.2f%% of the job\n", slice_indices[j], proportions[j] * 100);
					if (slice_indices[j] < 0 || proportions[j] < 0) { printf("ERROR user_behavior = %d\n", user_behavior); exit(1); }
					avg_carbon_intensity += carbon_intensity_one_hour_slices_per_machine[j][i]*proportions[j];
					//~ printf("avg_carbon_intensity = %f\n", avg_carbon_intensity);
				}
				tab_function_machine_credit_predicted = tab_function_machine_credit[job_id][i]*((avg_carbon_intensity + carbon_rates[i])/1000);
				//~ printf("tab_function_machine_credit_predicted = %f\n", tab_function_machine_credit_predicted);
				free(slice_indices);
				free(proportions);
			}
			else {
				tab_function_machine_credit_predicted = tab_function_machine_credit[job_id][i];
			}
			
			if (tab_function_machine_credit_predicted > min && tab_function_machine_energy[job_id][i] != -1)
			{
				min = tab_function_machine_credit_predicted;
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
			if (is_credit == false) {
				/** Varying carbon intensity **/
				double current_time = next_available_time_endpoint[user_behavior][i];
				int job_length = duration_on_machine[i];
				int *slice_indices = NULL;
				double *proportions = NULL;
				int num_slices;
				int current_slice;
				avg_carbon_intensity = 0;

				get_slices(current_time, job_length, &current_slice, &slice_indices, &proportions, &num_slices);
				
				//~ printf("Job starts at %.2f seconds and lasts %d seconds.\n", current_time, job_length);
				//~ printf("The job starts in slice %d.\n", current_slice);
				for (int j = 0; j < num_slices; j++) {
					//~ printf("Slice %d: %.2f%% of the job\n", slice_indices[j], proportions[j] * 100);
					if (slice_indices[j] < 0 || proportions[j] < 0) { printf("ERROR user_behavior = %d\n", user_behavior); exit(1); }
					avg_carbon_intensity += carbon_intensity_one_hour_slices_per_machine[j][i]*proportions[j];
					//~ printf("avg_carbon_intensity = %f\n", avg_carbon_intensity);
				}
				tab_function_machine_credit_predicted = tab_function_machine_credit[job_id][i]*((avg_carbon_intensity + carbon_rates[i])/1000);
				//~ printf("tab_function_machine_credit_predicted = %f\n", tab_function_machine_credit_predicted);
				free(slice_indices);
				free(proportions);
			}
			else {
				tab_function_machine_credit_predicted = tab_function_machine_credit[job_id][i];
			}
						
			if (tab_function_machine_credit_predicted < min && tab_function_machine_energy[job_id][i] != -1)
			{
				min = tab_function_machine_credit_predicted;
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

void get_slices(double current_time, int job_length, int *current_slice, int **slice_indices, double **proportions, int *num_slices) {
    //~ printf("%f\n", current_time);   
   
    //~ int start_time = (int)current_time;
    double start_time = current_time;
    double end_time = start_time + job_length;
    
    
    // Compute the slice indices where the job starts and ends
    int start_slice = (int)(start_time / 3600);    // The slice where the job starts
    int end_slice = (int)((end_time - 1) / 3600);  // The slice where the job ends
    
    // Ensure the slice indices are within the range [0, 8759]
    start_slice %= 8760;   // Loop back if slice is greater than 8759
    end_slice %= 8760;
    bool will_go_over = false;
    
    // same for the time
    start_time = fmod(start_time, 8760.0 * 3600.0);
    end_time = fmod(end_time, 8760.0 * 3600.0);
    
    if (end_time < start_time) {
        will_go_over = true;
    }
    
    // Handle the case when the job spans the end of the year (wraps to slice 0)
    if (end_slice >= start_slice) {
        *num_slices = end_slice - start_slice + 1;
    } else {
        *num_slices = 8760 - start_slice + end_slice + 1;
    }

    // Allocate memory for slice indices and proportions
    *slice_indices = malloc(*num_slices * sizeof(int));
    *proportions = malloc(*num_slices * sizeof(double));

    if (!*slice_indices || !*proportions) {
        perror("Failed to allocate memory");
        exit(1);
    }
    bool next_is_loop_back = false;
    // Fill the slice indices and proportions arrays
    for (int i = 0; i < *num_slices; i++) {
        // Wrap around the slice index using modulo
        int slice_index = (start_slice + i) % 8760;
        double slice_start = slice_index * 3600;
        double slice_end = slice_start + 3600;
        
        double overlap_start = 0;
        double overlap_end = 0;
        if (next_is_loop_back == true) {
            overlap_start = slice_start;
        }
        else {
            // Calculate the overlap with the current slice
            overlap_start = (start_time > slice_start) ? start_time : slice_start;
        }
        if (will_go_over == true && next_is_loop_back == false) {
            overlap_end = slice_end;
        }
        else {
            overlap_end = (end_time < slice_end) ? end_time : slice_end;
        }
        double overlap_duration = overlap_end - overlap_start;
        // Calculate the proportion of the slice that is used
        (*slice_indices)[i] = slice_index;
        (*proportions)[i] = overlap_duration / job_length;
        
        if (slice_index == 8759) { 
            next_is_loop_back = true; 
            end_time = job_length - (31536000.0 - start_time); 
        }
    }

    // Determine the current slice in which the job is located
    *current_slice = start_slice;
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

	fprintf(f, "Job_unique_id, Job_shared_id, User_id, Selected_endpoint, Credit_lost, New_credit, Job_end_time, Energy_used_watt_hours, Number_of_cores_hours_used, Queue_time, Mean_duration_on_machines, Number_of_cores_used, Carbon_used_in_grams, Direct_carbon_used_in_grams\n");
	while (head_to_print != NULL)
	{
		fprintf(f, "%d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %d, %f, %f", head_to_print->job_unique_id, job_shared_id, head_to_print->user_behavior, head_to_print->selected_endpoint, head_to_print->removed_credit, head_to_print->new_credit, head_to_print->job_end_time_double, head_to_print->energy_used_watt_hours, head_to_print->core_hours_used, head_to_print->queue_time, head_to_print->mean_duration_on_machine, head_to_print->job_cores, head_to_print->carbon_used, head_to_print->direct_carbon_used);
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
