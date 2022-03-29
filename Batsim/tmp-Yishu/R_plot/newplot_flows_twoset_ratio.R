library(tikzDevice)
# xdata_max<-factor(c("[1,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)", "All"),levels=c("[1,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)", "All"))
xdata_max<-factor(c("a", "b", "c", "d", "e","f","all"),levels=c("a", "b", "c", "d", "e","f","all"))
df_max_2017June <- data.frame(xdata = xdata_max,
                              ydata = max_all_ratio,
                              type = rep(c("Maxflow(days)"),times=35),
                              data = rep(c("2017June"),times=35))
# xdata_mean<-factor(c("[1,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)", "All", "Weighted"),levels=c("[1,2^7)", "[2^7,2^9)", "[2^9,2^11)", "[2^11,2^13)", "[2^13,2^15)","[2^15,2^16)", "All", "Weighted"))
xdata_mean<-factor(c("a", "b", "c", "d", "e", "f", "all", "weighted"),levels=c("a", "b", "c", "d", "e","f", "all", "weighted"))
df_mean_2017June <- data.frame(xdata = xdata_mean,
                               ydata=mean_all_ratio,
                               type = rep(c("Meanflow(days)"),times=40),
                               data = rep(c("2017June"),times=40))
df = rbind(df_max_2017June, df_mean_2017June)



xdata_max<-factor(c("a", "b", "c", "d", "e","f","all"),levels=c("a", "b", "c", "d", "e","f","all"))
df_max_2018March <- data.frame(xdata = xdata_max,
                              ydata = max_all_ratio,
                              type = rep(c("Maxflow(days)"),times=35),
                              data = rep(c("2018March"),times=35))
xdata_mean<-factor(c("a", "b", "c", "d", "e", "f", "all", "weighted"),levels=c("a", "b", "c", "d", "e","f", "all", "weighted"))
df_mean_2018March <- data.frame(xdata = xdata_mean,
                               ydata=mean_all_ratio,
                               type = rep(c("Meanflow(days)"),times=40),
                               data = rep(c("2018March"),times=40))
df = rbind(df,df_max_2018March, df_mean_2018March)

tikz("/home/yishu/node-stealing-for-resilience/paper/newfiguresfinal/test.tex",width=5,height=5)

p<-ggplot(data=df, aes(x=xdata,y=ydata)) + geom_boxplot(outlier.size = 0.5)+
  stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4)

# p

p+ xlab("Job Size") + theme(axis.title.x = element_text(size = 20, angle = 0),axis.title.y = element_text(size = 20, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) + theme(legend.title = element_text(size = 18), legend.text = element_text(size = 15), legend.position = "top") + scale_fill_discrete(name = "heuristic") + facet_grid(data~type) + ylab(NULL) + 
  theme(axis.text.x = element_text(size = 10, angle = 270, hjust = 0.5, vjust = 0.5)) +
  theme(axis.text.y = element_text(size = 10)) +
  ylim(0,3)

dev.off()
