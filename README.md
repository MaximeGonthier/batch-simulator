 Batch simulator for energy incentive

This repository is a modification of the repository https://gitlab.inria.fr/mgonthie/data-aware-batch-scheduling made on the 8 Feb 2024.
It does not contain all of the things related to the project conducted in the previous repo like scripts, plots, articles and so on.

This simulator aims at improving the one from https://gitlab.inria.fr/mgonthie/data-aware-batch-scheduling to include functionalitites like heterogeneous set of nodes, energy consumption of a job on a node, incentivize users to be more energy efficient and simulate the behavior of users with set goals (speed, energy, mix of both) and give an energy credit to each users.

This repo introduce the no_schedule "scheduler" which let user choose an endpoint.

We only have jobs that use all the nodes (as they are machines in our case)

In the code, all the modification are marked with /** ENERGY INCENTIVE **/

Added the number of cpu, idle power and cpu tdp ionto the info of the machines
Added duration_on_machine: 100 120 34 59  in the workload data, much correspond to the number of machines!
Same for energy_on_machine

total_number_jobs must be a multiple of nusers




------
This branch looks at temporal shifting based on carbon intensity.
the simulator supports parralel jobs, compute carbon and energy cost, and supports walltime and runtime difference
