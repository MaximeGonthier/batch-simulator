all: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

debug:
	gcc -Wall -g3 -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

data_persistence:
	gcc -Wall -DDATA_PERSISTENCE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm
	
data_persistence_plot_stats:
	gcc -Wall -DDATA_PERSISTENCE -DPLOT_STATS -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_data_persistence:
	gcc -Wall -DPRINT -DDATA_PERSISTENCE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_gantt_chart_data_persistence:
	gcc -Wall -DPRINT_GANTT_CHART -DDATA_PERSISTENCE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_print_gantt_chart_data_persistence:
	gcc -Wall -DPRINT -DPRINT_GANTT_CHART -DDATA_PERSISTENCE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -DPRINT -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_gantt_chart: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -DPRINT_GANTT_CHART -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm
	
print_print_gantt_chart: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -DPRINT -DPRINT_GANTT_CHART -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_distribution_queue_times: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -DPRINT_DISTRIBUTION_QUEUE_TIMES -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_cluster_usage: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -DPRINT_CLUSTER_USAGE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm
	
plot_stats: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -DPLOT_STATS -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

plot_stats_print_gantt_chart: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -DPLOT_STATS -DPRINT_GANTT_CHART -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm
	
print_plot_stats: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -DPRINT -DPLOT_STATS -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_plot_stats_print_gantt_chart: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -DPRINT -DPLOT_STATS -DPRINT_GANTT_CHART -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

clean:
	rm *.o
