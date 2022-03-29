# setwd("../expe-out_MIRA_2017June_MTBF1h_downtime1h_only_conservativebf")
setwd("../expe-out_MIRA_2018March_MTBF1h_downtime1h_only_conservativebf")
# rm(list=ls())
library(ggplot2)
library(dplyr)
# event_repeated_times=5
MTBF = 3600
nb_computing_machines = 49152
total_failure_rate = 1/(MTBF*nb_computing_machines)
checkpoint_time = 300
# begin = 10*24*3600
# end = 30*24*3600

# for(mm in 0:(event_repeated_times-1)){
mm=0
datafile = paste("./expe_", mm, "_0_jobs.csv", collapse = ", ", sep = "")

data <- read.csv(file = datafile, header=T,stringsAsFactors = FALSE)

data_w0_successful <- data %>% filter(data[,2] == "w0" & data[,8] == "COMPLETED_SUCCESSFULLY")

data_w0_successful=data_w0_successful[order(data_w0_successful$submission_time),]

begin = 0.2*max(data_w0_successful$submission_time)
end = 0.8*max(data_w0_successful$submission_time)

data_remove_begin <- data %>% filter(data$submission_time < begin) #start_time before bound_begin
job_list_removebegin = data_remove_begin[,1]
for (i in 1:length(job_list_removebegin)){
  data_w0_successful = data_w0_successful[data_w0_successful$job_id!=job_list_removebegin[i], ]
}

data_remove_end <- data %>% filter(data$submission_time > end) #finish_time after bound_begin
job_list_removeend = data_remove_end[,1]
for (i in 1:length(job_list_removeend)){
  data_w0_successful = data_w0_successful[data_w0_successful$job_id!=job_list_removeend[i], ]
}

# data_jobfristsucceed = data_w0_successful
data_w0_successful <- data_w0_successful%>%dplyr::mutate(flow =  as.numeric(data_w0_successful[,11]) - as.numeric(data_w0_successful[,4])) 
data_w0_successful_flow = select(data_w0_successful,c(1,5,18))

new_data = data_w0_successful_flow
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

max_heuristic_withoutfailure = c(max_flow1_heuristic,max_flow2_heuristic,max_flow4_heuristic,max_flow8_heuristic,max_flow16_heuristic,max_flow32_heuristic,max_flow64_heuristic,max_flow128_heuristic,max_flow256_heuristic,max_flow_all_heuristic)
mean_heuristic_withoutfailure = c(mean_flow1_heuristic,mean_flow2_heuristic,mean_flow4_heuristic,mean_flow8_heuristic,mean_flow16_heuristic,mean_flow32_heuristic,mean_flow64_heuristic,mean_flow128_heuristic,mean_flow256_heuristic,mean_flow_all_heuristic,weighted_mean_flow_all_heuristic)

strategy_max_withoutfailure = c(rep(c(rep("withoutfailure", times=10)),times=1))
strategy_mean_withoutfailure = c(rep(c(rep("withoutfailure", times=11)),times=1))

# }


