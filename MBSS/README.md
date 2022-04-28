# How to run the simulator ?

```shell
$ python3 src/main_multi_core.py WORKLOAD CLUSTER SCHEDULER FILLING WRITE
```

## Arguments

WORKLOAD: a file
CLUSTER: a file
SCHEDULER: Random or Maximum_use_single_file or Fcfs_with_a_score 
FILLING: ShiftLeft or NoFilling 
WRITE: 0 = only write finale results 1 = write data for Gantt chart 2 = write data for distribution of queue times
