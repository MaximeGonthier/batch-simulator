#maxflow together
library(ggplot2)
library("xtable")
xdata<-factor(c("1", "[2^1,2^3)", "[2^3,2^5)", "[2^5,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)","all"),levels=c("1", "[2^1,2^3)", "[2^3,2^5)", "[2^5,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)","all"))

df_withfailure <- data.frame(strategy_max = strategy_max_withfailure,
                             xdata,
                             ydata=max_all_withfailure)

df_withfailure_mean = aggregate(df_withfailure$ydata, by=list(type=df_withfailure$xdata),mean)

df_withoutfailure <- data.frame(strategy_max = strategy_max_withoutfailure,
                                xdata,
                                ydata=max_heuristic_withoutfailure)

# df_withfailure_mean = df_withfailure_mean[-2, ]
# df_withoutfailure = df_withoutfailure[-2,]

p<-ggplot() + geom_boxplot(data=df_withfailure, aes(x=xdata,y=ydata), outlier.size = 0.5)+
  geom_point(data=df_withfailure_mean, aes(x=type,y=x), color = "black", shape = 4, size = 3)+
  geom_point(data=df_withoutfailure, aes(x=xdata,y=ydata), color = "red", shape = 1, size = 3)
# +
#   stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4) 

p

p+ xlab("res") + ylab("max_flow") + theme(axis.title.x = element_text(size = 14, angle = 0),axis.title.y = element_text(size = 14, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) + theme(legend.position = "top") + scale_fill_discrete(name = "heuristic") #+ylim(0.2,1.7)



#Meanflow together
xdata<-factor(c("1", "[2^1,2^3)", "[2^3,2^5)", "[2^5,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)", "all", "weighted"),levels=c("1", "[2^1,2^3)", "[2^3,2^5)", "[2^5,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)", "all", "weighted"))

df_withfailure <- data.frame(strategy_mean = strategy_mean_withfailure,
                             xdata,
                             ydata=mean_all_withfailure)

df_withfailure_mean = aggregate(df_withfailure$ydata, by=list(type=df_withfailure$xdata),mean)

df_withoutfailure <- data.frame(strategy_mean = strategy_mean_withoutfailure,
                                xdata,
                                ydata=mean_heuristic_withoutfailure)

# df_withfailure_mean = df_withfailure_mean[-2, ]
# df_withoutfailure = df_withoutfailure[-2,]

df <- rbind(df_withoutfailure, df_withfailure)

strategy_mean = factor(df$strategy_mean, levels=c("withoutfailure", "withfailure"))

p<-ggplot() + geom_boxplot(data=df_withfailure, aes(x=xdata,y=ydata), outlier.size = 0.5)+
  geom_point(data=df_withfailure_mean, aes(x=type,y=x), color = "black", shape = 4, size = 3)+
  geom_point(data=df_withoutfailure, aes(x=xdata,y=ydata), color = "red", shape = 1, size = 3)

p

p+ xlab("res") + ylab("mean_flow") + theme(axis.title.x = element_text(size = 14, angle = 0),axis.title.y = element_text(size = 14, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) + theme(legend.position = "top") + scale_fill_discrete(name = "heuristic") #+ylim(0.2,1.7)

