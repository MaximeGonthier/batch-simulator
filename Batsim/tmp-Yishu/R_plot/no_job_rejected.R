rm(list=ls())
library(ggplot2)
library(dplyr)
data_choice = c("2017June","2018March")
for(ll in 1:length(data_choice)){
  date = data_choice[ll]
  downtime_choice = c("downtime10min","downtime1h","downtime1day")
  for(mm in 1:length(downtime_choice)){
    downtime = downtime_choice[mm]
    event_choice = c("20min","40min","1h","2h","5h","10h")
    # kk=1
    for(kk in 1:length(event_choice)){
      wdfile = paste("/home/yishu/MIRA_simulation_data1214/MIRA", date,"/test_MIRA_", date,"_MTBF", event_choice[kk],"_", downtime, collapse = ", ", sep = "")
      setwd(wdfile)
      
      event_repeat_times=5
      # nn=0
      for(nn in 0:(event_repeat_times-1)){
        filename0=paste("expe", nn, "0_jobs.csv", collapse = ", ", sep = "_")
        filename111=paste("expe", nn, "111_jobs.csv", collapse = ", ", sep = "_")
        files<-c(filename0, filename111)
        
        # ii=1
        for (ii in 1:length(files)){
          data <- read.csv(file=files[ii], header=T,stringsAsFactors = FALSE)
          data_rejected <- data %>% filter(data$final_state == "REJECTED")
          if(nrow(data_rejected)>0){
            print("Job rejected")
            print(ll)
            print(mm)
            print(kk)
            print(nn)
            print(ii)
          }
        }
      }
    }
  }
}

data_choice = c("2017June","2018March")
for(ll in 1:length(data_choice)){
  date = data_choice[ll]
  wdfile = paste("/home/yishu/MIRA_simulation_data1214/MIRA", date,"/test_MIRA_", date,"_MTBF1h_downtime1h_allheuristics", collapse = ", ", sep = "")
  setwd(wdfile)
  
  event_repeat_times=5
  # nn=0
  for(nn in 0:(event_repeat_times-1)){
    filename0=paste("expe", nn, "0_jobs.csv", collapse = ", ", sep = "_")
    filename111=paste("expe", nn, "111_jobs.csv", collapse = ", ", sep = "_")
    filename112=paste("expe", nn, "112_jobs.csv", collapse = ", ", sep = "_")
    filename113=paste("expe", nn, "113_jobs.csv", collapse = ", ", sep = "_")
    filename121=paste("expe", nn, "121_jobs.csv", collapse = ", ", sep = "_")
    filename122=paste("expe", nn, "122_jobs.csv", collapse = ", ", sep = "_")
    filename123=paste("expe", nn, "123_jobs.csv", collapse = ", ", sep = "_")
    
    filename211=paste("expe", nn, "211_jobs.csv", collapse = ", ", sep = "_")
    filename212=paste("expe", nn, "212_jobs.csv", collapse = ", ", sep = "_")
    filename213=paste("expe", nn, "213_jobs.csv", collapse = ", ", sep = "_")
    filename221=paste("expe", nn, "221_jobs.csv", collapse = ", ", sep = "_")
    filename222=paste("expe", nn, "222_jobs.csv", collapse = ", ", sep = "_")
    filename223=paste("expe", nn, "223_jobs.csv", collapse = ", ", sep = "_")
    
    filename311=paste("expe", nn, "311_jobs.csv", collapse = ", ", sep = "_")
    filename312=paste("expe", nn, "312_jobs.csv", collapse = ", ", sep = "_")
    filename313=paste("expe", nn, "313_jobs.csv", collapse = ", ", sep = "_")
    filename321=paste("expe", nn, "321_jobs.csv", collapse = ", ", sep = "_")
    filename322=paste("expe", nn, "322_jobs.csv", collapse = ", ", sep = "_")
    filename323=paste("expe", nn, "323_jobs.csv", collapse = ", ", sep = "_")
    files<-c(filename0, filename111, filename112, filename113, filename121, filename122, filename123, filename211, filename212, filename213, filename221, filename222, filename223, filename311, filename312, filename313, filename321, filename322, filename323)
    
    # ii=1
    for (ii in 1:length(files)){
      data <- read.csv(file=files[ii], header=T,stringsAsFactors = FALSE)
      data_rejected <- data %>% filter(data$final_state == "REJECTED")
      if(nrow(data_rejected)>0){
        print("Job rejected")
        print(ll)
        print(nn)
        print(ii)
      }
    }
  }
}










      
      