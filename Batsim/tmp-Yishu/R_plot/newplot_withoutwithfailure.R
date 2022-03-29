#12*12
#maxflow together
library(ggplot2)
library("xtable")
library(tikzDevice)
# xdata_max<-factor(c("[1,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)","all"),levels=c("[1,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)","all"))
# xdata_mean<-factor(c("[1,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)", "all", "weighted"),levels=c("[1,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)", "all", "weighted"))


xdata_max<-factor(c("a", "b", "c", "d", "e","f","all"),levels=c("a", "b", "c", "d", "e","f","all"))
xdata_mean<-factor(c("a", "b", "c", "d", "e", "f", "all", "weighted"),levels=c("a", "b", "c", "d", "e","f", "all", "weighted"))

df_withfailure_max <- data.frame(strategy = strategy_max_withfailure,
                             xdata = xdata_max,
                             ydata=max_all_withfailure/(24*3600),
                             type1=rep("Maxflow(days)",times=5*7))
df_withfailure_mean <- data.frame(strategy = strategy_mean_withfailure,
                             xdata = xdata_mean,
                             ydata=mean_all_withfailure/(24*3600),
                             type1=rep("Meanflow(days)",times=5*8))
df_withfailure = rbind(df_withfailure_max,df_withfailure_mean)

df_withfailure_max_mean = aggregate(df_withfailure_max$ydata, by=list(type=df_withfailure_max$xdata),mean)
df_withfailure_max_mean$type1 = rep("Maxflow(days)",7)
df_withfailure_mean_mean = aggregate(df_withfailure_mean$ydata, by=list(type=df_withfailure_mean$xdata),mean)
df_withfailure_mean_mean$type1 = rep("Meanflow(days)",8)
df_withfailure_mean = rbind(df_withfailure_max_mean, df_withfailure_mean_mean)

df_withoutfailure_max <- data.frame(strategy = strategy_max_withoutfailure,
                                xdata = xdata_max,
                                ydata=max_heuristic_withoutfailure/(24*3600),
                                type1 = rep("Maxflow(days)",times=7))
df_withoutfailure_mean <- data.frame(strategy = strategy_mean_withoutfailure,
                                xdata = xdata_mean,
                                ydata=mean_heuristic_withoutfailure/(24*3600),
                                type1 = rep("Meanflow(days)",times=8))
df_withoutfailure = rbind(df_withoutfailure_max, df_withoutfailure_mean)
# df_withfailure_mean = df_withfailure_mean[-2, ]
# df_withoutfailure = df_withoutfailure[-2,]

tikz("/home/yishu/node-stealing-for-resilience/paper/newfiguresfinal/test.tex",width=5,height=5)

p<-ggplot() + geom_boxplot(data=df_withfailure, aes(x=xdata,y=ydata), outlier.size = 0.5)+
  geom_point(data=df_withfailure_mean, aes(x=type,y=x), color = "black", shape = 4, size = 1)+
  geom_point(data=df_withoutfailure, aes(x=xdata,y=ydata), color = "red", shape = 1, size = 3)
# + stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4) 

# p

p+ xlab("Job Size") + theme(axis.title.x = element_text(size = 20, angle = 0),axis.title.y = element_text(size = 20, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) + theme(legend.position = "top") + scale_fill_discrete(name = "heuristic") + facet_grid(~type1) + ylab(NULL) + 
  theme(axis.text.x = element_text(angle = 270, hjust = 0.5, vjust = 0.5))


dev.off()

#+ylim(0.2,1.7) 
# ylab("Flow(days)")