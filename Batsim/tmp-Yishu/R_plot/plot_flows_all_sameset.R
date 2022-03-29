#Max_flow 
#10*10
library("xtable")
xdata<-factor(c("1", "[2^1,2^3)", "[2^3,2^5)", "[2^5,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","2^15", "all"),levels=c("1", "[2^1,2^3)", "[2^3,2^5)", "[2^5,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","2^15", "all"))
df <- data.frame(strategy_max,
                 xdata,
                 ydata=max_all)

p<-ggplot(data=df, aes(x=xdata,y=ydata,fill=strategy_max)) + geom_boxplot(outlier.size = 0.5)+
  stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4)

p

p+ xlab("res") + ylab("max_flow") + theme(axis.title.x = element_text(size = 14, angle = 0),axis.title.y = element_text(size = 14, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) + theme(legend.position = "top") + scale_fill_discrete(name = "heuristic") #+ylim(0.2,1.7)



#Mean_flow 
#10*10
library("xtable")
xdata<-factor(c("1", "[2^1,2^3)", "[2^3,2^5)", "[2^5,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","2^15", "all", "weighted"),levels=c("1", "[2^1,2^3)", "[2^3,2^5)", "[2^5,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","2^15", "all", "weighted"))
df <- data.frame(strategy_mean,
                 xdata,
                 ydata=mean_all)

p<-ggplot(data=df, aes(x=xdata,y=ydata,fill=strategy_mean)) + geom_boxplot(outlier.size = 0.5)+
  stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4)

p

p+ xlab("res") + ylab("mean_flow") + theme(axis.title.x = element_text(size = 14, angle = 0),axis.title.y = element_text(size = 14, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) + theme(legend.position = "top") + scale_fill_discrete(name = "heuristic") #+ylim(0.2,1.7)

