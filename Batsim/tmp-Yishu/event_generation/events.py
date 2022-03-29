import random
import string
import math
downtime = 3600 #downtime could be 10mins, 1h or 1day
threshold=5000000
total_preocessors = 49152
repeated_times=5
MTBF = 3600 #MTBF could be 20mins, 40mins, 1h, 2h, 5h, 10h
failure_lambda_totalprocessor = 1/MTBF
total_MTBF = 0
total_failures = 0
for j in range(0,repeated_times):
    filename = "events_MIRA_MTBF1h_downtime1h_" + str(j) + ".txt"
    random.seed(j)
    t_unavailable = 0
    dict = {}
    for i_dict in range(0, total_preocessors):
        dict[i_dict] = 0
    while (t_unavailable < threshold):
        MTBF = round(random.expovariate(failure_lambda_totalprocessor), 2)
        t_unavailable = t_unavailable + MTBF  #when will the next failure occur
        print("t_unavailable_temp: ", t_unavailable)
        total_processor_id = list(range(0, total_preocessors))
        failed_processor = random.choice(total_processor_id)  # which processor will the next failure occur
        print("failed_processor_firsttry: ", failed_processor)

        while t_unavailable < dict[failed_processor]:
            failed_processor = random.choice(total_processor_id)
            print("failed_processor_secondtry: ", failed_processor)
            total_processor_id.remove(failed_processor)
            if total_processor_id == []:
                print("all processors are during downtime, will put the next failure to earliest available time plus MTBF")
                t_available_minimal = 10000000000
                for i1 in range(0, total_preocessors):
                    if dict[i1] < t_minimal_available:
                        t_available_minimal = dict[i1]
                t_unavailable = t_available_minimal + MTBF
                break

        # print("t_unavailable: ", t_unavailable)
        t_available = t_unavailable + downtime
        # print("t_available: ", t_available)
        dict[failed_processor] = t_available

        unavailable_events = '{\"type\": \"machine_unavailable\", \"resources\": \"%d\", \"timestamp\": ' % (failed_processor)
        x = str(unavailable_events) + str(round(t_unavailable, 2)) + '}' + '\n'
        available_events = '{\"type\": \"machine_available\", \"resources\": \"%d\", \"timestamp\": ' % (failed_processor)
        y = str(available_events) + str(round(t_available, 2)) + '}' + '\n'
        with open(filename, "a") as f:
            f.write(x)
            f.write(y)
        total_MTBF = total_MTBF + MTBF
        total_failures = total_failures + 1

print(total_MTBF/(total_failures-1))
