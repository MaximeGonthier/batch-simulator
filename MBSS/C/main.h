#define PRINT
#define PRINT_GANTT_CHART
#define PRINT_DISTRIBUTION_QUEUE_TIMES
#define PRINT_CLUSTER_USAGE

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

/* Global variables */
int finished_jobs;
int total_number_jobs;
int total_number_nodes;
struct Job_List* job_list;
struct Job_List* available_job_list;
struct Job_List* job_list_to_start_from_history;
struct Job_List* scheduled_job_list;
struct Job_List* running_jobs;
struct Node_List** node_list;
int running_cores;
int running_nodes;
int total_queue_time;
int next_end_time;
int nb_job_to_evaluate_finished;

struct Job_List {
	struct Job* head;
	struct Job* tail;
};

struct Node_List {
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
    struct Node* node_used; /* None */
    int* cores_used; /* list */
    int transfer_time;
    int waiting_for_a_load_time;
    int workload;
    int start_time_from_history;
    int node_from_history;
};

struct Node {
	struct Node *next;
    int unique_id;
    int memory;
    float bandwidth;
    struct Data_List* data;
    struct Core** cores;
    int n_available_cores;
};

struct Data {
    int unique_id;
    int start_time;
    int end_time;
    int nb_task_using_it;
    //~ temp_interval_usage_time: list;
    int size;
};

struct Core {
    int unique_id;
    struct Job_List* job_queue;
    int available_time;
    struct Job* running_job;
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

/* From basic_functions.c */
void schedule_job_specific_node_at_earliest_available_time(struct Job* j, struct Node* n, int t);
void sort_cores_by_available_time_in_specific_node(struct Node* n);
void start_jobs(int t, struct Job* scheduled);

/* From linked_list_functions.c */
void insert_head_job_list(struct Job_List* liste, struct Job* j);
void insert_tail_job_list(struct Job_List* liste, struct Job* j);
void insert_tail_node_list(struct Node_List* liste, struct Node* n);
void copy_job_and_insert_tail_job_list(struct Job_List* liste, struct Job* j);

/* From scheduler.c */
void get_state_before_day_0_scheduler(struct Job* j, struct Node_List** n, int t);

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
