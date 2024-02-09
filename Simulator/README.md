make -C src/

Constraint on size:
To add or remove the constraint that some jobs can't be executed on certain nodes. 0 for no constraint, 1 for constraint, 2 for constraint but we don't consider transfer time. 3 for constraint and you can only execute on your specific size

./src/main workload endpoints scheduler(always no_schedule for us as it triggers all the thing specific to this project) constraint_on_size(always chose 0 in our case) output_file backfill_mode(always choose 0 in our case as we globus we don't have backfilling) busy_cluster_threshold(don't care here for us)

./src/main inputs/workloads/converted/functions_1 inputs/clusters/set_of_endpoints_1 no_schedule 0 outputs/test.csv 0 100
