#!/usr/bin/bash

# run simulation of heuristic h0 and h111 for June 2017

for e in {0..4}
do
    cd test_MIRA_2017June_MTBF1h_downtime1h_${e}_0
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_${e}_111
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    cd ..
done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF2h_downtime1h_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF2h_downtime1h_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF5h_downtime1h_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF5h_downtime1h_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF10h_downtime1h_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF10h_downtime1h_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF40min_downtime1h_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF40min_downtime1h_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF20min_downtime1h_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF20min_downtime1h_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF1h_downtime1day_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF1h_downtime1day_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF2h_downtime1day_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF2h_downtime1day_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF5h_downtime1day_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF5h_downtime1day_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF10h_downtime1day_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF10h_downtime1day_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF40min_downtime1day_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF40min_downtime1day_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF20min_downtime1day_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF20min_downtime1day_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF1h_downtime10min_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF1h_downtime10min_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF2h_downtime10min_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF2h_downtime10min_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF5h_downtime10min_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF5h_downtime10min_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF10h_downtime10min_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF10h_downtime10min_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF40min_downtime10min_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF40min_downtime10min_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2017June_MTBF20min_downtime10min_${e}_0
    #~ robin ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2017June_MTBF20min_downtime10min_${e}_111
    #~ robin ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ # run simulation of heuristic h0 and h111 for March 2018

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF2h_downtime1h_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF2h_downtime1h_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF5h_downtime1h_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF5h_downtime1h_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF10h_downtime1h_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF10h_downtime1h_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF40min_downtime1h_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF40min_downtime1h_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF20min_downtime1h_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF20min_downtime1h_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF1h_downtime1day_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1day_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF2h_downtime1day_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF2h_downtime1day_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF5h_downtime1day_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF5h_downtime1day_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF10h_downtime1day_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF10h_downtime1day_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF40min_downtime1day_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF40min_downtime1day_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF20min_downtime1day_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF20min_downtime1day_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF1h_downtime10min_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime10min_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF2h_downtime10min_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF2h_downtime10min_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF5h_downtime10min_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF5h_downtime10min_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF10h_downtime10min_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF10h_downtime10min_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF40min_downtime10min_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF40min_downtime10min_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


#~ for e in {0..4}
#~ do
    #~ cd test_MIRA_2018March_MTBF20min_downtime10min_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF20min_downtime10min_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


### run simulation of all heuristics for June 2017
for e in 0
do
    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_111
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_112
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_112.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_113
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_113.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_121
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_121.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_122
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_122.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_123
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_123.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_211
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_211.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_212
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_212.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_213
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_213.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_221
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_221.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_222
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_222.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_223
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_223.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_311
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_311.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_312
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_312.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_313
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_313.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_321
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_321.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_322
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_322.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_323
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_323.yaml > outputfile 2> error_file &
    cd ..
done 

wait

for e in 1
do
    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_111
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_112
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_112.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_113
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_113.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_121
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_121.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_122
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_122.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_123
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_123.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_211
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_211.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_212
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_212.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_213
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_213.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_221
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_221.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_222
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_222.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_223
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_223.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_311
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_311.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_312
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_312.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_313
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_313.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_321
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_321.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_322
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_322.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_323
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_323.yaml > outputfile 2> error_file &
    cd ..
done 

wait

for e in 2
do
    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_111
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_112
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_112.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_113
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_113.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_121
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_121.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_122
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_122.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_123
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_123.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_211
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_211.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_212
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_212.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_213
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_213.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_221
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_221.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_222
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_222.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_223
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_223.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_311
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_311.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_312
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_312.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_313
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_313.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_321
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_321.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_322
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_322.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_323
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_323.yaml > outputfile 2> error_file &
    cd ..
done 

wait

for e in 3
do
    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_111
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_112
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_112.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_113
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_113.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_121
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_121.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_122
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_122.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_123
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_123.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_211
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_211.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_212
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_212.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_213
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_213.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_221
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_221.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_222
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_222.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_223
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_223.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_311
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_311.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_312
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_312.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_313
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_313.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_321
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_321.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_322
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_322.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_323
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_323.yaml > outputfile 2> error_file &
    cd ..
done 

wait

for e in 4
do
    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_111
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_112
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_112.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_113
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_113.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_121
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_121.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_122
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_122.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_123
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_123.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_211
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_211.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_212
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_212.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_213
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_213.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_221
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_221.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_222
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_222.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_223
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_223.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_311
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_311.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_312
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_312.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_313
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_313.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_321
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_321.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_322
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_322.yaml > outputfile 2> error_file &
    cd ..

    cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_323
    robin ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_323.yaml > outputfile 2> error_file &
    cd ..
done 

#~ wait


#~ ### run simulations of all heuristics for March 2018
#~ for e in 0
#~ do
    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_112
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_112.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_113
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_113.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_121
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_121.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_122
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_122.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_123
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_123.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_211
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_211.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_212
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_212.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_213
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_213.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_221
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_221.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_222
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_222.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_223
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_223.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_311
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_311.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_312
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_312.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_313
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_313.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_321
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_321.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_322
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_322.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_323
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_323.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in 1
#~ do
    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_112
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_112.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_113
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_113.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_121
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_121.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_122
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_122.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_123
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_123.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_211
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_211.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_212
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_212.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_213
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_213.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_221
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_221.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_222
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_222.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_223
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_223.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_311
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_311.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_312
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_312.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_313
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_313.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_321
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_321.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_322
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_322.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_323
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_323.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in 2
#~ do
    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_112
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_112.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_113
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_113.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_121
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_121.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_122
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_122.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_123
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_123.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_211
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_211.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_212
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_212.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_213
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_213.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_221
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_221.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_222
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_222.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_223
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_223.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_311
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_311.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_312
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_312.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_313
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_313.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_321
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_321.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_322
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_322.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_323
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_323.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in 3
#~ do
    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_112
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_112.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_113
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_113.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_121
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_121.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_122
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_122.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_123
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_123.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_211
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_211.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_212
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_212.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_213
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_213.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_221
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_221.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_222
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_222.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_223
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_223.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_311
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_311.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_312
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_312.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_313
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_313.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_321
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_321.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_322
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_322.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_323
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_323.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait

#~ for e in 4
#~ do
    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_111
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_112
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_112.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_113
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_113.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_121
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_121.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_122
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_122.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_123
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_123.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_211
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_211.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_212
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_212.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_213
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_213.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_221
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_221.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_222
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_222.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_223
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_223.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_311
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_311.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_312
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_312.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_313
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_313.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_321
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_321.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_322
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_322.yaml > outputfile 2> error_file &
    #~ cd ..

    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_323
    #~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_323.yaml > outputfile 2> error_file &
    #~ cd ..
#~ done 

#~ wait


# no node stealing, simple chechpoints using original conservative backfilling heuristic 2017June
cd test_MIRA_2017June_MTBF1h_downtime1h_withoutC

robin ./test_MIRA_2017June_MTBF1h_downtime1h_withoutC.yaml

cd ..

#~ # no node stealing, simple chechpoints using original conservative backfilling heuristic 2018March
#~ cd test_MIRA_2018March_MTBF1h_downtime1h_withoutC

#~ robin ./test_MIRA_2018March_MTBF1h_downtime1h_0_0.yaml

#~ cd ..
