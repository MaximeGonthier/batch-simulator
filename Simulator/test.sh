#!/usr/bin/bash

nusers=4

make energy_incentive -C src/
./src/main inputs/workloads/converted/8_functions_4_endpoints inputs/clusters/set_of_endpoints_1 no_schedule 0 outputs/test.csv 0 100
python3 src/plot_results.py outputs/test.csv ${nusers}
