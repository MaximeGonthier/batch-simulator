//~ #define PRINT
//~ #define PRINT_GANTT_CHART
//~ #define PRINT_DISTRIBUTION_QUEUE_TIMES
//~ #define PRINT_CLUSTER_USAGE
//~ #define PRINT_SCORES_DATA

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

/* Global variables */
extern int constraint_on_sizes;
extern int nb_cores;
extern int nb_job_to_evaluate;
extern int finished_jobs;
extern int total_number_jobs;
extern int total_number_nodes;
extern struct Job_List* job_list; /* All jobs not available yet */
extern struct Job_List* new_job_list; /* New available jobs */
extern struct Job_List* job_list_to_start_from_history; /* With -2 and before start */
extern struct Job_List* scheduled_job_list; /* Scheduled or available */
extern struct Job_List* running_jobs; /* Started */
extern struct Node_List** node_list;
extern struct To_Print_List* jobs_to_print_list;
extern int running_cores;
extern int running_nodes;
extern int total_queue_time;
extern int first_subtime_day_0;
extern char* scheduler;

/* For area_filling. This is the allocated area updated in start jobs. It corresponds to the area of jobs of size x that
 * were started on nodes of size x+y, y>0. I use it as a global variable to update it in start_jobs. In the schedule of
 * area flling I use a temp tab at the beggining of the schedule that copy the values of this global variable
 * because the schedule can change later on with liberated cores.
 */
extern long long Allocated_Area[3][3];

/* To only call these functions when I need it. */
extern struct Next_Time_List* end_times;
extern struct Next_Time_List* start_times; /* TODO try to do that with update at each new scheduled job and reset when reset jobs and reschedule */

//~ int nb_job_to_evaluate_finished;
extern int nb_job_to_evaluate_started;

/* For fcfs with a score. Allow me to not compute multiple time the same amount of copy of a file at a certain time when computing the amount of copy. I also use it to see if a data was already checked in the reduced complexity version. */
struct Time_or_Data_Already_Checked_Nb_of_Copy_List {
	struct Time_or_Data_Already_Checked_Nb_of_Copy* head;
};
struct Time_or_Data_Already_Checked_Nb_of_Copy {
	struct Time_or_Data_Already_Checked_Nb_of_Copy* next;
	int time_or_data;
	int nb_of_copy;
};

struct Next_Time_List {
	struct Next_Time* head;
};

struct Next_Time {
	struct Next_Time* next;
	int time;
};

struct Job_List {
	struct Job* head;
	struct Job* tail;
};

struct Node_List {
	//~ int number_of_node;
	struct Node* head;
	struct Node* tail;
};

struct Data_List {
	struct Data* head;
	struct Data* tail;
};

struct Job {
	struct Job* next;
	int unique_id;
    int subtime;
    int delay;
    int walltime;
    int cores;
    int data;
    float data_size;
    int index_node_list;
    int start_time;
    int end_time;
    bool end_before_walltime;
    struct Node* node_used;
    int* cores_used; /* list */
    //~ struct Core** cores_used; /* Need it ? */
    int transfer_time;
    int waiting_for_a_load_time;
    int workload;
    int start_time_from_history;
    int node_from_history;
};

struct Node {
	struct Node* next;
    int unique_id;
    int memory;
    float bandwidth;
    struct Data_List* data;
    struct Core** cores;
    int n_available_cores;
    int index_node_list;
};

struct Data {
	struct Data* next;
    int unique_id;
    int start_time;
    int end_time;
    int nb_task_using_it;
    struct Interval_List* intervals;
    int size;
};

struct Core {
    int unique_id;
    //~ struct Job_List* job_queue; /* TODO maybe need it ? If yes put it in both read functions */
    int available_time;
    bool running_job;
    int running_job_end;
};

struct To_Print_List {
	struct To_Print* head;
	struct To_Print* tail;
};

struct To_Print {
	struct To_Print* next;
	int job_unique_id;
    int job_subtime;
    int time;
    int time_used;
    int transfer_time;
    int job_start_time;
    int job_end_time;
    int job_cores;
    int waiting_for_a_load_time;
    float empty_cluster_time;
    int data_type;
    int upgraded; /* Was it on bigger nodes ? 0 or 1 */
};

struct Interval_List {
	struct Interval* head;
	struct Interval* tail;
};

struct Interval {
	struct Interval* next;
	int time;
};

/* From read_input_files.c */
void read_cluster(char* input_node_file);
void read_workload(char* input_job_file, int constraint_on_sizes);
int get_nb_job_to_evaluate(struct Job* l);
int get_first_time_day_0(struct Job* l);
int get_first_times_all_day(struct Job* l);
void write_in_file_first_times_all_day(struct Job* l, int first_subtime_day_0);

/* From print_functions.c */
void print_node_list(struct Node_List** list);
void print_job_list(struct Job* list);
void print_single_node(struct Node* n);
void print_decision_in_scheduler(struct Job* j);
void print_cores_in_specific_node(struct Node* n);
void print_time_list(struct Next_Time* list, int end_or_start);
void to_print_job_csv(struct Job* job, int time);
void print_csv(struct To_Print* head_to_print);
void print_data_intervals(struct Node_List** list, int t);

/* From basic_functions.c */
void schedule_job_specific_node_at_earliest_available_time(struct Job* j, struct Node* n, int t);
void start_jobs(int t, struct Job* scheduled);
void end_jobs(struct Job* job_list_head, int t);
void add_data_in_node (int data_unique_id, int data_size, struct Node* node_used, int t, int end_time, int* transfer_time, int* waiting_for_a_load_time);
int get_nb_non_available_cores(struct Node_List** n, int t);
//~ int get_nb_running_cores(struct Node_List** n, int t);
int schedule_job_on_earliest_available_cores(struct Job* j, struct Node_List** head_node, int t, int nb_non_available_cores, bool use_bigger_nodes);
void reset_cores(struct Node_List** l, int t);
void remove_data_from_node(struct Job* j, int t);
void get_current_intervals(struct Node_List** head_node, int t);
int is_my_file_on_node_at_certain_time_and_transfer_time(int predicted_time, struct Node* n, int t, int current_data, int current_data_size, bool* is_being_loaded);
float time_to_reload_percentage_of_files_ended_at_certain_time(int predicted_time, struct Node* n, int current_data, int percentage_occupied);
int get_nb_valid_copy_of_a_file(int predicted_time, struct Node_List** head_node, int current_data);
int was_time_or_data_already_checked_for_nb_copy(int t_or_d, struct Time_or_Data_Already_Checked_Nb_of_Copy_List* list);
int schedule_job_to_start_immediatly_on_specific_node_size(struct Job* j, struct Node_List* head_node_size_i, int t, int backfill_big_node_mode, int total_queue_time, int nb_finished_jobs, int nb_non_available_cores, bool* result);
int schedule_job_on_earliest_available_cores_specific_sublist_node(struct Job* j, struct Node_List* head_node_size_i, int t, int nb_non_available_cores);
int get_earliest_available_time_specific_sublist_node(int nb_cores_asked, struct Node_List* head_node_size_i, struct Node** choosen_node, int t);
int try_to_start_job_immediatly_without_delaying_j1(struct Job* j, struct Job* j1, struct Node_List** head_node, int nb_running_cores, bool* result, bool use_bigger_nodes, int t);
int schedule_job_on_earliest_available_cores_return_running_cores(struct Job* j, struct Node_List** head_node, int t, int nb_running_cores, bool use_bigger_nodes);
int try_to_start_job_immediatly_fcfs_score_without_delaying_j1(struct Job* j, struct Job* j1, struct Node_List** head_node, int nb_running_cores, bool* result, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy);
int schedule_job_fcfs_score_return_running_cores(struct Job* j, struct Node_List** head_node, int t, int nb_running_cores, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy);

/* From linked_list_functions.c */
void insert_head_job_list(struct Job_List* liste, struct Job* j);
void insert_tail_job_list(struct Job_List* liste, struct Job* j);
void insert_tail_node_list(struct Node_List* liste, struct Node* n);
void insert_tail_data_list(struct Data_List* liste, struct Data* d);
void delete_job_linked_list(struct Job_List* liste, int unique_id_to_delete);
void copy_delete_insert_job_list(struct Job_List* to_delete_from, struct Job_List* to_append_to, struct Job* j);
void copy_delete_insert_job_list_sorted_by_file_size(struct Job_List* to_delete_from, struct Job_List* to_append_to, struct Job* j);
int get_length_job_list(struct Job* head);
void insert_next_time_in_sorted_list(struct Next_Time_List* liste, int time_to_insert);
void delete_next_time_linked_list(struct Next_Time_List* liste, int time_to_delete);
void free_next_time_linked_list(struct Next_Time** head_ref);
void insert_tail_to_print_list(struct To_Print_List* liste, struct To_Print* tp);
void insert_job_in_sorted_list(struct Job_List* liste, struct Job* j);
void create_and_insert_tail_interval_list(struct Interval_List* liste, int time_to_insert);
void free_interval_linked_list(struct Interval** head_ref);
void create_and_insert_head_time_or_data_already_checked_nb_of_copy_list(struct Time_or_Data_Already_Checked_Nb_of_Copy_List* liste, int time_or_data_to_insert, int nb_of_copy_to_insert);
void free_time_or_data_already_checked_nb_of_copy_linked_list(struct Time_or_Data_Already_Checked_Nb_of_Copy** head_ref);
void increment_time_or_data_nb_of_copy_specific_time_or_data(struct Time_or_Data_Already_Checked_Nb_of_Copy_List* liste, int time_or_data_to_increment);
void sort_cores_by_available_time_in_specific_node(struct Node* n);
void insert_job_sorted_by_decreasing_file_size(struct Job** head, struct Job* newNode);
void sort_job_list_by_file_size(struct Job** head);

/* From scheduler.c */
void get_state_before_day_0_scheduler(struct Job* j, struct Node_List** n, int t);
void fcfs_scheduler(struct Job* head_job, struct Node_List** head_node, int t, bool use_bigger_nodes);
void fcfs_with_a_score_scheduler(struct Job* head_job, struct Node_List** head_node, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy);
void fcfs_scheduler_backfill_big_nodes(struct Job* head_job, struct Node_List** head_node, int t, int backfill_big_node_mode, int total_queue_time, int nb_finished_jobs);
void fcfs_scheduler_planned_area_filling(struct Job* head_job, struct Node_List** head_node, int t, long long Planned_Area[3][3]);
void fcfs_scheduler_ratio_area_filling(struct Job* head_job, struct Node_List** head_node, int t, float Ratio_Area[3][3]);
void fcfs_easybf_scheduler(struct Job* head_job, struct Node_List** head_node, int t, bool use_bigger_nodes);
void fcfs_with_a_score_easybf_scheduler(struct Job* head_job, struct Node_List** head_node, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy);

//~ # Ce sont des listes de listes
//~ # ~ sub_list = []
//~ node_list =  [[] for _ in range(3)] # Nb of different sizes of memory
//~ available_node_list =  [[] for _ in range(3)] # Nb of different sizes of memory

//~ to_print_list = [] # TODO : utilisé ?

//~ job_list = []
//~ job_list_to_start_from_history = []
//~ # ~ job_list_0 = []
//~ # ~ job_list_1 = []
//~ # ~ job_list_2 = []
//~ available_job_list = []
//~ new_job_list = []
//~ scheduled_job_list = []
//~ to_print_list = []
//~ end_times = []
//~ # ~ nstart: int
//~ # ~ node_list = []
//~ # ~ available_node_list = [] # Contient aussi les coeurs disponibles


//~ @dataclass
//~ class To_print: # Struct used to know what to print later in csv
    //~ job_unique_id: int
    //~ job_subtime: int
    //~ node_unique_id: int
    //~ core_unique_id: list
    //~ time: int
    //~ time_used: int
    //~ transfer_time: int
    //~ job_start_time: int
    //~ job_end_time: int
    //~ job_cores: int
    //~ waiting_for_a_load_time: int
    //~ empty_cluster_time: float
    //~ data_type: int
