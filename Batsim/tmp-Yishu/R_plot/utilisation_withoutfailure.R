# setwd("/home/yishu/MIRA_simulation_data1214/MIRA2017June/test_MIRA_2017June_MTBF1h_downtime1h_only_conservativebf")
setwd("/home/yishu/MIRA_simulation_data1214//MIRA2018March/test_MIRA_2018March_MTBF1h_downtime1h_only_conservativebf")
rm(list=ls())
library(ggplot2)
library(dplyr)
event_repeated_times=5
MTBF = 3600
nb_computing_machines = 49152
total_failure_rate = 1/(MTBF*nb_computing_machines)
checkpoint_time = 300
begin = 10*24*3600
end = 30*24*3600

time_computig_idle_decompose = matrix(0,event_repeated_times,6)
time_computig_idle_downtime_decompose = matrix(0,event_repeated_times,7)

# names(time_computig_idle_decompose)<-c("usefultime_ratio","checkpointtime_ratio","waste_failuretime_ratio","waste_nodetime_ratio","recoverytime_ratio","time_idle_ratio")
# names(time_computig_idle_downtime_decompose)<-c("usefultime_ratio_all","checkpointtime_ratio_all","waste_failuretime_ratio_all","waste_nodetime_ratio_all","recoverytime_ratio_all","time_idle_ratio_all","downtime_total_all")
usefultime_ratio_repeat =vector()
# for(mm in 0:(event_repeated_times-1)){
  mm=0
  datafile = paste("./expe_", mm, "_0_jobs.csv", collapse = ", ", sep = "")
  # data_completed_killed_file = paste("./COMPLETED_KILLED_", mm, "_0.txt", collapse = ", ", sep = "")
  # data_completed_successfully_jobcopy_file = paste("./COMPLETED_SUCCESSFULLY_JOBCOPY_", mm, "_0.txt", collapse = ", ", sep = "")
  
  # datafile = paste("./expe_", mm, "_111_jobs.csv", collapse = ", ", sep = "")
  # data_completed_killed_file = paste("./COMPLETED_KILLED_", mm, "_111.txt", collapse = ", ", sep = "")
  # data_completed_successfully_jobcopy_file = paste("./COMPLETED_SUCCESSFULLY_JOBCOPY_", mm, "_111.txt", collapse = ", ", sep = "")
  
  data <- read.csv(file = datafile, header=T,stringsAsFactors = FALSE)
  # data_completed_killed<-read.table(file = data_completed_killed_file,header=F,na.strings = c("NA"))
  # data_completed_successfully_jobcopy<-read.table(file = data_completed_successfully_jobcopy_file,header=F,na.strings = c("NA"))
  
  # makespan = max(data$finish_time)
  # begin = makespan*0.1
  # end = makespan*0.9
  # names(data_completed_killed)<-c("id","priority","useful","checkpoint","waste_failure","waste_node","recovery","Tfirst","Rfirst")
  # names(data_completed_successfully_jobcopy)<-c("id","priority","useful","checkpoint","waste_failure","waste_node","recovery","Tfirst","Rfirst")
  data_w0_successful <- data %>% filter(data[,2] == "w0" & data[,8] == "COMPLETED_SUCCESSFULLY")
  # data_resubmit_successful <- data %>% filter(data[,2] == "resubmit" & data[,8] == "COMPLETED_SUCCESSFULLY")
  # checkpoint_period = sqrt((2*checkpoint_time)/(total_failure_rate*data_w0_successful$requested_number_of_resources))
  # data_w0_successful<-cbind(data_w0_successful,checkpoint_period)
  # checkpoint = (floor(data_w0_successful$execution_time/(data_w0_successful$checkpoint_period+checkpoint_time))*checkpoint_time)*data_w0_successful$requested_number_of_resources #[floor(delay/(T+C))*C]*job_size 
  # data_w0_successful<-cbind(data_w0_successful,checkpoint)
  # useful = data_w0_successful$execution_time * data_w0_successful$requested_number_of_resources - data_w0_successful$checkpoint
  # data_w0_successful<-cbind(data_w0_successful,useful)
  useful = data_w0_successful$execution_time * data_w0_successful$requested_number_of_resources
  data_w0_successful<-cbind(data_w0_successful,useful)
  
  #data_completed_successfully_jobcopy generated from C++ should be reduced to data_real_completed_successfully_jobcopy (beacuse c++ writes down each job copy, but it may failed later)
  # job_list = data_resubmit_successful[,1]
  # data_real_completed_successfully_jobcopy=data_completed_successfully_jobcopy %>% filter(data_completed_successfully_jobcopy[,1] == job_list[1])
  # for (i in 2:length(job_list)){
  #   data_real_completed_successfully_jobcopy[i, ]=data_completed_successfully_jobcopy %>% filter(data_completed_successfully_jobcopy[,1] == job_list[i])
  # }
  # remove data_remove_begin from data_completed_killed, data_real_completed_successfully_jobcopy and data_w0_successful
  data_remove_begin <- data %>% filter(data[,11] < begin) #finish_time before bound_begin
  job_list_removebegin = data_remove_begin[,1]
  for (i in 1:length(job_list_removebegin)){
    # data_completed_killed = data_completed_killed[data_completed_killed$id!=job_list_removebegin[i], ]
    # data_real_completed_successfully_jobcopy = data_real_completed_successfully_jobcopy[data_real_completed_successfully_jobcopy$id!=job_list_removebegin[i], ]
    data_w0_successful = data_w0_successful[data_w0_successful$job_id!=job_list_removebegin[i], ]
  }
  # remove data_remove_end from data_completed_killed, data_real_completed_successfully_jobcopy and data_w0_successful
  data_remove_end <- data %>% filter( data[,9]>end) #start_time after bound_begin
  job_list_removeend = data_remove_end[,1]
  for (i in 1:length(job_list_removeend)){
    # data_completed_killed = data_completed_killed[data_completed_killed$id!=job_list_removeend[i], ]
    # data_real_completed_successfully_jobcopy = data_real_completed_successfully_jobcopy[data_real_completed_successfully_jobcopy$id!=job_list_removeend[i], ]
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
          # cross_delay = data_w0_successful$execution_time[i1]
          cross_start = data_w0_successful$starting_time[i1]
          cross_finish = data_w0_successful$finish_time[i1]
          cross_jobsize = data_w0_successful$requested_number_of_resources[i1]
          useful = (cross_finish-begin)*cross_jobsize
          data_w0_successful$useful[i1] = useful
          # cross_T = data_w0_successful$checkpoint_period[i1]
          # cross_jobsize = data_w0_successful$requested_number_of_resources[i1]
          # remaing_time = begin-cross_start - floor((begin-cross_start)/(cross_T+checkpoint_time))*(cross_T+checkpoint_time)
          # if (remaing_time < cross_T){
          #   Tfirst = cross_T - remaing_time
          #   checkpoint = (checkpoint_time + floor((cross_finish-begin-Tfirst-checkpoint_time)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
          #   useful = (cross_finish - begin)*cross_jobsize - checkpoint
          #   data_w0_successful$checkpoint[i1] = checkpoint
          #   data_w0_successful$useful[i1] = useful
          # }                                                                                                                     
          # else{
          #   checkpoint_first = checkpoint_time - remaing_time
          #   checkpoint = (checkpoint_first + floor((cross_finish-begin-checkpoint_first)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
          #   useful = (cross_finish - begin)*cross_jobsize - checkpoint
          #   data_w0_successful$checkpoint[i1] = checkpoint
          #   data_w0_successful$useful[i1] = useful
          # }
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
          # cross_delay = data_w0_successful$execution_time[i4]
          cross_start = data_w0_successful$starting_time[i4]
          cross_finish = data_w0_successful$finish_time[i4]
          cross_jobsize = data_w0_successful$requested_number_of_resources[i4]
          useful = (end - cross_start)*cross_jobsize
          data_w0_successful$useful[i4] = useful
          # cross_T = data_w0_successful$checkpoint_period[i4]
          # cross_jobsize = data_w0_successful$requested_number_of_resources[i4]
          # remaing_time = end-cross_start - floor((end-cross_start)/(cross_T+checkpoint_time))*(cross_T+checkpoint_time)
          # if (remaing_time < cross_T){
          #   Tfirst = cross_T - remaing_time
          #   checkpoint = (checkpoint_time + floor((cross_finish-end-Tfirst-checkpoint_time)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
          #   useful = (cross_finish - end)*cross_jobsize - checkpoint
          #   data_w0_successful$checkpoint[i4] =  data_w0_successful$checkpoint[i4] - checkpoint #This is the cross_end, the reverse case of cross_begin
          #   data_w0_successful$useful[i4] = data_w0_successful$useful[i4] - useful #This is the cross_end, the reverse case of cross_begin
          # }                                                                                                                     
          # else{
          #   checkpoint_first = checkpoint_time - remaing_time
          #   checkpoint = (checkpoint_first + floor((cross_finish-end-checkpoint_first)/(cross_T+checkpoint_time))*checkpoint_time)*cross_jobsize
          #   useful = (cross_finish - end)*cross_jobsize - checkpoint
          #   data_w0_successful$checkpoint[i4] = data_w0_successful$checkpoint[i4] - checkpoint
          #   data_w0_successful$useful[i4] = data_w0_successful$useful[i4] - useful
          # }
          job_cross_end_remove <- append(job_cross_end_remove,i0)
          break
        }
      }
    }
    job_cross_end = job_cross_end[-job_cross_end_remove] 
    job_cross_end_remove = vector()
  }
  
usefultime_ratio = sum(data_w0_successful$useful)/(nb_computing_machines*(end-begin))

# usefultime_ratio_repeat = append(usefultime_ratio_repeat,usefultime_ratio)
# }
print(usefultime_ratio)
# print(mean(usefultime_ratio_repeat))


