# setwd("../test_MIRA_2017June_MTBF1h_downtime1h")
setwd("../test_MIRA_2018March_MTBF1h_downtime1h")

rm(list=ls())

node_stealing_times_inbound_failure_times_repeat=vector()
node_stealing_times_inbound_nodesteal_times_repeat=vector()
event_repeated_times=5
begin = 10*24*3600
end = 30*24*3600
for(mm in 0:(event_repeated_times-1)){
# mm=2
  node_stealing_times_file = paste("./node_stealing_times_", mm, "_111.txt", collapse = ", ", sep = "")
  node_stealing_times<-read.table(file = node_stealing_times_file,header=F,na.strings = c("NA"))
  
  # datafile = paste("./expe_", mm, "_0_jobs.csv", collapse = ", ", sep = "")
  # data <- read.csv(file = datafile, header=T,stringsAsFactors = FALSE)
  # makespan = max(data$finish_time)
  # begin = makespan*0.1
  # end = makespan*0.9
  
  node_stealing_times_beforebegin <- node_stealing_times %>% filter(node_stealing_times[,2]<begin)
  node_stealing_times_beforebegin_failure <-node_stealing_times_beforebegin%>% filter(node_stealing_times_beforebegin[,3]=="failure")
  node_stealing_times_beforebegin_failure_times=0
  if(length(node_stealing_times_beforebegin_failure[,1])>0){
    node_stealing_times_beforebegin_failure_times = max(node_stealing_times_beforebegin_failure$V4)
  }
  node_stealing_times_beforebegin_nodesteal<-node_stealing_times_beforebegin%>% filter(node_stealing_times_beforebegin[,3]=="nodesteal")
  node_stealing_times_beforebegin_nodesteal_times=0
  if(length(node_stealing_times_beforebegin_nodesteal[,1])>0){
    node_stealing_times_beforebegin_nodesteal_times = max(node_stealing_times_beforebegin_nodesteal$V4)
  }
  
  
  
  node_stealing_times_beforeend <- node_stealing_times %>% filter(node_stealing_times[,2]<end)
  node_stealing_times_beforeend_failure <-node_stealing_times_beforeend%>% filter(node_stealing_times_beforeend[,3]=="failure")
 
  node_stealing_times_beforeend_failure_times=0
  if(length(node_stealing_times_beforeend_failure[,1])>0){
    node_stealing_times_beforeend_failure_times = max(node_stealing_times_beforeend_failure$V4)
  }
  
  
  node_stealing_times_beforeend_nodesteal<-node_stealing_times_beforeend%>% filter(node_stealing_times_beforeend[,3]=="nodesteal")
  node_stealing_times_beforeend_nodesteal_times=0
  if(length(node_stealing_times_beforeend_nodesteal[,1])>0){
    node_stealing_times_beforeend_nodesteal_times = max(node_stealing_times_beforeend_nodesteal$V4)
  }

  node_stealing_times_inbound_failure_times = node_stealing_times_beforeend_failure_times - node_stealing_times_beforebegin_failure_times
  node_stealing_times_inbound_nodesteal_times = node_stealing_times_beforeend_nodesteal_times - node_stealing_times_beforebegin_nodesteal_times

  node_stealing_times_inbound_failure_times_repeat=append(node_stealing_times_inbound_failure_times_repeat,node_stealing_times_inbound_failure_times)
  node_stealing_times_inbound_nodesteal_times_repeat =append(node_stealing_times_inbound_nodesteal_times_repeat,node_stealing_times_inbound_nodesteal_times)
}
node_stealing_times_inbound_failure_times_mean=mean(node_stealing_times_inbound_failure_times_repeat)
node_stealing_times_inbound_nodesteal_times_mean=mean(node_stealing_times_inbound_nodesteal_times_repeat)
print(node_stealing_times_inbound_nodesteal_times_mean)
print(node_stealing_times_inbound_failure_times_mean-node_stealing_times_inbound_nodesteal_times_mean)
print(node_stealing_times_inbound_failure_times_mean)
