Overview
========

The paper entitled "Doing better for jobs that failed: node stealing from a batch scheduler's perspective".

Getting Started
---------------

The code was primarily developed on a debian-like system (Ubuntu 20.04 LTS).
The following version numbers are provided as indication of the versions that
were tested. We recommend to install the default and/or recent versions of
Python and R.

Python scripts were used with the following packages on Python 3.9:

- evalys 4.0.5
- matplotlib 3.3.4

R scripts were used with the following packages on R 4.1.1:

- dplyr 1.0.7
- ggplot2 3.3.5
- rjson 0.2.20
- xtable 1.8-4

Recent versions of Python and R can be installed as follows on a
debian-like system (in a shell):

```shell
$ apt install python3 python3-pip r-base
```

Install all required Python and R packages as follows with `pip` and within R (launched with `R` in a shell):

    $ pip3 install evalys==4.0.5 matplotlib==3.3.4
    $ R
    > install.packages(c("dplyr", "ggplot2", "rjson", "xtable"))

Finally, Batsim needs to be installed. We provide an installation website https://batsim.readthedocs.io/en/latest/installation.html/, but we also explain how to install manually.

First, install Nix 

```shell
$ curl -L https://nixos.org/nix/install | sh
```

Second,  install Batsim and Batsched in your system via Nix (original version)

```shell
# Install the Batsim simulator.
$ nix-env -f https://github.com/oar-team/nur-kapack/archive/master.tar.gz -iA batsim

# Install the Batsched schedulers.
$ nix-env -f https://github.com/oar-team/nur-kapack/archive/master.tar.gz -iA batsched

# Install the interactive visualization tools.
$ nix-env -f https://github.com/oar-team/nur-kapack/archive/master.tar.gz -iA evalys

# Install the experiment management tools.
$ nix-env -f https://github.com/oar-team/nur-kapack/archive/master.tar.gz -iA batexpe
```

or install our developed code

```shell
$ git clone git@gitlab.inria.fr:yishu/node-stealing-for-resilience.git
```

### Generate MIRA workloads and failure events

Generate MIRA workloads, 

```shell
cd MIRA_workload_generation
$ R -f MIRA_workload.R
```

then you should put the workload files into `../batsim/workloads` folder.



Generate event files,

```shell
cd event_generation
$ python3 events.py
```

then you should put the event files into `../batsim/events` folder

### Run simulations

All experiments and simulations can be run as follows

```shell
# Enter the NIX environment
$ nix-shell

# generate yaml files
$ bash generate_yaml_MIRA.sh

# run simulation
$ bash run_simulation_MIRA.sh

# catelog the simulation results
$ bash catelog_results_MIRA.sh
```

### Data analysis

We use python to plot the gantt chart

```shell
# Figure 2 
$ cd gantt_chart_plot
$ python3 main.py
```

We use R to analysis the data and plot the figures

```shell
$ cd R_plot

### Section 4
# Table 3
$ R -f utilisation_withoutfailure.R #useful utilisation without failures

### Section 5 For heuristic h0 and h111
# Figures 1 and 3
$ R -f flows_withoutfailure_sameset.R #flows without failures
$ R -f flows_withfailure_sameset.R #flows with failures using conservative_bf heuristic 
$ R -f plot_withoutwithfailure

# Figures 4 and 5 
$ R -f flows_two_sameset.R #flows with failures, using conservative_bf and node-stealing
$ R -f plot_flows_two.R

# Figures 6 and 7
$ R -f usage_decompose.R # usage decomposed
$ R -f plot_usage_decompose.R #usage decomposed except for downtime
$ R -f plot_usage_decomposed_all.R #usage decomposed include downtime

# Figures 8-10
$ R -f utilisation_gain.R #normalized useful utilisation as a function of MTBF
$ R -f plot_utilisation_gain.R

# Figures 11-16
$ R -f flows_varing_MTBF_sameset.R #maxflow and weighted flow as a function of MTBF
$ R -f plot_flows_varingMTBF.R

# Table 4
$ R -f utilisation_ratio_compute.R #useful utilisation with failures

# Table 5
$ R -f percentage_available.R #percentage of time at least one procesor is available

# Table 6
$ R -f node_stealing_times.R #number of time node stealing is used

### Section 6 For all heuristics
# Figures 17-22
$ R -f flows_all_sameset.R #maxflow and meanflow for all heuristics
$ R -f plot_flows_all_sameset.R

# Table 7
$ R -f utilisation_all.R #useful utilisation with failures for all heuristics
$ R -f table_utilisation_all.R

# Table 8
$ R -f percentage_available_all.R #percentage of time at least one procesor is available for all heuristics
$ R -f table_percentage_available_all.R

# Table 9
$ R -f node_stealing_times_all.R #number of time node stealing is used for all heuristics
$ R -f table_node_stealing_times_all.R

```



