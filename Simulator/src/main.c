#include <main.h>

int first_node_size_to_choose_from;
int last_node_size_to_choose_from;

char* input_job_file;

int planned_or_ratio; /* O = planned, 1 = ratio */
int constraint_on_sizes;
int nb_cores;
int nb_job_to_evaluate;
int finished_jobs;
int total_number_jobs;
int total_number_nodes;
struct Job_List* job_list; /* All jobs not available yet */
struct Job_List* new_job_list; /* New available jobs */
struct Job_List* job_list_to_start_from_history; /* With -2 and before start */
struct Job_List* scheduled_job_list; /* Scheduled or available */
struct Job_List* running_jobs; /* Started */
struct Node_List** node_list;
struct To_Print_List* jobs_to_print_list;
int running_cores;
int running_nodes;
#ifdef PRINT_CLUSTER_USAGE
int running_cores_from_workload_1;
int running_nodes_workload_1;
int mixed_mode;
#endif
int total_queue_time;
int first_subtime_day_0;
int nb_job_to_schedule;
int nb_cores_to_schedule;
char* scheduler;
char* output_file;
struct Next_Time_List* end_times;
struct Next_Time_List* start_times;
int nb_job_to_evaluate_started;
long long Allocated_Area[3][3];
long long Planned_Area[3][3];
int number_node_size[3];
int busy_cluster;
int backfill_mode;
#ifdef PLOT_STATS
int number_of_backfilled_jobs;
int number_of_tie_breaks_before_computing_evicted_files_fcfs_score;
int total_number_of_scores_computed;
int data_persistence_exploited;
#endif
int biggest_hole;
int biggest_hole_unique_id;
int global_nb_non_available_cores_at_time_t;
int nb_data_reuse;
int busy_cluster_threshold;

#ifdef NB_HOUR_MAX
int nb_h_scheduled;
#endif

int nb_call_finished_jobs;
int nb_call_new_jobs;

int main(int argc, char *argv[])
{
	#ifdef NB_HOUR_MAX
	nb_h_scheduled = 1;
	#endif
	
	nb_data_reuse = 0;
	if (argc != 9 && argc != 10 && argc != 11)
	{
		printf("Error: args must be 9, 10 or 11!\n");
		exit(EXIT_FAILURE);
	}
	
	bool need_to_resume_state = false;
	#ifdef SAVE
	/* By default I don't save/resume */
	bool need_to_save_state = false;
	int time_to_save = 0;
			
	/* If you add save or resume as the last argument */
	if (argc > 11)
	{
		if (strcmp(argv[11], "save") == 0) 
		{
			need_to_save_state = true;
			time_to_save = atoi(argv[12]);
			printf("Save after %d jobs.\n", time_to_save); fflush(stdout);
		}
		else if (strcmp(argv[11], "save_and_resume") == 0)
		{
			need_to_resume_state = true;
			need_to_save_state = true;
			time_to_save = atoi(argv[12]);
			printf("Time to save_and_resume is %d.\n", time_to_save); fflush(stdout);
		}
		else if (strcmp(argv[11], "resume") == 0)
		{
			need_to_resume_state = true;
			if (argc > 12)
			{
				printf("Error: no arg must be after resume.\n"); fflush(stdout);
				exit(EXIT_FAILURE);
			}
		}
		else
		{
			printf("Error: argv[11] must be save or resume.\n");
			exit(EXIT_FAILURE);
		}
	}
	#endif
	
	new_job_list = (struct Job_List*) malloc(sizeof(struct Job_List));
	new_job_list->head = NULL;
	new_job_list->tail = NULL;
	
	#ifdef PLOT_STATS
	number_of_backfilled_jobs = 0;
	number_of_tie_breaks_before_computing_evicted_files_fcfs_score = 0;
	total_number_of_scores_computed = 0;
	data_persistence_exploited = 0;
	#endif
	
	/* Random seed init. */
	busy_cluster = 0; /* Not busy initially */
	srand(time(NULL));
	planned_or_ratio = 0;
	/* Init global variables */
	finished_jobs = 0;
	total_number_jobs = 0;
	running_cores = 0;
	running_nodes = 0;
	#ifdef PRINT_CLUSTER_USAGE
	running_nodes_workload_1 = 0;
	mixed_mode = 0;
	int nodes_loading_a_file = 0;
	int cores_loading_a_file = 0;
	#endif
	
	first_node_size_to_choose_from = 0;
	last_node_size_to_choose_from = 2;
	
	nb_job_to_evaluate_started = 0;
	total_queue_time = 0;
	struct Job* job_pointer = (struct Job*) malloc(sizeof(struct Job));
	
	#ifndef ENERGY_INCENTIVE
	struct Job* temp = (struct Job*) malloc(sizeof(struct Job));
	#endif
	
	end_times = malloc(sizeof(*end_times));
	end_times->head = NULL;
	start_times = malloc(sizeof(*start_times));
	start_times->head = NULL;
	jobs_to_print_list = malloc(sizeof(*jobs_to_print_list));
	jobs_to_print_list->head = NULL;
	jobs_to_print_list->tail = NULL;
	
	#ifndef ENERGY_INCENTIVE
	int old_finished_jobs = 0;
	#endif
	
	/** Args **/
	input_job_file = argv[1];
	char* input_node_file = argv[2];
	scheduler = argv[3]; /* malloc ? */
	constraint_on_sizes = atoi(argv[4]); /* To add or remove the constraint that some jobs can't be executed on certain nodes. 0 for no constraint, 1 for constraint, 2 for constraint but we don't consider transfer time. 3 for constraint and you can only execute on your specific size. */
	output_file = argv[5];
	if (output_file == NULL)
	{
		printf("Need file output\n");
		exit(1);
	}
	
	backfill_mode = atoi(argv[6]);
	if (backfill_mode < 0 || backfill_mode > 3)
	{
		printf("Error, backfill_mode = %d not dealt with.\n", backfill_mode);
		exit(1);
	}
	
	#ifdef DATA_PERSISTENCE
	if (constraint_on_sizes != 0)
	{
		printf("Constraint on sizes not dealt with if it's not 0 with data persistence (because of the way I look at the memory usage of a node.\n");
		exit(1);
	}
	#endif
	
	printf("Workload: %s\n", input_job_file);
	printf("Scheduler: %s - Backfill mode: %d\n", scheduler, backfill_mode);

	if (constraint_on_sizes != 0)
	{
		printf("Error constraint on size.\n"); fflush(stdout);
		exit(EXIT_FAILURE);
	}
	
	/* Read cluster */
	if (need_to_resume_state == false)
	{
		read_cluster(input_node_file);
	}

	#ifdef PRINT
	print_node_list(node_list);
	#endif
	
	/* Read workload */
	//~ #ifndef SAVE
	if (need_to_resume_state == false)
	{
		read_workload(input_job_file, constraint_on_sizes);	
		nb_job_to_evaluate = get_nb_job_to_evaluate(job_list->head);
		first_subtime_day_0 = get_first_time_day_0(job_list->head);
	}
	//~ #endif
	
	#ifdef PRINT_CLUSTER_USAGE
	write_in_file_first_times_all_day(job_list->head, first_subtime_day_0);
	#endif
	
	#ifndef ENERGY_INCENTIVE
	int next_submit_time = first_subtime_day_0;
	#endif
	
	int t = first_subtime_day_0;

	/* First start jobs from rackham's history. First need to sort it by start time */
	//~ #ifndef SAVE
	if (need_to_resume_state == false) 
	{
		if (job_list_to_start_from_history->head != NULL)
		{
			get_state_before_day_0_scheduler(job_list_to_start_from_history->head, node_list, t);
		}
	}
	//~ #endif

	//~ #ifdef PRINT
	//~ printf("\nScheduled job list after scheduling -2 jobs from history. Must be full.\n");
	//~ print_job_list(scheduled_job_list->head);
	//~ #endif

	/* getting the number of jobs we need to schedule */
	//~ #ifndef SAVE
	if (need_to_resume_state == false)
	{
		job_pointer = scheduled_job_list->head;
		nb_job_to_schedule = 0;
		nb_cores_to_schedule = 0;
		while(job_pointer != NULL)
		{
			nb_job_to_schedule += 1;
			nb_cores_to_schedule += job_pointer->cores;
			job_pointer = job_pointer->next;
		}
		//~ printf("After scheduling jobs of workload -2, the number of jobs to schedule at t = 0 is %d.\n", nb_job_to_schedule);
	//~ }	
	//~ {
		/* Just for -2 jobs here */
		if (scheduled_job_list->head != NULL)
		{
			start_jobs(t, scheduled_job_list->head);
		}
		//~ printf("Start jobs before day 0 done.\n");
	}
	//~ #endif
	
	//~ #ifdef PRINT
	//~ printf("\nSchedule job list after starting - 2. Must be less full.\n"); fflush(stdout);
	//~ print_job_list(scheduled_job_list->head);
	//~ #endif

	#ifdef PRINT_SCORES_DATA
	FILE* f_fcfs_score = fopen("outputs/Scores_data.txt", "w");
	if (!f_fcfs_score)
	{
		perror("fopen in main");
        exit(EXIT_FAILURE);
	}
	fclose(f_fcfs_score);
	#endif
	
	/* Initializings stats on choosen method. */
	#ifdef PLOT_STATS
	FILE* f_stats_choosen_method = fopen("outputs/choosen_methods.txt", "w");
	if (!f_stats_choosen_method)
	{
		perror("Error opening file outputs/choosen_methods.txt.");
		exit(EXIT_FAILURE);
	}
	fprintf(f_stats_choose valeriehayot@gmail.com has been added as a collaborator on the repository. n_method, "Job_id,Chosen_method\n");
	fclose(f_stats_choosen_method);
	#endif
	
	#ifdef PRINT_CLUSTER_USAGE
	/* Fichier complet */
	char* title = malloc(100*sizeof(char));
	strcpy(title, "outputs/Stats_");
	strcat(title, scheduler);
	strcat(title, ".csv");
	FILE* f_stats = fopen(title, "w");
	if (!f_stats)
	{
		perror("fopen in main");
        exit(EXIT_FAILURE);
	}
	fprintf(f_stats, "Time,Used cores,Used nodes,Scheduled jobs,Used nodes workload 1,Cores required in queue,Cores required from evaluated jobs in queue, Nodes loading a file, Used cores from workload 1, Cores loading a file\n");
	int nb_jobs_in_queue = 0;
	int nb_cores_in_queue = 0;
	int nb_cores_from_workload_1_in_queue = 0;
	free(title);
	#endif
	
	int i = 0;
	int j = 0;
	#ifndef ENERGY_INCENTIVE
	int multiplier_file_to_load = 0;
	int multiplier_file_evicted = 0;
	int multiplier_nb_copy = 0;
	int multiplier_area_bigger_nodes = 0;
	int adaptative_multiplier = 0; /* 0 = no, 1 = yes */
	int penalty_on_job_sizes = 0; /* 0 = no, 1 = yes */
	int backfill_big_node_mode = 0;
	bool use_bigger_nodes = true;
	#endif
	
	#ifndef ENERGY_INCENTIVE
	float (*Ratio_Area)[3] = malloc(sizeof(float[3][3]));
	int start_immediately_if_EAT_is_t = 0;
	int mixed_strategy = 0;
	
	/* Getting informations for certain schedulers. */
	if (strncmp(scheduler, "Fcfs_with_a_score_x", 19) == 0 || strncmp(scheduler, "Fcfs_with_a_score_easybf_x", 26) == 0 || strncmp(scheduler, "Fcfs_with_a_score_backfill_big_nodes_95th_percentile_x", 54) == 0 || strncmp(scheduler, "Fcfs_with_a_score_backfill_big_nodes_weighted_random_x", 54) == 0 || strncmp(scheduler, "Fcfs_area_filling_with_a_score_x", 32) == 0 || strncmp(scheduler, "Fcfs_area_filling_omniscient_with_a_score_x", 43) == 0 || strncmp(scheduler, "Fcfs_area_filling_with_ratio_with_a_score_x", 43) == 0 || strncmp(scheduler, "Fcfs_area_filling_omniscient_with_ratio_with_a_score_x", 54) == 0 || strncmp(scheduler, "Fcfs_area_filling_with_ratio_7_days_earlier_with_a_score_x", 58) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_x", 31) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_omniscient_planned_area_x", 60) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_planned_area_x", 49) == 0 || strncmp(scheduler, "Fcfs_with_a_score_backfill_big_nodes_gain_loss_tradeoff_x", 57) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_x", 41) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_3_x", 43) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_4_x", 43) == 0 || strncmp(scheduler, "Fcfs_with_a_score_penalty_on_big_jobs_x", 39) == 0 || strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_x", 34) == 0 || strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_not_EFT_x", 43) == 0 || strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_adaptative_multiplier_x", 56) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x", 53) == 0 || strncmp(scheduler, "Fcfs_with_a_score_conservativebf_x", 34) == 0 || strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_conservativebf_x", 49) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x", 68) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_easybf_x", 60) == 0 || strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_easybf_x", 41) == 0 || strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_non_dynamic_x", 46) == 0)
	{
		if (strncmp(scheduler, "Fcfs_with_a_score_x", 19) == 0)
		{
			i = 19;
			j = 19;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_easybf_x", 26) == 0)
		{
			i = 26;
			j = 26;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_backfill_big_nodes_95th_percentile_x", 54) == 0)
		{
			i = 54;
			j = 54;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_backfill_big_nodes_weighted_random_x", 54) == 0)
		{
			i = 54;
			j = 54;
		}
		else if (strncmp(scheduler, "Fcfs_area_filling_with_a_score_x", 32) == 0)
		{
			i = 32;
			j = 32;
		}
		else if (strncmp(scheduler, "Fcfs_area_filling_omniscient_with_a_score_x", 43) == 0)
		{
			i = 43;
			j = 43;
		}
		else if (strncmp(scheduler, "Fcfs_area_filling_with_ratio_with_a_score_x", 43) == 0)
		{
			i = 43;
			j = 43;
		}
		else if (strncmp(scheduler, "Fcfs_area_filling_omniscient_with_ratio_with_a_score_x", 54) == 0)
		{
			i = 54;
			j = 54;
		}
		else if (strncmp(scheduler, "Fcfs_area_filling_with_ratio_7_days_earlier_with_a_score_x", 58) == 0)
		{
			i = 58;
			j = 58;
		}		
		else if (strncmp(scheduler, "Fcfs_with_a_score_area_factor_x", 31) == 0)
		{
			i = 31;
			j = 31;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_omniscient_planned_area_x", 60) == 0)
		{
			i = 60;
			j = 60;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_planned_area_x", 49) == 0)
		{
			i = 49;
			j = 49;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_backfill_big_nodes_gain_loss_tradeoff_x", 57) == 0)
		{
			i = 57;
			j = 57;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_x", 41) == 0)
		{
			i = 41;
			j = 41;
			adaptative_multiplier = 1;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_3_x", 43) == 0)
		{
			i = 43;
			j = 43;
			adaptative_multiplier = 3;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_4_x", 43) == 0)
		{
			i = 43;
			j = 43;
			adaptative_multiplier = 4;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_penalty_on_big_jobs_x", 39) == 0)
		{
			i = 39;
			j = 39;
			penalty_on_job_sizes = 1;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_x", 34) == 0)
		{
			i = 34;
			j = 34;
			mixed_strategy = 1;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_non_dynamic_x", 46) == 0)
		{
			i = 46;
			j = 46;
			mixed_strategy = 2;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_not_EFT_x", 43) == 0)
		{
			i = 43;
			j = 43;
			mixed_strategy = 1;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_adaptative_multiplier_x", 56) == 0)
		{
			i = 56;
			j = 56;
			adaptative_multiplier = 2;
			mixed_strategy = 1;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x", 53) == 0)
		{
			i = 53;
			j = 53;
			start_immediately_if_EAT_is_t = 1;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x", 68) == 0)
		{
			i = 68;
			j = 68;
			start_immediately_if_EAT_is_t = 1;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_easybf_x", 60) == 0)
		{
			i = 60;
			j = 60;
			start_immediately_if_EAT_is_t = 1;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_conservativebf_x", 34) == 0)
		{
			i = 34;
			j = 34;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_conservativebf_x", 49) == 0)
		{
			i = 49;
			j = 49;
			mixed_strategy = 1;
		}
		else if (strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_easybf_x", 41) == 0)
		{
			i = 41;
			j = 41;
			mixed_strategy = 1;
		}
		else
		{
			printf("Error.\n");
			exit(EXIT_FAILURE);
		}
		
		int number_of_char = 0;
		
		/* Multiplier 1 */
		while (scheduler[i] != '_')
		{
			//~ printf("1: ++ with %c\n", scheduler[i]);
			i += 1;
			number_of_char += 1;
		}
		char to_copy1[number_of_char];
		for (j = 0; j < number_of_char; j++)
		{
			to_copy1[j] = scheduler[i - number_of_char + j];
		}
		multiplier_file_to_load = (int) strtol(to_copy1, NULL, 10);
		i = i + 2;
		
		/* Multiplier 2 */
		number_of_char = 0;
		while (scheduler[i] != '_')
		{
			//~ printf("2: ++ with %c\n", scheduler[i]);
			i += 1;
			number_of_char += 1;
		}
		char to_copy2[number_of_char];
		for (j = 0; j < number_of_char; j++)
		{
			to_copy2[j] = scheduler[i - number_of_char + j];
		}
		multiplier_file_evicted = (int) strtol(to_copy2, NULL, 10);
		i = i + 2;
				
		/* Multiplier 3 */
		number_of_char = 0;
		while (scheduler[i] != '_')
		{
			//~ printf("3: ++ with %c\n", scheduler[i]);
			i += 1;
			number_of_char += 1;
		}
		char to_copy3[number_of_char];
		for (j = 0; j < number_of_char; j++)
		{
			to_copy3[j] = scheduler[i - number_of_char + j];
		}
		multiplier_nb_copy = (int) strtol(to_copy3, NULL, 10);
		i = i + 2;
				
		/* Multiplier 4 */
		number_of_char = 0;
		while (scheduler[i])
		{
			//~ printf("4: ++ with %c\n", scheduler[i]);
			i += 1;
			number_of_char += 1;
		}
		char to_copy4[number_of_char];
		for (j = 0; j < number_of_char; j++)
		{
			to_copy4[j] = scheduler[i - number_of_char + j];
		}
		multiplier_area_bigger_nodes = (int) strtol(to_copy4, NULL, 10);
						
		printf("Multiplier file to load: %d / Multiplier file evicted: %d / Multiplier nb of copy: %d / Multiplier area bigger nodes: %d / Adaptative multiplier : %d / Penalty on sizes : %d / Start immeditaly if EAT is t: %d / Mixed strategy: %d.\n", multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, multiplier_area_bigger_nodes, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t, mixed_strategy);
		
		/* Error I have sometimes when the int is not what I putted */
		if (multiplier_file_to_load > 500 || multiplier_file_evicted > 500 || multiplier_nb_copy > 500 || multiplier_area_bigger_nodes > 500)
		{
			printf("############################## Error multiplier. 500, 1, 0, 0 affected. ##############################\n");
			multiplier_file_to_load = 500;
			multiplier_file_evicted = 1;
			multiplier_nb_copy = 0;
			multiplier_area_bigger_nodes = 0;
		}
	}
	#endif
	
	/* Récupération du pourcentage à partir duquel on est sur un cluster occupé. */
	busy_cluster_threshold = atoi(argv[7]);
	
	#ifndef ENERGY_INCENTIVE
	int division_by_planned_area = 0;
	
	if (strncmp(scheduler, "Fcfs_area_filling", 17) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_omniscient_planned_area_x", 60) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_planned_area_x", 49) == 0)
	{
		if (strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_omniscient_planned_area_x", 60) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_planned_area_x", 49) == 0)
		{
			division_by_planned_area = 1;
		}

		FILE *f = NULL;
		char s1[30];
		char s2[30];
		char s3[30];
		char s4[30];
		int i = 0;
		
		char* file_to_open = malloc(100*sizeof(char));
		
		/* Getting cluster */
		char subbuff_cluster[30];
		memcpy(subbuff_cluster, &input_node_file[24], 29);
		printf("Cluster is %s\n", subbuff_cluster);
		
		/* Getting workload */
		int taille_workload = strlen(input_job_file);
		int taille_subbuf = 0;
		printf("Taille nom du workload: %d.\n", taille_workload);
		if (taille_workload == 34) //inputs/workloads/converted/test-11
		{
			taille_subbuf = 7;
		}
		else if (taille_workload == 49) // Cas classique sans rien après le nom du workload
		{
			taille_subbuf = 22;
		}
		else if (taille_workload == 55) // Cas 9271
		{
			taille_subbuf = 28;
		}
		else if (taille_workload == 56) // Cas 90100
		{
			taille_subbuf = 29;
		}
		else if (taille_workload == 57) // Cas 502525
		{
			taille_subbuf = 30;
		}
		else
		{
			printf("Mauvais nom de cluster.\n");
			exit(EXIT_FAILURE);
		}
		char* subbuff_workload = malloc(sizeof(char)*(taille_subbuf));
		//~ char subbuff_workload[taille_subbuf + 1];
		memcpy(subbuff_workload, &input_job_file[27], taille_subbuf);
		printf("taille_subbuf is %d\n", taille_subbuf);
		//~ subbuff_workload[taille_subbuf] = '_';
		printf("Workload is %s\n", subbuff_workload);

		/* Normal case */
		if (strcmp(scheduler, "Fcfs_area_filling") == 0 || strcmp(scheduler, "Fcfs_area_filling_omniscient") == 0 || strncmp(scheduler, "Fcfs_area_filling_with_a_score_x", 32) == 0 || strncmp(scheduler, "Fcfs_area_filling_omniscient_with_a_score_x", 43) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_omniscient_planned_area_x", 60) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_planned_area_x", 49) == 0)
		{
			strcpy(file_to_open, "inputs/Planned_Ratio_areas/Planned_area_");
		}
		else /* Ratio case */
		{
			planned_or_ratio = 1;
			strcpy(file_to_open, "inputs/PlaFcfs_with_a_score_conservativebf_xnned_Ratio_areas/Ratio_area_");
		}
		
		/* Bigger trace for ratio because we can, it's just a ratio. For the omniscient however we take the good one. */
		if (strcmp(scheduler, "Fcfs_area_filling_with_ratio") != 0 && strncmp(scheduler, "Fcfs_area_filling_with_ratio_with_a_score_x", 43) != 0)
		{
			strcat(file_to_open, subbuff_workload);
			strcat(file_to_open, "_");
		}
		else /* There is a case of area_filling_with_ratio_7_days_earlier as well, it goes in the if */
		{
			strcat(file_to_open, "2021-10-02->2021-10-30_");
			char* subbuff_workload_2 = malloc(sizeof(char)*(taille_subbuf+1));
			memcpy(subbuff_workload_2, &input_job_file[50], taille_subbuf);
			strcat(file_to_open, subbuff_workload_2);
			free(subbuff_workload_2);
			strcat(file_to_open, "_");
		}
		
		free(subbuff_workload);
		
		/* Non omniscient case take 7 days earlier. */
		if (strcmp(scheduler, "Fcfs_area_filling") == 0 || strcmp(scheduler, "Fcfs_area_filling_with_ratio_7_days_earlier") == 0 || strncmp(scheduler, "Fcfs_area_filling_with_ratio_7_days_earlier_with_a_score_x", 58) == 0 || strncmp(scheduler, "Fcfs_area_filling_with_a_score_x", 32) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_planned_area_x", 49) == 0)
		{
			strcat(file_to_open, "7_days_earlier_");
		}
		strcat(file_to_open, subbuff_cluster);

		printf("Opening file: %s\n", file_to_open);
		f = fopen(file_to_open, "r");
		if (!f)
		{
			perror("fopen error in area filling.\n");
			exit(EXIT_FAILURE);
		}
		free(file_to_open);
		
		if (strcmp(scheduler, "Fcfs_area_filling") == 0 || strcmp(scheduler, "Fcfs_area_filling_omniscient") == 0 || strncmp(scheduler, "Fcfs_area_filling_with_a_score_x", 32) == 0 || strncmp(scheduler, "Fcfs_area_filling_omniscient_with_a_score_x", 43) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_omniscient_planned_area_x", 60) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_planned_area_x", 49) == 0)
		{
			while (fscanf(f, "%s %s %s %s", s1, s2, s3, s4) == 4)
			{
				Planned_Area[i][0] = atoll(s2);
				Planned_Area[i][1] = atoll(s3);
				Planned_Area[i][2] = atoll(s4);
				printf("Planned areas %d: %lld %lld %lld\n", i, Planned_Area[i][0], Planned_Area[i][1], Planned_Area[i][2]);
				i += 1;
			}
		}
		else
		{
			for (int ii = 0; ii < 3; ii++)
			{
				for (int iii = 0; iii < 3; iii++)
				{
					Allocated_Area[ii][iii] = 0;
				}
			}
			while (fscanf(f, "%s %s %s %s", s1, s2, s3, s4) == 4)
			{
				Ratio_Area[i][0] = atof(s2);
				Ratio_Area[i][1] = atof(s3);
				Ratio_Area[i][2] = atof(s4);
				printf("Ratio areas %d: %f %f %f\n", i, Ratio_Area[i][0], Ratio_Area[i][1], Ratio_Area[i][2]);
				i += 1;
			}
		}
		fclose(f);
	}
	
	if (strncmp(scheduler, "Fcfs_backfill_big_nodes_", 24) == 0)
	{
		/* 0 = don't compute anything, 1 = compute mean queue time */
		backfill_big_node_mode = scheduler[24] - '0';
		printf("Backfill big nodes mode is %d.\n", backfill_big_node_mode);
	}
	
	/** No use bigger nodes for some fcfs variants. **/
	if (strcmp(scheduler, "Fcfs_no_use_bigger_nodes") == 0 || strcmp(scheduler, "Fcfs_no_use_bigger_nodes_easybf") == 0)
	{
		use_bigger_nodes = false;
	}

	bool new_jobs = false;
	
	/* For the schedulers dealing with size constraint I need to sort scheduled_job_list by file size (biggest to smallest) now but
	 * also do it when new jobs are added to scheduled_job_list. */
	bool sort_by_file_size = false;
	
	if (
	(strcmp(scheduler, "Fcfs_big_job_first") == 0) || (strcmp(scheduler, "Fcfs_backfill_big_nodes_0_big_job_first") == 0) || (strcmp(scheduler, "Fcfs_backfill_big_nodes_1_big_job_first") == 0) || (strcmp(scheduler, "Fcfs_area_filling_big_job_first") == 0) || (strcmp(scheduler, "Fcfs_area_filling_with_ratio_big_job_first") == 0) || (strcmp(scheduler, "Fcfs_area_filling_omniscient_big_job_first") == 0) || (strcmp(scheduler, "Fcfs_area_filling_omniscient_with_ratio_big_job_first") == 0))
	{
		printf("Sorting job list by file's size.\n");
		
		/* To sort by file size for certain schedulers. */
		sort_by_file_size = true;
		sort_job_list_by_file_size(&scheduled_job_list->head);
		
		#ifdef PRINT
		printf("Job list after sort byt file's size:\n");
		print_job_list(scheduled_job_list->head);
		#endif
	}
	#endif

	/* Besoin de calculer le nombre de nodes dans chaque catégorie pour certains algos. */
	int number_node_size_128_and_more = 0;
	int number_node_size_256_and_more = 0;
	int number_node_size_1024 = 0;
	if (strncmp(scheduler, "Fcfs_with_a_score_backfill_big_nodes_95th_percentile_x", 54) == 0)
	{
		for (i = 0; i <= 2; i++)
		{
			struct Node* n = node_list[i]->head;
			while (n != NULL)
			{
				number_node_size_128_and_more += 1;
				if (i == 1)
				{
					number_node_size_256_and_more += 1;
				}
				else if (i == 2)
				{
					number_node_size_256_and_more += 1;
					number_node_size_1024 += 1;
				}
				n = n->next;
			}
		}
		printf("There are %d nodes of size 128 and more, %d of size 256 and more, %d of size 1024.\n", number_node_size_128_and_more, number_node_size_256_and_more, number_node_size_1024);
	}
	
	//~ printf("Backfill mode is %d.\n", backfill_mode);
	
	
	#ifdef SAVE
	if (need_to_resume_state == true)
	{
		//~ printf("T = %d\n", t); fflush(stdout);
		need_to_resume_state = false;
		resume_state(&t, &old_finished_jobs, &next_submit_time, input_job_file);
		//~ printf("next end = %d\n", end_times->head->time); fflush(stdout);
				old_finished_jobs = finished_jobs;
		if (end_times->head != NULL && end_times->head->time == t)
		{
			end_jobs(running_jobs->head, t);
		}

		
			reset_cores(node_list, t);
			
			/* Reset planned starting times. */
			free_next_time_linked_list(&start_times->head);
						
			#ifdef PRINT
			printf("Reschedule.\n");
			#endif
			
			call_scheduler(scheduler, scheduled_job_list, t, use_bigger_nodes, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t, backfill_mode, number_node_size_128_and_more, number_node_size_256_and_more, number_node_size_1024, Ratio_Area, multiplier_area_bigger_nodes, division_by_planned_area, backfill_big_node_mode, mixed_strategy);
							
			#ifdef PRINT	
			printf("End of reschedule.\n");
			#endif
			
			/* Get started jobs. */
			if (start_times->head != NULL)
			{
				if (start_times->head->time == t)
				{
					start_jobs(t, scheduled_job_list->head);
				}
			}
	}
	#endif
		
	/** START OF SIMULATION **/
	printf("Start simulation.\n"); fflush(stdout);
	
	nb_call_finished_jobs = 0;
	nb_call_new_jobs = 0;
	
	#ifndef ENERGY_INCENTIVE
	int last_scheduler_call = t;
	#endif
	
	/** START ENERGY INCENTIVE **/
	#ifdef ENERGY_INCENTIVE
	int nusers = atoi(argv[8]);
	printf("There are %d users.\n", nusers);
	double max_watt_hour = 0; /* Max watt-hour the machine can use */
	
	/* Number of times I want to repeat the same workload */
	//~ int number_workload_repetition = 150*64; /* Good for 8 functions 1 core max */
	int number_workload_repetition = 1;
	//~ int number_workload_repetition = 3;
	
	double credit_to_each_user = 0;
	bool is_credit = true;
	if (strcmp(argv[10], "credit") == 0)
	{
		credit_to_each_user = 12000000;
	}
	else if (strcmp(argv[10], "carbon") == 0)
	{
		is_credit = false;
		credit_to_each_user = 12000000;
	}
	else
	{
		printf("Wrong credit value in 10th argument\n");
		exit(1);
	}
	
	/* Credit of each user in watt-hours */
	double credit_users[nusers];
	for (i = 0; i < nusers; i++)
	{
		credit_users[i] = credit_to_each_user;
	}
	
	double** next_available_time_endpoint = (double**) malloc(nusers*sizeof(double*)); //largeur /* next available time of the machine. I consider that all cores must be available as the functions sue as many threads as there are cores. */
	for (i = 0; i < nusers; i++)
	{
		next_available_time_endpoint[i] = malloc(total_number_nodes*sizeof(double)); //largeur
	}
	for (i = 0; i < nusers; i++)
	{
		for (j = 0; j < total_number_nodes; j++)
		{
			next_available_time_endpoint[i][j] = 0;
		}
	}

	//~ printf("Get association of each of the %d jobs energy consumption and credit for each of the %d machines\n", total_number_jobs, total_number_nodes);
	//~ int** tab_function_machine_calibration = (int**) malloc(total_number_jobs*sizeof(int*)); /* Has the calibration been done on this function-machine association? */
	double** tab_function_machine_energy = (double**) malloc(total_number_jobs*sizeof(double*)); //hauteur
	double** tab_function_machine_credit = (double**) malloc(total_number_jobs*sizeof(double*)); //hauteur
	job_pointer = job_list->head;
	for (i = 0; i < total_number_jobs; i++)
	{
		//~ tab_function_machine_calibration[i] = malloc(total_number_nodes*sizeof(int)); //largeur
		tab_function_machine_energy[i] = malloc(total_number_nodes*sizeof(double)); //largeur
		tab_function_machine_credit[i] = malloc(total_number_nodes*sizeof(double)); //largeur
		struct Node* n = node_list[0]->head;
		for (j = 0; j < total_number_nodes; j++)
		{
			if ((strcmp(argv[9], "alok") == 0) && (job_pointer->cores > n->ncores*n->ncpu)) /* If the job requires too many core, we put -1 in tab_function_machine_energy to signifie that this association is not possible. We then use tab_function_machine_energy when selecting the endpoint to avoid choosing an impossible combination. */
			{
				//~ printf("%d > %d\n", job_pointer->cores, n->ncores*n->ncpu);
				tab_function_machine_energy[i][j] = -1;
			}
			else
			{
				/* Filling the values for job i on endpoint j */
				if (strcmp(argv[9], "alok") == 0)
				{
					tab_function_machine_energy[i][j] = ((job_pointer->energy_on_machine[j]*0.000001)/3600)*job_pointer->cores + n->idle_power*(job_pointer->duration_on_machine[j]/3600)*job_pointer->number_of_nodes[j]; /* Energy in micro joules that I convert to joule then divide by 3600 to get watt-hours and multiply by the number of cores used by the job + energy of the start up (idle power) but converted to the right duration */
					max_watt_hour = n->tdp*n->ncpu*(job_pointer->duration_on_machine[j]/3600); /* max watt-hour of the machine on the given duration. Calculated as NCPU times CPU TDP times job duration on the machine in hours */
				}
				else /* Meggie and Emmy */
				{
					tab_function_machine_energy[i][j] = job_pointer->energy_on_machine[j]/3600; /* For meggie and emmy databse the energy is already computed like needed, just need to switch it to watt-hours */
					//~ printf("%f %d %f %f %f\n", job_pointer->energy_on_machine[j], job_pointer->cores, n->idle_power, job_pointer->duration_on_machine[j], job_pointer->number_of_nodes[j]);
					max_watt_hour = n->tdp*n->ncpu*job_pointer->number_of_nodes[j]*(job_pointer->duration_on_machine[j]/3600); /* max watt-hour of the machine on the given duration. Calculated as NCPU times Nnodes times CPU TDP times job duration on the machine in hours */
				}
				
				if (is_credit == true)
				{
					tab_function_machine_credit[i][j] = (tab_function_machine_energy[i][j] + max_watt_hour)/2; /* credit that would be used with this combination. */
				}
				else
				{
					tab_function_machine_credit[i][j] = ((tab_function_machine_energy[i][j] + max_watt_hour)/2)*((n->carbon_intensity + n->carbon_rate)/1000); /* Carbon credit. Divided by 1000 because the value were in kwh */
					printf("%f[%d][%d] = (%f + %f)/2 x (%f + %f)/1000\n", tab_function_machine_credit[i][j], i, j, tab_function_machine_energy[i][j], max_watt_hour, n->carbon_intensity, n->carbon_rate);
				}
					
				//~ printf("Job %d on machine %d: %f Watt-hours %f max_watt_hour - %f seconds - %f credit removed %d cores\n", i, j, tab_function_machine_energy[i][j], max_watt_hour, job_pointer->duration_on_machine[j], tab_function_machine_credit[i][j], job_pointer->cores);
			}
			n = n->next;
		}

		job_pointer = job_pointer->next;
	}
	
	/* Assigning an endpoint to each job depending on his user's behavior */
	int selected_endpoint = 0;
	i = 0;
	
	while (i < number_workload_repetition) /* To loop on the workload until one or more user exhaust is credit */
	{
		job_pointer = job_list->head;
		while (job_pointer != NULL)
		{
			//~ printf("Job %d - user behavior %d\n", job_pointer->unique_id, job_pointer->user_behavior); fflush(stdout);
			
			selected_endpoint = endpoint_selection(job_pointer->unique_id, job_pointer->user_behavior, tab_function_machine_credit, total_number_nodes, tab_function_machine_energy, job_pointer->duration_on_machine, next_available_time_endpoint);
						
			//~ printf("Credit to remove is %f\n", tab_function_machine_credit[job_pointer->unique_id][selected_endpoint]);
			update_credit(job_pointer->unique_id, &credit_users[job_pointer->user_behavior], tab_function_machine_credit[job_pointer->unique_id][selected_endpoint]);
			//~ printf("Credit is now %f\n", credit_users[job_pointer->user_behavior]);
			
			/* Adding result to the To_Print structure used later to print results into a file. I do that cause it's faster than opening/closing the file each time. */
			struct To_Print* new = (struct To_Print*) malloc(sizeof(struct To_Print));
			new->next = NULL;
			new->job_unique_id = job_pointer->unique_id;				
			new->user_behavior = job_pointer->user_behavior;
			new->selected_endpoint = selected_endpoint;
			new->removed_credit = tab_function_machine_credit[job_pointer->unique_id][selected_endpoint];
			new->new_credit	= credit_users[job_pointer->user_behavior];		
			new->job_end_time_double = next_available_time_endpoint[job_pointer->user_behavior][selected_endpoint] + job_pointer->duration_on_machine[selected_endpoint]; /* Considering the next available time of the machine, when will the job will end running it on this endpoint? We dissociate users here, consider that only one is using the system at a time. They are not competing. */
			new->energy_used_watt_hours = tab_function_machine_energy[job_pointer->unique_id][selected_endpoint];
			new->core_hours_used = job_pointer->cores*(job_pointer->duration_on_machine[selected_endpoint]/3600);
			new->queue_time = next_available_time_endpoint[job_pointer->user_behavior][selected_endpoint] - job_pointer->subtime;
			new->job_cores = job_pointer->cores;
			
			for(j = 0; j < total_number_nodes; j++)
			{
				new->mean_duration_on_machine += job_pointer->duration_on_machine[j];
			}
			new->mean_duration_on_machine = new->mean_duration_on_machine/total_number_nodes;
			
			if (tab_function_machine_energy[job_pointer->unique_id][selected_endpoint] < 0)
			{
				printf("WTF energy %f job %d endpoint %d\n", tab_function_machine_energy[job_pointer->unique_id][selected_endpoint], job_pointer->unique_id, selected_endpoint);
				exit(1);
			}
			
			insert_tail_to_print_list(jobs_to_print_list, new);
			
			/* Update the next available time of the machine (same way we assigned a value to new->job_end_time */
			next_available_time_endpoint[job_pointer->user_behavior][selected_endpoint] += job_pointer->duration_on_machine[selected_endpoint];
			
			job_pointer = job_pointer->next;
		}
		i++;
	}
	print_csv_energy_incentive(jobs_to_print_list->head, nusers);
	#else
	/** END ENERGY INCENTIVE **/
	
	//~ #ifdef PRINT_CLUSTER_USAGE
	//~ while (finished_jobs != total_number_jobs)
	//~ while (finished_jobs != 50000)
	//~ #else
	while (nb_job_to_evaluate != nb_job_to_evaluate_started)
	//~ #endif
	{
		//~ if (finished_jobs >= 5001) { printf("next end = %d new_jobs: %d\n", end_times->head->time, new_jobs); fflush(stdout); exit(1); }
		#ifdef SAVE
		//~ /* Test pour save l'état et recommencer */
		// if (need_to_save_state == true && t >= time_to_save) /* Avec le temps */
		if (need_to_save_state == true && finished_jobs >= time_to_save) /* Avec le nb de jobs terminés */
		{
			//~ printf("T = %d\n", t); fflush(stdout);
			#ifdef PLOT_SATS
			printf("Cas pas géré #ifdef PLOT_SATS avec asave_state\n");
			exit(1);
			#endif
			save_state(t, old_finished_jobs, next_submit_time, input_job_file);
			exit(1);
		}
		#endif
						
		/* Get ended job. */
		old_finished_jobs = finished_jobs;
		if (end_times->head != NULL && end_times->head->time == t)
		{
			end_jobs(running_jobs->head, t);
		}
		
		/* Get started jobs. */
		if (start_times->head != NULL)
		{
			if (start_times->head->time == t)
			{
				start_jobs(t, scheduled_job_list->head);
			}
		}
				
		//~ if ((running_nodes*100)/486 >= busy_cluster_threshold)
		//~ {
			//~ busy_cluster = 1;
		//~ }
		//~ else
		//~ {
			//~ busy_cluster = 0;
		//~ }
		//~ printf("t = %d\n", t); fflush(stdout);
		new_jobs = false;
		/* Get the set of available jobs at time t */
		/* Jobs are already sorted by subtime so I can simply stop with a break */
		if (next_submit_time == t) /* We have new jobs need to schedule them. */
		{
			new_jobs = true;
			
			//~ #ifdef PRINT
			printf("We have new jobs at time %d.\n", t);
			//~ #endif
			
			/* Copy in scheduled_job_list jobs and delete from job_list. */
			job_pointer = job_list->head;
			while (job_pointer != NULL)
			{
				if (job_pointer->subtime <= t)
				{
					#ifdef PRINT
					printf("New job %d.\n", job_pointer->unique_id);
					#endif
					
					/* Update nb of jobs to schedule (not running but available) */
					nb_job_to_schedule += 1;
					nb_cores_to_schedule += job_pointer->cores;
					
					temp = job_pointer->next;
					if (sort_by_file_size == true)
					{
						if (old_finished_jobs == finished_jobs) /* Que des nouveaux jobs, donc liste séparé */
						{
							#ifdef PRINT
							printf("Copy in new job list\n");
							#endif
							
							copy_delete_insert_job_list_sorted_by_file_size(job_list, new_job_list, job_pointer);
						}
						else /* Il y a aussi eu des libérations, je met tout dans scheduled_job_list */
						{
							copy_delete_insert_job_list_sorted_by_file_size(job_list, scheduled_job_list, job_pointer);
						}
					}
					else
					{
						if (old_finished_jobs == finished_jobs) /* Que des nouveaux jobs, donc liste séparé */
						{
							#ifdef PRINT
							printf("Copy in new job list\n");
							#endif
							
							copy_delete_insert_job_list(job_list, new_job_list, job_pointer);
						}
						else /* Il y a aussi eu des libérations, je met tout dans scheduled_job_list */
						{
							copy_delete_insert_job_list(job_list, scheduled_job_list, job_pointer);
						}
					}
					job_pointer = temp;
				}
				else
				{
					break;
				}
			}
							
			if (job_pointer != NULL)
			{
				next_submit_time = job_pointer->subtime;
			}
			else
			{
				next_submit_time = -1;
			}
		}
		
		if (last_scheduler_call <= t) /* Version ou j'attends X secondes avant de re schedule */
		//~ if (last_scheduler_call <= t - 10) /* Version ou j'attends X secondes avant de re schedule */
		//~ if (last_scheduler_call <= t - 30) /* Version ou j'attends X secondes avant de re schedule */
		//~ if (last_scheduler_call <= t - 300) /* Version ou j'attends X secondes avant de re schedule */
		{
		last_scheduler_call = t;
		
		/* ) && scheduled_job_list->head != NULL est très utile, car certain scheduler comme ceux de easy bf ne boucle pas tant que head_job != NULL et peuevnt donc commencer avec un job qui vaut nul (pour j1 de easy bf par xempe. Donc à arder au mons pour easy bf et peut etre d'autres. */
		if (old_finished_jobs < finished_jobs && scheduled_job_list->head != NULL) /* Vrai version */
		//~ if (old_finished_jobs < finished_jobs - 1000 && scheduled_job_list->head != NULL) /* Version ou j'attrends X jobs */
		{
			
			#ifdef PRINT
			printf("Core(s) liberated. Need to free them.\n"); fflush(stdout);
			#endif
			
			/* Reset all cores and jobs. */
			reset_cores(node_list, t);
			
			/* Reset planned starting times. */
			free_next_time_linked_list(&start_times->head);
						
			#ifdef PRINT
			printf("Reschedule.\n");
			#endif
			
			call_scheduler(scheduler, scheduled_job_list, t, use_bigger_nodes, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t, backfill_mode, number_node_size_128_and_more, number_node_size_256_and_more, number_node_size_1024, Ratio_Area, multiplier_area_bigger_nodes, division_by_planned_area, backfill_big_node_mode, mixed_strategy);
							
			#ifdef PRINT	
			printf("End of reschedule.\n");
			#endif
			
			/* Get started jobs. */
			if (start_times->head != NULL)
			{
				if (start_times->head->time == t)
				{
					start_jobs(t, scheduled_job_list->head);
				}
			}
		}
		else if (new_jobs == true) /* Pas de jobs fini mais des nouveaux jobs à schedule. */
		{
			//~ nb_call_new_jobs++;
			
			#ifdef PRINT
			printf("Schedule only new jobs.\n");
			#endif
			
			call_scheduler(scheduler, new_job_list, t, use_bigger_nodes, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t, backfill_mode, number_node_size_128_and_more, number_node_size_256_and_more, number_node_size_1024, Ratio_Area, multiplier_area_bigger_nodes, division_by_planned_area, backfill_big_node_mode, mixed_strategy);

			job_pointer = new_job_list->head;
			if (sort_by_file_size == true)
			{
				while (job_pointer != NULL)
				{
					temp = job_pointer->next;
					/* Copie des jobs de new job list dans scheduled job list */
					copy_delete_insert_job_list_sorted_by_file_size(new_job_list, scheduled_job_list, job_pointer);
					job_pointer = temp;
				}
			}
			else
			{
				while (job_pointer != NULL)
				{
					temp = job_pointer->next;
					/* Copie des jobs de new job list dans scheduled job list */
					copy_delete_insert_job_list(new_job_list, scheduled_job_list, job_pointer);
					job_pointer = temp;
				}	
			}
			
			/* Get started jobs. */
			if (start_times->head != NULL)
			{
				if (start_times->head->time == t)
				{
					start_jobs(t, scheduled_job_list->head);
				}
			}
		}
		
		}
						
		#ifdef PRINT_CLUSTER_USAGE
		get_length_job_list(scheduled_job_list->head, &nb_jobs_in_queue, &nb_cores_in_queue, &nb_cores_from_workload_1_in_queue);
				
		get_nb_nodes_and_cores_loading_a_file(node_list, t, &nodes_loading_a_file, &cores_loading_a_file);
		
		fprintf(f_stats, "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n", t, running_cores, running_nodes*20, nb_jobs_in_queue, running_nodes_workload_1*20, nb_cores_in_queue + 486*20, nb_cores_from_workload_1_in_queue + 486*20, nodes_loading_a_file*20, running_cores_from_workload_1, cores_loading_a_file);		
		#endif
				
		if (start_times->head != NULL && t > start_times->head->time)
		{
			printf("ERROR in main.c, next start time is %d and t is %d.\n", start_times->head->time, t); fflush(stdout);
			exit(EXIT_FAILURE);
		}
		
		/* Time is advancing. */
		t += 1;
		
		//~ if (need_to_save_state == true && finished_jobs >= time_to_save) /* Avec le nb de jobs terminés */
		//~ {
			//~ printf("T = %d\n", t); fflush(stdout);
			//~ #ifdef PLOT_SATS
			//~ printf("Cas pas géré #ifdef PLOT_SATS avec asave_state\n");
			//~ exit(1);
			//~ #endif
			//~ save_state(t, old_finished_jobs, next_submit_time, input_job_file);
			//~ exit(1);
		//~ }
		
		/* Je dépasse les int max ? */
		//~ if (t > 2000000000)
		//~ {
			//~ printf("Risque de dépasser les int max t = %d.\n", t);
			//~ exit(EXIT_FAILURE);
		//~ }
	}
	
	#ifdef PRINT_CLUSTER_USAGE
	fclose(f_stats);
	//~ fclose(f_reduced_stats);
	#endif
		
	/* NEW */
	/* Delete all running and scheduled jobs */
	job_pointer = running_jobs->head;
	while (job_pointer != NULL)
	{
		struct Job* temp = job_pointer->next;
		delete_job_linked_list(running_jobs, job_pointer->unique_id);
		job_pointer = temp;
	}
	job_pointer = scheduled_job_list->head;
	while (job_pointer != NULL)
	{
		struct Job* temp = job_pointer->next;
		delete_job_linked_list(scheduled_job_list, job_pointer->unique_id);
		job_pointer = temp;
	}

	
	printf("\nComputing and writing results...\n");
	print_csv(jobs_to_print_list->head);
	#endif /* endif du ifdef ENERGY_INCENTIVE */
	
	printf("Finished simulation.\n");
	return 1;
}
