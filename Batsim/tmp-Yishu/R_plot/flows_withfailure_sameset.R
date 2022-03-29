# setwd("../test_MIRA_2017June_MTBF1h_downtime1h")
setwd("../test_MIRA_2018March_MTBF1h_downtime1h")

# rm(list=ls())
library(ggplot2)
library(dplyr)
event_repeat_times=5
# begin = 10*24*3600
# end = 30*24*3600

max_all_withfailure = vector()
mean_all_withfailure = vector()

for(nn in 0:(event_repeat_times-1)){
  max_heuristic_all = vector()
  mean_heuristic_all = vector()
  filename0=paste("expe", nn, "0_jobs.csv", collapse = ", ", sep = "_")
  # filename111=paste("expe", nn, "111_jobs.csv", collapse = ", ", sep = "_")
  # files<-c(filename0, filename111)
  files<-c(filename0)
  for (ii in 1:1){
    data <- read.csv(file=files[ii], header=T,stringsAsFactors = FALSE)
    # filename=paste("expe", nn, "0_jobs.csv", collapse = ", ", sep = "_")
    # data <- read.csv(file=filename, header=T,stringsAsFactors = FALSE)
    data <- data %>% filter(data$final_state != "COMPLETED_WALLTIME_REACHED")
    w0_job = data %>% filter(data$workload_name == "w0")
    
    w0_job=w0_job[order(w0_job$submission_time),]
    
    begin = 0.2*max(w0_job$submission_time)
    end = 0.8*max(w0_job$submission_time)
    
    # data_remove_begin <- w0_job %>% filter(w0_job$submission_time < begin) #start_time before bound_begin
    # data_remove_end <- w0_job %>% filter(w0_job$submission_time > end) #finish_time after bound_begin
    data_remove_job =  w0_job %>% filter(w0_job$submission_time < begin | w0_job$submission_time > end)
    
    
    # data_lastjobcopy = data %>% filter(data$workload_name=="resubmit" & data$final_state=="COMPLETED_SUCCESSFULLY")
    # w0_job_submitbeforebegin = w0_job %>% filter(w0_job$starting_time < begin)
    #First, we remove data_remove_job_succeed
    data_remove_job_succeed = data_remove_job %>% filter(data_remove_job$final_state == "COMPLETED_SUCCESSFULLY") 
    
    for (i0 in 1:length(data_remove_job_succeed$job_id)){
      job_remove_temp = data_remove_job_succeed$job_id[i0]
      # print(job_remove_temp)
      data = data %>% filter(data$job_id != job_remove_temp)
    }
    
    #Second, we remove data_remove_job_killed and their job copies
    data_remove_job_killed = data_remove_job %>% filter(data_remove_job$final_state == "COMPLETED_KILLED") 
    data_lastjobcopy = data %>% filter(data$workload_name=="resubmit" & data$final_state=="COMPLETED_SUCCESSFULLY")
    job_remove_killed = data_remove_job_killed$job_id
    for(i1 in 1:length(job_remove_killed)){
      job_remove = job_remove_killed[i1]
      # print("original job")
      # print(job_remove)
      data = data %>% filter(data$job_id != job_remove) #The original job should be removed like 29028
      for (i2 in 1:length(data_lastjobcopy$job_id)){
        if (grepl(job_remove,data_lastjobcopy$job_id[i2])){
          job_remove_split = strsplit(data_lastjobcopy$job_id[i2], "-")
          resubmit_times = as.numeric(job_remove_split[[1]][2])
          for (i3 in 1:resubmit_times){
            #remove each intermediate job until the last job copt
            job_remove_temp = paste(job_remove, i3, collapse="," ,sep = "-") 
            # print("job copy")
            # print(job_remove_temp)
            data = data %>% filter(data$job_id != job_remove_temp) #The job copy should also be removed like 29028-1 and 29028-2
          }
        }
      }
    }

    data_jobfristsucceed <- data %>% filter(data[,2] == "w0" & as.numeric(data[,7])==1)
    data_jobfristsucceed%>%dplyr::mutate(flow =  as.numeric(data_jobfristsucceed[,11]) - as.numeric(data_jobfristsucceed[,4])) -> data_jobfristsucceed
    data_jobfristsucceed_flow = select(data_jobfristsucceed,c(1,5,18))
    data_jobnotfristsucceed <- data %>% filter(data[,2] != "w0" | as.numeric(data[,7])==0)
    
    m=length(data_jobnotfristsucceed[,1])
    job_id=vector()
    requested_number_of_resources=vector()
    flow=vector()
    for (i in 1:m){
      id = data_jobnotfristsucceed[c(i),c(1)]
      a=grepl('checkpoint',id)
      if(a!=TRUE){
        #not a checkpoint job 
        b=grepl('-',id)
        if (b!=TRUE){
          #not a resubmitted copy job
          # a normal job and not complete successfully in the first normal time
          c=1
          d=paste(id,"-",c,sep = "")
          for (j in (i+1):m){
            if(j>m){
              break
            }
            if(data_jobnotfristsucceed[c(j),c(1)]==d)
            {
              #find the resubmitted copy of the normal job
              if(data_jobnotfristsucceed[c(j),c(7)]==1) #remark: very special job COMPLETED_WALLTIME_REACHED, the completed job copy could never be found
              {
                #the resubmitted copy succeed in the first resubmitted time 
                real_number_id = data_jobnotfristsucceed[c(i),c(1)] #Here is i, because the id/submission time/res is according to the original index like 7
                job_id <- append(job_id,real_number_id)
                submission_time = data_jobnotfristsucceed[c(i),c(4)]
                res = data_jobnotfristsucceed[c(i),c(5)]
                requested_number_of_resources<-append(requested_number_of_resources,res)
                
                finish_time = data_jobnotfristsucceed[c(j),c(11)] #Here is j, because the finish time is according to the final resubmitted index like 7-3
                flow_temp = finish_time - submission_time
                flow <- append(flow,flow_temp)
                break
              }
              else
              {
                #the resubmitted copy not succeed in the first resubmitted time, job id like 7-2
                c=c+1
                d=paste(id,"-",c,sep = "")
              }
            }
          }
        }
      }
    }
    
    data_jobnotfristsucceed_flow <- data.frame(job_id,requested_number_of_resources,flow,stringsAsFactors = FALSE)
    new_data <- rbind(data_jobfristsucceed_flow, data_jobnotfristsucceed_flow)
    
    new_data1 <- new_data %>% filter(as.numeric(new_data[,2]) == 1 )
    max_flow1_heuristic = max(as.numeric(new_data1[,3]))
    mean_flow1_heuristic = mean(as.numeric(new_data1[,3]))
    
    new_data2 <- new_data %>% filter(as.numeric(new_data[,2]) >= 2^1 & as.numeric(new_data[,2]) < 2^3)
    max_flow2_heuristic = max(as.numeric(new_data2[,3]))
    mean_flow2_heuristic = mean(as.numeric(new_data2[,3]))
    
    new_data4 <- new_data %>% filter(as.numeric(new_data[,2]) >= 2^3 & as.numeric(new_data[,2]) < 2^5)
    max_flow4_heuristic = max(as.numeric(new_data4[,3]))
    mean_flow4_heuristic = mean(as.numeric(new_data4[,3]))
    
    new_data8 <- new_data %>% filter(as.numeric(new_data[,2]) >= 2^5 & as.numeric(new_data[,2]) < 2^7)
    max_flow8_heuristic = max(as.numeric(new_data8[,3]))
    mean_flow8_heuristic = mean(as.numeric(new_data8[,3]))
    
    new_data16 <- new_data %>% filter(as.numeric(new_data[,2]) >= 2^7 & as.numeric(new_data[,2]) < 2^9)
    max_flow16_heuristic = max(as.numeric(new_data16[,3]))
    mean_flow16_heuristic = mean(as.numeric(new_data16[,3]))
    
    new_data32 <- new_data %>% filter(as.numeric(new_data[,2]) >= 2^9 & as.numeric(new_data[,2]) < 2^11)
    max_flow32_heuristic = max(as.numeric(new_data32[,3]))
    mean_flow32_heuristic = mean(as.numeric(new_data32[,3]))
    
    new_data64 <- new_data %>% filter(as.numeric(new_data[,2]) >= 2^11 & as.numeric(new_data[,2]) < 2^13)
    max_flow64_heuristic = max(as.numeric(new_data64[,3]))
    mean_flow64_heuristic = mean(as.numeric(new_data64[,3]))
    
    new_data128 <- new_data %>% filter(as.numeric(new_data[,2]) >= 2^13 & as.numeric(new_data[,2]) < 2^15)
    max_flow128_heuristic = max(as.numeric(new_data128[,3]))
    mean_flow128_heuristic = mean(as.numeric(new_data128[,3]))
    
    # new_data256 <- new_data %>% filter(as.numeric(new_data[,2]) == 2^15)
    new_data256 <- new_data %>% filter(as.numeric(new_data[,2]) >= 2^15 & as.numeric(new_data[,2]) < 2^16)
    max_flow256_heuristic = max(as.numeric(new_data256[,3]))
    mean_flow256_heuristic = mean(as.numeric(new_data256[,3]))
    
    m_heuristic=length(new_data[,1])
    max_flow_all_heuristic = max(as.numeric(new_data[,3]))
    mean_flow_all_heuristic = mean(as.numeric(new_data[,3]))
    weighted_mean_flow_all_heuristic = sum(new_data$requested_number_of_resources*new_data$flow)/sum(new_data$requested_number_of_resources)
    
    max_heuristic_temp = c(max_flow1_heuristic,max_flow2_heuristic,max_flow4_heuristic,max_flow8_heuristic,max_flow16_heuristic,max_flow32_heuristic,max_flow64_heuristic,max_flow128_heuristic,max_flow256_heuristic,max_flow_all_heuristic)
    max_heuristic_all = c(max_heuristic_all,max_heuristic_temp)
    
    mean_heuristic_temp = c(mean_flow1_heuristic,mean_flow2_heuristic,mean_flow4_heuristic,mean_flow8_heuristic,mean_flow16_heuristic,mean_flow32_heuristic,mean_flow64_heuristic,mean_flow128_heuristic,mean_flow256_heuristic,mean_flow_all_heuristic,weighted_mean_flow_all_heuristic)
    mean_heuristic_all = c(mean_heuristic_all,mean_heuristic_temp)
  }
  # print(nn)
  # print(ii)
  
  max_all_withfailure = c(max_all_withfailure,max_heuristic_all)
  mean_all_withfailure = c(mean_all_withfailure,mean_heuristic_all)
  
  # print(max_all)
}

strategy_max_withfailure = c(rep(c(rep("withfailure", times=10)),times=event_repeat_times))
strategy_mean_withfailure = c(rep(c(rep("withfailure", times=11)),times=event_repeat_times))
