#Max flow 32768
xdata <- c(rep("20min", times=10),rep("40min", times=10),rep("1h", times=10),rep("2h", times=10),rep("5h", times=10),rep("10h", times=10))
heuristic <- c(rep(rep(c("h0","h111"),times=5),times=6))

df <- data.frame(xdata,
                 ydata=max_32768_all_eachMTBF,
                 heuristic)

x1 = factor(df$xdata, levels=c("20min", "40min", "1h", "2h", "5h", "10h"))

p<-ggplot(data=df, aes(x=x1,y=ydata,fill=heuristic)) + geom_boxplot(outlier.size = 0.5)+
  stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4)

p

p+ xlab("MTBF") + ylab("max_flow") + theme(axis.title.x = element_text(size = 14, angle = 0),axis.title.y = element_text(size = 14, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) + theme(legend.position = "top") + ylim(0,1500000) 

#weighted mean flow alljobs
xdata <- c(rep("20min", times=10),rep("40min", times=10),rep("1h", times=10),rep("2h", times=10),rep("5h", times=10),rep("10h", times=10))
heuristic <- c(rep(rep(c("h0","h111"),times=5),times=6))

df <- data.frame(xdata,
                 ydata=mean_alljobs_all_eachMTBF_weighted,
                 heuristic)

x1 = factor(df$xdata, levels=c("20min", "40min", "1h", "2h", "5h", "10h"))

p<-ggplot(data=df, aes(x=x1,y=ydata,fill=heuristic)) + geom_boxplot(outlier.size = 0.5)+
  stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4)

p

p+ xlab("MTBF") + ylab("weighted_mean_flow") + theme(axis.title.x = element_text(size = 14, angle = 0),axis.title.y = element_text(size = 14, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) + theme(legend.position = "top") + ylim(0,600000)







#Mean flow alljobs
# xdata <- c(rep("20min", times=10),rep("40min", times=10),rep("1h", times=10),rep("2h", times=10),rep("5h", times=10),rep("10h", times=10))
# heuristic <- c(rep(rep(c("h0","h111"),times=5),times=6))
# 
# df <- data.frame(xdata,
#                  ydata=mean_alljobs_all_eachMTBF,
#                  heuristic)
# 
# x1 = factor(df$xdata, levels=c("20min", "40min", "1h", "2h", "5h", "10h"))
# 
# p<-ggplot(data=df, aes(x=x1,y=ydata,fill=heuristic)) + geom_boxplot(outlier.size = 0.5)+
#   stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4)
# 
# p
# 
# p+ xlab("MTBF") + ylab("mean_flow") + theme(axis.title.x = element_text(size = 14, angle = 0),axis.title.y = element_text(size = 14, angle = 90)) +
#   theme(plot.title=element_text(hjust=0.5)) + theme(legend.position = "top")

# #Mean flow 32768
# xdata <- c(rep("20min", times=10),rep("40min", times=10),rep("1h", times=10),rep("2h", times=10),rep("5h", times=10),rep("10h", times=10))
# heuristic <- c(rep(rep(c("h0","h111"),times=5),times=6))
# 
# df <- data.frame(xdata,
#                  ydata=mean_32768_all_eachMTBF,
#                  heuristic)
# 
# x1 = factor(df$xdata, levels=c("20min", "40min", "1h", "2h", "5h", "10h"))
# 
# p<-ggplot(data=df, aes(x=x1,y=ydata,fill=heuristic)) + geom_boxplot(outlier.size = 0.5)+
#   stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4)
# 
# p
# 
# p+ xlab("MTBF") + ylab("mean_flow") + theme(axis.title.x = element_text(size = 14, angle = 0),axis.title.y = element_text(size = 14, angle = 90)) +
#   theme(plot.title=element_text(hjust=0.5)) + theme(legend.position = "top")













