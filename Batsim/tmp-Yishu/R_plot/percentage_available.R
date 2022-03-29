setwd("../MIRA2017June/test_MIRA_2017June_MTBF1h_downtime1h")
# setwd("../MIRA2018March/test_MIRA_2018March_MTBF1h_downtime1h")

rm(list=ls())
library("dplyr")
library("rjson")
library("xtable")
library(ggplot2)

event_repeated_times=5
no_idle_processor_ratio_repeat=vector()
begin = 10*24*3600
end = 30*24*3600
for(nn in 0:(event_repeated_times-1)){
# nn=1
  filename=paste("./expe", nn, "0_machine_states.csv", collapse = ", ", sep = "_")
  # filename=paste("./expe", nn, "111_machine_states.csv", collapse = ", ", sep = "_")
  data <- read.csv(file=filename, header=T,stringsAsFactors = FALSE)
  # makespan=max(data$time)
  # begin =0.1*makespan
  # end=0.9*makespan
  data_inbound <- data %>% filter(data[,1]>begin & data[,1]<end)
  row_numbers = which(data_inbound$nb_idle==0, arr.ind = TRUE)
  no_idle_time = data_inbound[row_numbers+1,1]-data_inbound[row_numbers,1]
  #
  if(is.na(no_idle_time[length(no_idle_time)])){
    no_idle_time[length(no_idle_time)] = end - data_inbound[row_numbers[length(row_numbers)],1]
  }
  
  no_idle_processor_ratio = sum(no_idle_time)/data_inbound[nrow(data_inbound),1]
  no_idle_processor_ratio_repeat = append(no_idle_processor_ratio_repeat,no_idle_processor_ratio)
}
print(1-mean(no_idle_processor_ratio_repeat))

