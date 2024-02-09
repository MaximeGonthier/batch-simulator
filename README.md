# Batch simulator for energy incentive

This repo is a copy of the repository https://gitlab.inria.fr/mgonthie/data-aware-batch-scheduling made on the 8 Feb 2024.
It does not contain all of the things related to the project conducted in Uppsala like scripts, plots, articles and so on.

This simulator aims at improving the one from https://gitlab.inria.fr/mgonthie/data-aware-batch-scheduling to include functionalitites like heterogeneous set of nodes, energy consumption of a job on a node, incentivize users to be more energy efficient and simulate the behavior of users with set goals (speed, energy, mix of both), give an energY credit to each users.

It simulates a FaaS more than a cluster so no queues or backfilling involved.

We start by giving all the information to the user about runtime/energy and credit update and then see when each users use all of his credits

This repo is not breaking what was working in https://gitlab.inria.fr/mgonthie/data-aware-batch-scheduling.
However it isadding new options for a energy-hetero oriented simulation with no data transfers and backfilling

This repo introduce the no_schedule "scheduler" which let user choose an endpoint.

We only have jobs that use all the nodes (as they are machines in our case)

In the code, all the stuff I added or modified for our case is marked with /** ENERGY INCENTIVE **/
