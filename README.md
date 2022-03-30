# Data Aware Batch Scheduling

## Maxime GONTHIER - Carl NETTELBLAD - Elisabeth LARSSON - Samuel THIBAULT - Loris MARCHAL

Assuming you are in the folder ~/data-aware-batch-scheduling for the following commands.

To compile Data_aware_batch_scheduling.pdf:
```shell
$ make
```

## Batsim

### Draw Gantt charts

Full credit to Yishu DU for the code used to produce the gantt charts.

To create gantt charts you need the following packages:
```shell
$ sudo apt-get install python3
$ pip3 install evalys
```

You can then draw with:
```shell
$ python3 Batsim/batsched-Maxime/gantt-chart-plot/main.py $PATH/input_file.csv
```
With input_file, the .csv job file produced by Batsim.
