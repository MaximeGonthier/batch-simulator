# setwd("../test_MIRA_2017June_MTBF1h_downtime1h_allheuristics")
setwd("../test_MIRA_2018March_MTBF1h_downtime1h_allheuristics")

rm(list=ls())
library("rjson")
library("xtable")
library(ggplot2)

heuristic_choice = c("0","111","112","113","121","122","123","211","212","213","221","222","223","311","312","313","321","322","323")
# heuristic_choice = c("0","111")
event_repeated_times=5
no_idle_processor_ratio_eachsimulation = matrix(0,length(heuristic_choice),event_repeated_times)

# no_idle_processor_ratio_repeat=vector()
begin = 10*24*3600
end = 30*24*3600
for(mm in 0:(event_repeated_times-1)){
  # mm=1
  print(mm)
  for(nn in 1:length(heuristic_choice)){
    print(nn)
    datafile = paste("./expe_", mm, "_",heuristic_choice[nn],"_machine_states.csv", collapse = ", ", sep = "")
    data <- read.csv(file=datafile, header=T,stringsAsFactors = FALSE)
    # makespan=max(data$time)
    # begin =0.1*makespan
    # end=0.9*makespan
    data_inbound <- data %>% filter(data[,1]>begin &data[,1]<end)
    row_numbers = which(data_inbound$nb_idle==0, arr.ind = TRUE)
    no_idle_time = data_inbound[row_numbers+1,1]-data_inbound[row_numbers,1]
    if(is.na(no_idle_time[length(no_idle_time)])){
      no_idle_time[length(no_idle_time)] = end - data_inbound[row_numbers[length(row_numbers)],1]
    }
    
    no_idle_processor_ratio = sum(no_idle_time)/data_inbound[nrow(data_inbound),1]
    
    no_idle_processor_ratio_eachsimulation[nn,mm+1] = 1 - no_idle_processor_ratio
  }
}

no_idle_processor_ratio_eachsimulation_mean = apply(no_idle_processor_ratio_eachsimulation*100,1,mean)
for (i in 1:length(no_idle_processor_ratio_eachsimulation_mean)){
  cat(no_idle_processor_ratio_eachsimulation_mean[i])
  cat(",")
}
