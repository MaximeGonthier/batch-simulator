# setwd("../test_MIRA_2017June_MTBF1h_downtime1h_allheuristics")
setwd("../test_MIRA_2018March_MTBF1h_downtime1h_allheuristics")
library("dplyr")
rm(list=ls())

# node_stealing_times_inbound_failure_times_repeat=vector()
# node_stealing_times_inbound_nodesteal_times_repeat=vector()
event_repeated_times=5

heuristic_choice = c("111","112","113","121","122","123","211","212","213","221","222","223","311","312","313","321","322","323")
# heuristic_choice = c("111")

nodesteal_times = matrix(0,length(heuristic_choice),event_repeated_times)
# empty_procesor_used = matrix(0,length(heuristic_choice),event_repeated_times)
failure_times = matrix(0,length(heuristic_choice),event_repeated_times)
begin = 10*24*3600
end = 30*24*3600

for(mm in 0:(event_repeated_times-1)){
  # mm=2
  # node_stealing_times_file = paste("./node_stealing_times_", mm, "_111.txt", collapse = ", ", sep = "")
  print(mm)
  for(nn in 1:length(heuristic_choice)){
    print(nn)
    node_stealing_times_file = paste("./node_stealing_times_", mm, "_",heuristic_choice[nn],".txt", collapse = ", ", sep = "")
    node_stealing_times<-read.table(file = node_stealing_times_file,header=F,na.strings = c("NA"))
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
    
    # node_stealing_times_inbound_failure_times_repeat=append(node_stealing_times_inbound_failure_times_repeat,node_stealing_times_inbound_failure_times)
    # node_stealing_times_inbound_nodesteal_times_repeat =append(node_stealing_times_inbound_nodesteal_times_repeat,node_stealing_times_inbound_nodesteal_times)

    nodesteal_times[nn,mm+1] = node_stealing_times_inbound_nodesteal_times
    failure_times[nn,mm+1] = node_stealing_times_inbound_failure_times
  }
}
nodesteal_times_mean = apply(nodesteal_times,1,mean)
failure_times_mean = apply(failure_times,1,mean)
empty_procesor_used_mean = failure_times_mean - nodesteal_times_mean

for (i in 1:length(nodesteal_times_mean)){
  cat(nodesteal_times_mean[i])
  cat(",")
}
cat("\n")
for (i in 1:length(empty_procesor_used_mean)){
  cat(empty_procesor_used_mean[i])
  cat(",")
}
cat("\n")
for (i in 1:length(failure_times_mean)){
  cat(failure_times_mean[i])
  cat(",")
}
