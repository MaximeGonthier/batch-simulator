all: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -O3 -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

nb_heure_max:
	gcc -Wall -O3 -DNB_HOUR_MAX -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

save:
	gcc -Wall -O3 -DSAVE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm
	
debug:
	gcc -Wall -O3 -g3 -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

data_persistence:
	gcc -Wall -O3 -DDATA_PERSISTENCE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm
	
data_persistence_plot_stats:
	gcc -Wall -O3 -DDATA_PERSISTENCE -DPLOT_STATS -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_data_persistence:
	gcc -Wall -O3 -DPRINT -DDATA_PERSISTENCE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_gantt_chart_data_persistence:
	gcc -Wall -O3 -DPRINT_GANTT_CHART -DDATA_PERSISTENCE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_print_gantt_chart_data_persistence:
	gcc -Wall -O3 -DPRINT -DPRINT_GANTT_CHART -DDATA_PERSISTENCE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -O3 -DPRINT -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_gantt_chart: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -O3 -DPRINT_GANTT_CHART -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm
	
print_print_gantt_chart: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -O3 -DPRINT -DPRINT_GANTT_CHART -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_distribution_queue_times: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -O3 -DPRINT_DISTRIBUTION_QUEUE_TIMES -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_cluster_usage: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -O3 -DPRINT_CLUSTER_USAGE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm
	
print_cluster_usage_core_by_core: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -O3 -DPRINT_CLUSTER_USAGE -DPRINT_CLUSTER_USAGE_CORE_BY_CORE -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm
	
plot_stats: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -O3 -DPLOT_STATS -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

plot_stats_print_gantt_chart: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -O3 -DPLOT_STATS -DPRINT_GANTT_CHART -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm
	
print_plot_stats: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -O3 -DPRINT -DPLOT_STATS -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

print_plot_stats_print_gantt_chart: main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c
	gcc -Wall -O3 -DPRINT -DPLOT_STATS -DPRINT_GANTT_CHART -o main main.c read_input_files.c print_functions.c basic_functions.c scheduler.c linked_list_functions.c backfill_functions.c scheduler_calling.c -I. -lm

clean:
	rm *.o
