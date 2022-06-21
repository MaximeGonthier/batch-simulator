all: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c
	gcc -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c -I.

print: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c
	gcc -DPRINT -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c -I.

print_gantt_chart: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c
	gcc -DPRINT_GANTT_CHART -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c -I.

print_distribution_queue_times: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c
	gcc -DPRINT_DISTRIBUTION_QUEUE_TIMES -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c -I.

print_cluster_usage: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c
	gcc -DPRINT_CLUSTER_USAGE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c -I.
