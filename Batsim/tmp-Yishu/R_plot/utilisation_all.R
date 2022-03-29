date = "2017June"
downtime = "downtime1h"
event_choice = c("20min","40min","1h","2h","5h","10h")
utilization_gain_eachMTBF = vector()
# for(kk in 1:length(event_choice)){
kk=3
wdfile = paste("/home/yishu/MIRA_simulation_data1214/MIRA", date,"/test_MIRA_", date,"_MTBF", event_choice[kk],"_", downtime,"_allheuristics", collapse = ", ", sep = "")
setwd(wdfile)

if(kk==1){
  MTBF=3600/3
} else if (kk==2){
  MTBF=3600/3*2
} else if (kk==3){
  MTBF=3600
} else if (kk==4){
  MTBF=3600*2
} else if (kk==5){
  MTBF = 3600*5
} else {
  MTBF = 3600*10
}
# setwd("/home/yishu/node-stealing-for-resilience/tmp/MIRA2017June/expe-out_MIRA_2017June_MTBF1h_downtime1h") #!!!
# setwd("/home/yishu/node-stealing-for-resilience/tmp/MIRA2018March/expe-out_MIRA_2018March_MTBF1h_downtime1h")

library(ggplot2)
library(dplyr)
event_repeated_times=5
# MTBF = 3600 #!!!
nb_computing_machines = 49152
total_failure_rate = 1/(MTBF*nb_computing_machines)
checkpoint_time = 300

time_computig_idle_decompose = matrix(0,event_repeated_times,6)
time_computig_idle_downtime_decompose = matrix(0,event_repeated_times,7)

# makespan = max(data$finish_time)
begin = 10*24*3600
end = 30*24*3600

# heuristic_choice = c("0","111")
# utilization_ratio_eachsimulation = matrix(0,2,event_repeated_times)

heuristic_choice = c("0","111","112","113","121","122","123","211","212","213","221","222","223","311","312","313","321","322","323")
utilization_ratio_eachsimulation = matrix(0,length(heuristic_choice),event_repeated_times)

for(mm in 0:(event_repeated_times-1)){

  eventfile = paste("/home/yishu/node-stealing-for-resilience/tmp/batsim-src-stable/events/events_MIRA_MTBF",event_choice[kk],"_", downtime,"_", mm, ".txt", collapse = "," , sep = "") #!!!
  print(mm)
  for(nn in 1:length(heuristic_choice)){

    print(nn)
    datafile = paste("./expe_", mm, "_",heuristic_choice[nn],"_jobs.csv", collapse = ", ", sep = "") #!!!
    data_completed_killed_file = paste("./COMPLETED_KILLED_", mm, "_",heuristic_choice[nn],".txt", collapse = ", ", sep = "") #!!!
    data_completed_successfully_jobcopy_file = paste("./COMPLETED_SUCCESSFULLY_JOBCOPY_", mm, "_",heuristic_choice[nn],".txt", collapse = ", ", sep = "") #!!!
    
    # datafile = paste("./expe_", mm, "_0_jobs.csv", collapse = ", ", sep = "") #!!!
    # data_completed_killed_file = paste("./COMPLETED_KILLED_", mm, "_0.txt", collapse = ", ", sep = "") #!!!
    # data_completed_successfully_jobcopy_file = paste("./COMPLETED_SUCCESSFULLY_JOBCOPY_", mm, "_0.txt", collapse = ", ", sep = "") #!!!
    
    # datafile = paste("./expe_", mm, "_111_jobs.csv", collapse = ", ", sep = "")
    # data_completed_killed_file = paste("./COMPLETED_KILLED_", mm, "_111.txt", collapse = ", ", sep = "")
    # data_completed_successfully_jobcopy_file = paste("./COMPLETED_SUCCESSFULLY_JOBCOPY_", mm, "_111.txt", collapse = ", ", sep = "")
    
    data <- read.csv(file = datafile, header=T,stringsAsFactors = FALSE)
    data = data[!grepl("checkpoint", data[,1]),]
    
    data_completed_killed<-read.table(file = data_completed_killed_file,header=F,na.strings = c("NA"))
    data_completed_successfully_jobcopy<-read.table(file = data_completed_successfully_jobcopy_file,header=F,na.strings = c("NA"))
    
    # makespan = max(data$finish_time)
    # begin = makespan*0.1
    # end = makespan*0.9
    names(data_completed_killed)<-c("id","priority","useful","checkpoint","waste_failure","waste_node","recovery","Tfirst","Rfirst")
    names(data_completed_successfully_jobcopy)<-c("id","priority","useful","checkpoint","waste_failure","waste_node","recovery","Tfirst","Rfirst")
    data_w0_successful <- data %>% filter(data[,2] == "w0" & data[,8] == "COMPLETED_SUCCESSFULLY")
    data_resubmit_successful <- data %>% filter(data[,2] == "resubmit" & data[,8] == "COMPLETED_SUCCESSFULLY")
    #T=sqrt(2C/(lambda*job_size))
    checkpoint_period = sqrt((2*checkpoint_time)/(total_failure_rate*data_w0_successful$requested_number_of_resources))
    data_w0_successful<-cbind(data_w0_successful,checkpoint_period)
    #checkpoint_total=[floor(delay/(T+C))*C]*job_size 
    checkpoint = (floor(data_w0_successful$execution_time/(data_w0_successful$checkpoint_period+checkpoint_time))*checkpoint_time)*data_w0_successful$requested_number_of_resources 
    data_w0_successful<-cbind(data_w0_successful,checkpoint)
    #useful_total=delay*job_size-checkpoint_total
    useful = data_w0_successful$execution_time * data_w0_successful$requested_number_of_resources - data_w0_successful$checkpoint
    data_w0_successful<-cbind(data_w0_successful,useful)
    
    #data_completed_successfully_jobcopy generated from C++ contains each submitted job_copy
    #maybe some failed later, we should remove them and get the data_real_completed_successfully_jobcopy like data_resubmit_successful
    job_list = data_resubmit_successful[,1]
    data_real_completed_successfully_jobcopy=data_completed_successfully_jobcopy %>% filter(data_completed_successfully_jobcopy[,1] == job_list[1])
    for (i in 2:length(job_list)){
      data_real_completed_successfully_jobcopy[i, ]=data_completed_successfully_jobcopy %>% filter(data_completed_successfully_jobcopy[,1] == job_list[i])
    }
    # remove data_remove_begin from data_completed_killed, data_real_completed_successfully_jobcopy and data_w0_successful
    data_remove_begin <- data %>% filter(data[,11] < begin) #starting_time before bound_begin
    job_list_removebegin = data_remove_begin[,1]
    for (i in 1:length(job_list_removebegin)){
      data_completed_killed = data_completed_killed[data_completed_killed$id!=job_list_removebegin[i], ]
      data_real_completed_successfully_jobcopy = data_real_completed_successfully_jobcopy[data_real_completed_successfully_jobcopy$id!=job_list_removebegin[i], ]
      data_w0_successful = data_w0_successful[data_w0_successful$job_id!=job_list_removebegin[i], ]
    }
    # remove data_remove_end from data_completed_killed, data_real_completed_successfully_jobcopy and data_w0_successful
    data_remove_end <- data %>% filter(data[,9] > end) #finish_time after bound_begin
    job_list_removeend = data_remove_end[,1]
    for (i in 1:length(job_list_removeend)){
      data_completed_killed = data_completed_killed[data_completed_killed$id!=job_list_removeend[i], ]
      data_real_completed_successfully_jobcopy = data_real_completed_successfully_jobcopy[data_real_completed_successfully_jobcopy$id!=job_list_removeend[i], ]
      data_w0_successful = data_w0_successful[data_w0_successful$job_id!=job_list_removeend[i], ]
    }
    
    # deal with jobs cross the begin bound
    data_cross_begin <- data %>% filter(data[,9] < begin & data[,11] > begin) #starting_time before bound_begin and finish_time after bound_begin
    job_cross_begin_remove=vector()
    job_cross_begin = data_cross_begin[,1]
    
    if(length(job_cross_begin)>0)
    {
      for(i0 in 1:length(job_cross_begin)){
        for(i1 in 1:length(data_w0_successful$job_id)){
          # if(grepl(job_cross_begin[i0], data_w0_successful$job_id[i1])){
          if(job_cross_begin[i0] == data_w0_successful$job_id[i1]){
            # jobs cross the begin bound is in data_w0_successful, we should recompute its usefultime and so on
            cross_delay = data_w0_successful$execution_time[i1]
            cross_start = data_w0_successful$starting_time[i1]
            cross_finish = data_w0_successful$finish_time[i1]
            cross_T = data_w0_successful$checkpoint_period[i1]
            cross_jobsize = data_w0_successful$requested_number_of_resources[i1]
            remaing_time = begin-cross_start - floor((begin-cross_start)/(cross_T+checkpoint_time))*(cross_T+checkpoint_time)
            if (remaing_time < cross_T){
              Tfirst = cross_T - remaing_time
              checkpoint = (checkpoint_time + floor((cross_finish-begin-Tfirst-checkpoint_time)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
              useful = (cross_finish - begin)*cross_jobsize - checkpoint
              data_w0_successful$checkpoint[i1] = checkpoint
              data_w0_successful$useful[i1] = useful
            } else{
              checkpoint_first = checkpoint_time - remaing_time
              checkpoint = (checkpoint_first + floor((cross_finish-begin-checkpoint_first)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
              useful = (cross_finish - begin)*cross_jobsize - checkpoint
              data_w0_successful$checkpoint[i1] = checkpoint
              data_w0_successful$useful[i1] = useful
            }
            job_cross_begin_remove <- append(job_cross_begin_remove,i0)
            break
          }
        }
      }
      job_cross_begin = job_cross_begin[-job_cross_begin_remove] 
      job_cross_begin_remove = vector()
    }
    
    if(length(job_cross_begin)>0)
    {
      for(i0 in 1:length(job_cross_begin)){
        for(i2 in 1:length(data_real_completed_successfully_jobcopy$id)){
          # if(grepl(job_cross_begin[i0], data_real_completed_successfully_jobcopy$id[i2])){
          if(job_cross_begin[i0] == data_w0_successful$job_id[i1]){
            # jobs cross the begin bound is in data_real_completed_successfully_jobcopy, we should recompute its usefultime and so on
            cross_delay = (data %>% filter(data$job_id == job_cross_begin[i0]))$execution_time
            cross_start = (data %>% filter(data$job_id == job_cross_begin[i0]))$starting_time
            cross_finish = (data %>% filter(data$job_id == job_cross_begin[i0]))$finish_time
            cross_jobsize = (data %>% filter(data$job_id == job_cross_begin[i0]))$requested_number_of_resources
            cross_T = sqrt(2*checkpoint_time/(total_failure_rate*cross_jobsize))
            cross_Rfirst =  data_real_completed_successfully_jobcopy$Rfirst[i2]
            cross_Tfirst =  data_real_completed_successfully_jobcopy$Tfirst[i2]
            if (begin - cross_start < cross_Rfirst){
              recovery = data_real_completed_successfully_jobcopy$recovery[i2] - (begin - cross_start)*cross_jobsize
              data_real_completed_successfully_jobcopy$recovery[i2] = recovery
            } else if(cross_Rfirst < begin - cross_start & begin - cross_start < cross_Rfirst + cross_Tfirst){
              useful = data_real_completed_successfully_jobcopy$useful[i2] - (begin - cross_start - cross_Rfirst)*cross_jobsize
              data_real_completed_successfully_jobcopy$useful[i2] = useful
              data_real_completed_successfully_jobcopy$recovery[i2] = 0
            } else if(cross_Rfirst + cross_Tfirst < begin - cross_start & begin - cross_start < cross_Rfirst + cross_Tfirst+checkpoint_time){
              useful = data_real_completed_successfully_jobcopy$useful[i2] - cross_Tfirst*cross_jobsize
              checkpoint = data_real_completed_successfully_jobcopy$checkpoint[i2] - (begin - cross_start - cross_Rfirst - cross_Tfirst)*cross_jobsize
              data_real_completed_successfully_jobcopy$checkpoint[i2] = checkpoint
              data_real_completed_successfully_jobcopy$useful[i2] = useful
              data_real_completed_successfully_jobcopy$recovery[i2] = 0
            } else{
              t1 = cross_Rfirst + cross_Tfirst+checkpoint_time
              remaing_time = begin-cross_start-t1 - floor((begin-cross_start-t1)/(cross_T+checkpoint_time))*(cross_T+checkpoint_time)
              if (remaing_time < cross_T){
                Tfirst = cross_T - remaing_time
                checkpoint = (checkpoint_time + floor((cross_finish-begin-Tfirst-checkpoint_time)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                useful = (cross_finish - begin)*cross_jobsize - checkpoint
                data_real_completed_successfully_jobcopy$checkpoint[i2] = checkpoint
                data_real_completed_successfully_jobcopy$useful[i2] = useful
                data_real_completed_successfully_jobcopy$recovery[i2] = 0
              } else{
                checkpoint_first = checkpoint_time - remaing_time
                checkpoint = (checkpoint_first + floor((cross_finish-begin-checkpoint_first)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                useful = (cross_finish - begin)*cross_jobsize - checkpoint
                data_real_completed_successfully_jobcopy$checkpoint[i2] = checkpoint
                data_real_completed_successfully_jobcopy$useful[i2] = useful
                data_real_completed_successfully_jobcopy$recovery[i2] = 0
              }
            }
            job_cross_begin_remove <- append(job_cross_begin_remove,i0)
            break
          }
        }
      }
      job_cross_begin = job_cross_begin[-job_cross_begin_remove] 
      job_cross_begin_remove = vector()
    }
    
    if(length(job_cross_begin)>0)
    {
      for(i0 in 1:length(job_cross_begin)){
        for(i3 in 1:length(data_completed_killed$id)){
          # if(grepl(job_cross_begin[i0], data_completed_killed$id[i3])){
          if(job_cross_begin[i0] == data_completed_killed$id[i3]){
            # jobs cross the begin bound is in data_completed_killed, we should recompute its usefultime and so on
            cross_delay = (data %>% filter(data$job_id == job_cross_begin[i0]))$execution_time
            cross_start = (data %>% filter(data$job_id == job_cross_begin[i0]))$starting_time
            cross_finish = (data %>% filter(data$job_id == job_cross_begin[i0]))$finish_time
            cross_jobsize = (data %>% filter(data$job_id == job_cross_begin[i0]))$requested_number_of_resources
            cross_T = sqrt(2*checkpoint_time/(total_failure_rate*cross_jobsize))
            cross_Rfirst =  data_completed_killed$Rfirst[i3]
            cross_Tfirst =  data_completed_killed$Tfirst[i3]
            
            if (data_completed_killed$priority[i3] ==2){
              cross_wastefailure = data_completed_killed$waste_failure[i3]
              if ((cross_finish-begin)*cross_jobsize < cross_wastefailure){
                cross_wastefailure = (cross_finish-begin)*cross_jobsize
                data_completed_killed$waste_failure[i3] = cross_wastefailure
                data_completed_killed$checkpoint[i3] = 0
                data_completed_killed$useful[i3] = 0
                data_completed_killed$recovery[i3] = 0
              } else{
                if (begin - cross_start < cross_Rfirst){
                  recovery = data_completed_killed$recovery[i3] - (begin - cross_start)*cross_jobsize
                  data_completed_killed$recovery[i3] = recovery
                } else if(cross_Rfirst < begin - cross_start & begin - cross_start < cross_Rfirst + cross_Tfirst){
                  useful = data_completed_killed$useful[i3] - (begin - cross_start - cross_Rfirst)*cross_jobsize
                  data_completed_killed$useful[i3] = useful
                  data_completed_killed$recovery[i3] = 0
                } else if(cross_Rfirst + cross_Tfirst < begin - cross_start & begin - cross_start < cross_Rfirst + cross_Tfirst+checkpoint_time){
                  useful = data_completed_killed$useful[i3] - cross_Tfirst*cross_jobsize
                  checkpoint = data_completed_killed$checkpoint[i3] - (begin - cross_start - cross_Rfirst - cross_Tfirst)*cross_jobsize
                  data_completed_killed$checkpoint[i3] = checkpoint
                  data_completed_killed$useful[i3] = useful
                  data_completed_killed$recovery[i3] = 0
                } else{
                  t1 = cross_Rfirst + cross_Tfirst+checkpoint_time
                  remaing_time = begin-cross_start-t1 - floor((begin-cross_start-t1)/(cross_T+checkpoint_time))*(cross_T+checkpoint_time)
                  if (remaing_time < cross_T){
                    Tfirst = cross_T - remaing_time
                    checkpoint = (checkpoint_time + floor((cross_finish-begin-Tfirst-checkpoint_time)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                    useful = (cross_finish - begin)*cross_jobsize - checkpoint
                    data_completed_killed$checkpoint[i3] = checkpoint
                    data_completed_killed$useful[i3] = useful
                    data_completed_killed$recovery[i3] = 0
                  } else{
                    checkpoint_first = checkpoint_time - remaing_time
                    checkpoint = (checkpoint_first + floor((cross_finish-begin-checkpoint_first)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                    useful = (cross_finish - begin)*cross_jobsize - checkpoint
                    data_completed_killed$checkpoint[i3] = checkpoint
                    data_completed_killed$useful[i3] = useful
                    data_completed_killed$recovery[i3] = 0
                  }
                }
              }
            } else{
              cross_wastenode = data_completed_killed$waste_node[i3]
              if ((cross_finish-begin)*cross_jobsize < cross_wastenode){
                cross_wastenode = (cross_finish-begin)*cross_jobsize
                data_completed_killed$waste_node[i3] = cross_wastenode
                data_completed_killed$checkpoint[i3] = 0
                data_completed_killed$useful[i3] = 0
                data_completed_killed$recovery[i3] = 0
              } else{
                if (begin - cross_start < cross_Rfirst){
                  recovery = data_completed_killed$recovery[i3] - (begin - cross_start)*cross_jobsize
                  data_completed_killed$recovery[i3] = recovery
                } else if(cross_Rfirst < begin - cross_start & begin - cross_start < cross_Rfirst + cross_Tfirst){
                  useful = data_completed_killed$useful[i3] - (begin - cross_start - cross_Rfirst)*cross_jobsize
                  data_completed_killed$useful[i3] = useful
                  data_completed_killed$recovery[i3] = 0
                } else if(cross_Rfirst + cross_Tfirst < begin - cross_start & begin - cross_start < cross_Rfirst + cross_Tfirst+checkpoint_time){
                  useful = data_completed_killed$useful[i3] - cross_Tfirst*cross_jobsize
                  checkpoint = data_completed_killed$checkpoint[i3] - (begin - cross_start - cross_Rfirst - cross_Tfirst)*cross_jobsize
                  data_completed_killed$checkpoint[i3] = checkpoint
                  data_completed_killed$useful[i3] = useful
                  data_completed_killed$recovery[i3] = 0
                } else{
                  t1 = cross_Rfirst + cross_Tfirst+checkpoint_time
                  remaing_time = begin-cross_start-t1 - floor((begin-cross_start-t1)/(cross_T+checkpoint_time))*(cross_T+checkpoint_time)
                  if (remaing_time < cross_T){
                    Tfirst = cross_T - remaing_time
                    checkpoint = (checkpoint_time + floor((cross_finish-begin-Tfirst-checkpoint_time)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                    useful = (cross_finish - begin)*cross_jobsize - checkpoint
                    data_completed_killed$checkpoint[i3] = checkpoint
                    data_completed_killed$useful[i3] = useful
                    data_completed_killed$recovery[i3] = 0
                  } else{
                    checkpoint_first = checkpoint_time - remaing_time
                    checkpoint = (checkpoint_first + floor((cross_finish-begin-checkpoint_first)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                    useful = (cross_finish - begin)*cross_jobsize - checkpoint
                    data_completed_killed$checkpoint[i3] = checkpoint
                    data_completed_killed$useful[i3] = useful
                    data_completed_killed$recovery[i3] = 0
                  }
                }
              }
            }
            job_cross_begin_remove <- append(job_cross_begin_remove,i0)
            break
          }
        }
      }
      job_cross_begin = job_cross_begin[-job_cross_begin_remove] 
      job_cross_begin_remove = vector()
    }
    
    
    
    
    
    # deal with jobs cross the end bound
    data_cross_end <- data %>% filter(data[,9] < end & data[,11] > end) #starting_time before bound_end and finish_time after bound_end
    job_cross_end_remove=vector()
    job_cross_end = data_cross_end[,1]
    
    if(length(job_cross_end)>0)
    {
      for(i0 in 1:length(job_cross_end)){
        for(i4 in 1:length(data_w0_successful$job_id)){
          # if(grepl(job_cross_end[i0], data_w0_successful$job_id[i4])){
          if(job_cross_end[i0] == data_w0_successful$job_id[i4]){
            # jobs cross the end bound is in data_w0_successful, we should recompute its usefultime and so on
            cross_delay = data_w0_successful$execution_time[i4]
            cross_start = data_w0_successful$starting_time[i4]
            cross_finish = data_w0_successful$finish_time[i4]
            cross_T = data_w0_successful$checkpoint_period[i4]
            cross_jobsize = data_w0_successful$requested_number_of_resources[i4]
            remaing_time = end-cross_start - floor((end-cross_start)/(cross_T+checkpoint_time))*(cross_T+checkpoint_time)
            if (remaing_time < cross_T){
              Tfirst = cross_T - remaing_time
              checkpoint = (checkpoint_time + floor((cross_finish-end-Tfirst-checkpoint_time)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
              useful = (cross_finish - end)*cross_jobsize - checkpoint
              data_w0_successful$checkpoint[i4] =  data_w0_successful$checkpoint[i4] - checkpoint #This is the cross_end, the reverse case of cross_begin
              data_w0_successful$useful[i4] = data_w0_successful$useful[i4] - useful #This is the cross_end, the reverse case of cross_begin
            } else{
              checkpoint_first = checkpoint_time - remaing_time
              checkpoint = (checkpoint_first + floor((cross_finish-end-checkpoint_first)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
              useful = (cross_finish - end)*cross_jobsize - checkpoint
              data_w0_successful$checkpoint[i4] = data_w0_successful$checkpoint[i4] - checkpoint
              data_w0_successful$useful[i4] = data_w0_successful$useful[i4] - useful
            }
            job_cross_end_remove <- append(job_cross_end_remove,i0)
            break
          }
        }
      }
      job_cross_end = job_cross_end[-job_cross_end_remove] 
      job_cross_end_remove = vector()
    }
    
    if(length(job_cross_end)>0)
    {
      for(i0 in 1:length(job_cross_end)){
        for(i5 in 1:length(data_real_completed_successfully_jobcopy$id)){
          # if(grepl(job_cross_end[i0], data_real_completed_successfully_jobcopy$id[i5])){
          if(job_cross_end[i0] == data_real_completed_successfully_jobcopy$id[i5]){
            # jobs cross the end bound is in data_real_completed_successfully_jobcopy, we should recompute its usefultime and so on
            cross_delay = (data %>% filter(data$job_id == job_cross_end[i0]))$execution_time
            cross_start = (data %>% filter(data$job_id == job_cross_end[i0]))$starting_time
            cross_finish = (data %>% filter(data$job_id == job_cross_end[i0]))$finish_time
            cross_jobsize = (data %>% filter(data$job_id == job_cross_end[i0]))$requested_number_of_resources
            cross_T = sqrt(2*checkpoint_time/(total_failure_rate*cross_jobsize))
            cross_Rfirst =  data_real_completed_successfully_jobcopy$Rfirst[i5]
            cross_Tfirst =  data_real_completed_successfully_jobcopy$Tfirst[i5]
            if (end - cross_start < cross_Rfirst){
              recovery = data_real_completed_successfully_jobcopy$recovery[i5] - (end - cross_start)*cross_jobsize
              data_real_completed_successfully_jobcopy$recovery[i5] = data_real_completed_successfully_jobcopy$recovery[i5] - recovery
              data_real_completed_successfully_jobcopy$useful[i5] = 0
              data_real_completed_successfully_jobcopy$checkpoint[i5] = 0
            } else if(cross_Rfirst < end - cross_start & end - cross_start < cross_Rfirst + cross_Tfirst){
              useful = data_real_completed_successfully_jobcopy$useful[i5] - (end - cross_start - cross_Rfirst)*cross_jobsize
              data_real_completed_successfully_jobcopy$useful[i5] = data_real_completed_successfully_jobcopy$useful[i5] - useful
              data_real_completed_successfully_jobcopy$checkpoint[i5] = 0
            } else if(cross_Rfirst + cross_Tfirst < end - cross_start & end - cross_start < cross_Rfirst + cross_Tfirst+checkpoint_time){
              useful = data_real_completed_successfully_jobcopy$useful[i5] - cross_Tfirst*cross_jobsize
              checkpoint = data_real_completed_successfully_jobcopy$checkpoint[i5] - (end - cross_start - cross_Rfirst - cross_Tfirst)*cross_jobsize
              data_real_completed_successfully_jobcopy$checkpoint[i5] = data_real_completed_successfully_jobcopy$checkpoint[i5] - checkpoint
              data_real_completed_successfully_jobcopy$useful[i5] = data_real_completed_successfully_jobcopy$useful[i5] - useful
            } else{
              t1 = cross_Rfirst + cross_Tfirst+checkpoint_time
              remaing_time = end-cross_start-t1 - floor((end-cross_start-t1)/(cross_T+checkpoint_time))*(cross_T+checkpoint_time)
              if (remaing_time < cross_T){
                Tfirst = cross_T - remaing_time
                checkpoint = (checkpoint_time + floor((cross_finish-end-Tfirst-checkpoint_time)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                useful = (cross_finish - end)*cross_jobsize - checkpoint
                data_real_completed_successfully_jobcopy$checkpoint[i5] = data_real_completed_successfully_jobcopy$checkpoint[i5] - checkpoint
                data_real_completed_successfully_jobcopy$useful[i5] = data_real_completed_successfully_jobcopy$useful[i5] - useful
              } else{
                checkpoint_first = checkpoint_time - remaing_time
                checkpoint = (checkpoint_first + floor((cross_finish-end-checkpoint_first)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                useful = (cross_finish - end)*cross_jobsize - checkpoint
                data_real_completed_successfully_jobcopy$checkpoint[i5] = data_real_completed_successfully_jobcopy$checkpoint[i5] - checkpoint
                data_real_completed_successfully_jobcopy$useful[i5] = data_real_completed_successfully_jobcopy$useful[i5] - useful
              }
            }
            job_cross_end_remove <- append(job_cross_end_remove,i0)
            break
          }
        }
      }
      job_cross_end = job_cross_end[-job_cross_end_remove] 
      job_cross_end_remove = vector()
    }
    
    if(length(job_cross_end)>0)
    {
      for(i0 in 1:length(job_cross_end)){
        for(i6 in 1:length(data_completed_killed$id)){
          # if(grepl(job_cross_end[i0], data_completed_killed$id[i6])){
          if(job_cross_end[i0] == data_completed_killed$id[i6]){
            # jobs cross the end bound is in data_completed_killed, we should recompute its usefultime and so on
            cross_delay = (data %>% filter(data$job_id == job_cross_end[i0]))$execution_time
            cross_start = (data %>% filter(data$job_id == job_cross_end[i0]))$starting_time
            cross_finish = (data %>% filter(data$job_id == job_cross_end[i0]))$finish_time
            cross_jobsize = (data %>% filter(data$job_id == job_cross_end[i0]))$requested_number_of_resources
            cross_T = sqrt(2*checkpoint_time/(total_failure_rate*cross_jobsize))
            cross_Rfirst =  data_completed_killed$Rfirst[i6]
            cross_Tfirst =  data_completed_killed$Tfirst[i6]
            
            if (data_completed_killed$priority[i6] ==2){
              cross_wastefailure = data_completed_killed$waste_failure[i6]
              if ((cross_finish-end)*cross_jobsize < cross_wastefailure){
                cross_wastefailure = (cross_finish-end)*cross_jobsize
                data_completed_killed$waste_failure[i6] = data_completed_killed$waste_failure[i6] - cross_wastefailure
              } else{
                if (end - cross_start < cross_Rfirst){
                  recovery = data_completed_killed$recovery[i6] - (end - cross_start)*cross_jobsize
                  data_completed_killed$recovery[i6] = data_completed_killed$recovery[i6] - recovery
                  data_completed_killed$useful[i6] = 0
                  data_completed_killed$checkpoint[i6] = 0
                } else if(cross_Rfirst < end - cross_start & end - cross_start < cross_Rfirst + cross_Tfirst){
                  useful = data_completed_killed$useful[i6] - (end - cross_start - cross_Rfirst)*cross_jobsize
                  data_completed_killed$useful[i6] = data_completed_killed$useful[i6] - useful
                  data_completed_killed$checkpoint[i6] = 0
                } else if(cross_Rfirst + cross_Tfirst < end - cross_start & end - cross_start < cross_Rfirst + cross_Tfirst+checkpoint_time){
                  useful = data_completed_killed$useful[i6] - cross_Tfirst*cross_jobsize
                  checkpoint = data_completed_killed$checkpoint[i6] - (end - cross_start - cross_Rfirst - cross_Tfirst)*cross_jobsize
                  data_completed_killed$checkpoint[i6] = data_completed_killed$checkpoint[i6] - checkpoint
                  data_completed_killed$useful[i6] = data_completed_killed$useful[i6] - useful
                } else{
                  t1 = cross_Rfirst + cross_Tfirst+checkpoint_time
                  remaing_time = end-cross_start-t1 - floor((end-cross_start-t1)/(cross_T+checkpoint_time))*(cross_T+checkpoint_time)
                  if (remaing_time < cross_T){
                    Tfirst = cross_T - remaing_time
                    checkpoint = (checkpoint_time + floor((cross_finish-end-Tfirst-checkpoint_time)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                    useful = (cross_finish - end)*cross_jobsize - checkpoint
                    data_completed_killed$checkpoint[i6] = data_completed_killed$checkpoint[i6] - checkpoint
                    data_completed_killed$useful[i6] = data_completed_killed$useful[i6] - useful
                  } else{
                    checkpoint_first = checkpoint_time - remaing_time
                    checkpoint = (checkpoint_first + floor((cross_finish-end-checkpoint_first)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                    useful = (cross_finish - end)*cross_jobsize - checkpoint
                    data_completed_killed$checkpoint[i6] = data_completed_killed$checkpoint[i6] - checkpoint
                    data_completed_killed$useful[i6] = data_completed_killed$useful[i6] - useful
                  }
                }
              }
            } else{
              cross_wastenode = data_completed_killed$waste_node[i6]
              if ((cross_finish-end)*cross_jobsize < cross_wastenode){
                cross_wastenode = (cross_finish-end)*cross_jobsize
                data_completed_killed$waste_node[i6] = data_completed_killed$waste_node[i6] - cross_wastenode
              } else{
                if (end - cross_start < cross_Rfirst){
                  recovery = data_completed_killed$recovery[i6] - (end - cross_start)*cross_jobsize
                  data_completed_killed$recovery[i6] = data_completed_killed$recovery[i6] - recovery
                  data_completed_killed$useful[i6] = 0
                  data_completed_killed$checkpoint[i6] = 0
                } else if(cross_Rfirst < end - cross_start & end - cross_start < cross_Rfirst + cross_Tfirst){
                  useful = data_completed_killed$useful[i6] - (end - cross_start - cross_Rfirst)*cross_jobsize
                  data_completed_killed$useful[i6] = data_completed_killed$useful[i6] - useful
                  data_completed_killed$checkpoint[i6] = 0
                } else if(cross_Rfirst + cross_Tfirst < end - cross_start & end - cross_start < cross_Rfirst + cross_Tfirst+checkpoint_time){
                  useful = data_completed_killed$useful[i6] - cross_Tfirst*cross_jobsize
                  checkpoint = data_completed_killed$checkpoint[i6] - (end - cross_start - cross_Rfirst - cross_Tfirst)*cross_jobsize
                  data_completed_killed$checkpoint[i6] = data_completed_killed$checkpoint[i6] - checkpoint
                  data_completed_killed$useful[i6] = data_completed_killed$useful[i6] - useful
                } else{
                  t1 = cross_Rfirst + cross_Tfirst+checkpoint_time
                  remaing_time = end-cross_start-t1 - floor((end-cross_start-t1)/(cross_T+checkpoint_time))*(cross_T+checkpoint_time)
                  if (remaing_time < cross_T){
                    Tfirst = cross_T - remaing_time
                    checkpoint = (checkpoint_time + floor((cross_finish-end-Tfirst-checkpoint_time)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                    useful = (cross_finish - end)*cross_jobsize - checkpoint
                    data_completed_killed$checkpoint[i6] = data_completed_killed$checkpoint[i6] - checkpoint
                    data_completed_killed$useful[i6] = data_completed_killed$useful[i6] - useful
                  } else{
                    checkpoint_first = checkpoint_time - remaing_time
                    checkpoint = (checkpoint_first + floor((cross_finish-end-checkpoint_first)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
                    useful = (cross_finish - end)*cross_jobsize - checkpoint
                    data_completed_killed$checkpoint[i6] = data_completed_killed$checkpoint[i6] - checkpoint
                    data_completed_killed$useful[i6] = data_completed_killed$useful[i6] - useful
                  }
                }
              }
            }
            job_cross_end_remove <- append(job_cross_end_remove,i0)
            break
          }
        }
      }
      job_cross_end = job_cross_end[-job_cross_end_remove] 
      job_cross_end_remove = vector()
    }
    
    
    
    # let's compute the useful utilisation in the bound
    # eventfile = paste("/home/yishu/node-stealing-for-resilience/tmp/batsim-src-stable/events/events_MIRA_MTBF1h_downtime1h_", mm, ".txt", collapse = ", ", sep = "") #!!!
    data_event<-read.table(file = eventfile,header=F,na.strings = c("NA"))
    m=length(data_event[,1])
    events = as.numeric(gsub('[}]', '', data_event[1:m,10]))
    
    #compute the downtime before the begin bound
    i7=1
    downtime_begin = 0
    while(i7<m){
      if(events[i7]<begin){
        if(events[i7+1]<begin){
          downtime_temp1 = events[i7+1] - events[i7]
        } else{
          downtime_temp1 = begin - events[i7]
        }
        downtime_begin = downtime_begin + downtime_temp1
      }
      i7=i7+2
      if(events[i7]>begin){
        break
      }
    }
    
    #compute the downtime before the end bound
    i8=1
    downtime_end = 0
    while(i8<m){
      if(events[i8]<end){
        if(events[i8+1]<end){
          downtime_temp2 = events[i8+1] - events[i8]
        } else{
          downtime_temp2 = end - events[i8]
        }
        downtime_end = downtime_end + downtime_temp2
      }
      i8=i8+2
      if(events[i8]>end){
        break
      }
    }
    
    #compute the downtime between the before bound and the end bound
    downtime_total = downtime_end - downtime_begin
    
    
    #compute the time_computing and time_idle between the before bound and the end bound
    usefultime = sum(data_completed_killed$useful)+sum(data_real_completed_successfully_jobcopy$useful)+sum(data_w0_successful$useful)
    checkpointtime = sum(data_completed_killed$checkpoint)+sum(data_real_completed_successfully_jobcopy$checkpoint)+sum(data_w0_successful$checkpoint)
    waste_failuretime = sum(data_completed_killed$waste_failure)
    waste_nodetime = sum(data_completed_killed$waste_node)
    recoverytime = sum(data_completed_killed$recovery)+sum(data_real_completed_successfully_jobcopy$recovery)
    time_computing = usefultime + checkpointtime + waste_failuretime + waste_nodetime + recoverytime
    time_idle = nb_computing_machines*(end-begin) - time_computing - downtime_total
    
    #compute the decomposing ratio for time_computing and time_idle between the before bound and the end bound
    usefultime_ratio = usefultime/(time_computing+time_idle)
    checkpointtime_ratio = checkpointtime/(time_computing+time_idle)
    waste_failuretime_ratio = waste_failuretime/(time_computing+time_idle)
    waste_nodetime_ratio = waste_nodetime/(time_computing+time_idle)
    recoverytime_ratio = recoverytime/(time_computing+time_idle)
    time_idle_ratio = time_idle/(time_computing+time_idle)
    # time_computig_idle_decompose = c(usefultime_ratio,checkpointtime_ratio,waste_failuretime_ratio,waste_nodetime_ratio,recoverytime_ratio,time_idle_ratio)
    # print(time_computig_idle_decompose)
    utilization_ratio_eachsimulation[nn,mm+1]=usefultime_ratio
    
    time_computig_idle_decompose[mm+1,1] = usefultime_ratio
    time_computig_idle_decompose[mm+1,2] = checkpointtime_ratio
    time_computig_idle_decompose[mm+1,3] = waste_failuretime_ratio
    time_computig_idle_decompose[mm+1,4] = waste_nodetime_ratio
    time_computig_idle_decompose[mm+1,5] = recoverytime_ratio
    time_computig_idle_decompose[mm+1,6] = time_idle_ratio
    
    
    #compute the decomposing ratio for time_computing, time_idle and downtime between the before bound and the end bound
    usefultime_ratio_all = usefultime/(time_computing+time_idle+downtime_total)
    checkpointtime_ratio_all = checkpointtime/(time_computing+time_idle+downtime_total)
    waste_failuretime_ratio_all = waste_failuretime/(time_computing+time_idle+downtime_total)
    waste_nodetime_ratio_all = waste_nodetime/(time_computing+time_idle+downtime_total)
    recoverytime_ratio_all = recoverytime/(time_computing+time_idle+downtime_total)
    time_idle_ratio_all = time_idle/(time_computing+time_idle+downtime_total)
    downtime_total_all = downtime_total/(time_computing+time_idle+downtime_total)
    # time_computig_idle_downtime_decompose = c(usefultime_ratio_all,checkpointtime_ratio_all,waste_failuretime_ratio_all,waste_nodetime_ratio_all,recoverytime_ratio_all,time_idle_ratio_all,downtime_total_all)
    # print(time_computig_idle_downtime_decompose)
    
    time_computig_idle_downtime_decompose[mm+1,1] = usefultime_ratio_all
    time_computig_idle_downtime_decompose[mm+1,2] = checkpointtime_ratio_all
    time_computig_idle_downtime_decompose[mm+1,3] = waste_failuretime_ratio_all
    time_computig_idle_downtime_decompose[mm+1,4] = waste_nodetime_ratio_all
    time_computig_idle_downtime_decompose[mm+1,5] = recoverytime_ratio_all
    time_computig_idle_downtime_decompose[mm+1,6] = time_idle_ratio_all
    time_computig_idle_downtime_decompose[mm+1,7] = downtime_total_all
  }
}
time_computig_idle_decompose_mean = apply(time_computig_idle_decompose,2,mean)
time_computig_idle_downtime_decompose_mean = apply(time_computig_idle_downtime_decompose,2,mean)

utilization_gain_fixMTBF = utilization_ratio_eachsimulation[2,]/utilization_ratio_eachsimulation[1,]
utilization_gain_eachMTBF = append(utilization_gain_eachMTBF,utilization_gain_fixMTBF)
# }
utilization_ratio_eachsimulation_mean = apply(utilization_ratio_eachsimulation*100,1,mean)
for (i in 1:length(utilization_ratio_eachsimulation_mean)){
  cat(utilization_ratio_eachsimulation_mean[i])
  cat(",")
}

