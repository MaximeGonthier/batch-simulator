xdata <- c(rep("20min", times=5),rep("40min", times=5),rep("1h", times=5),rep("2h", times=5),rep("5h", times=5),rep("10h", times=5))

df <- data.frame(xdata,
                 ydata=utilization_gain_eachMTBF)

x1 = factor(df$xdata, levels=c("20min", "40min", "1h", "2h", "5h", "10h"))

p<-ggplot(data=df, aes(x=x1,y=ydata)) + geom_boxplot(outlier.size = 0.5)+
  stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4)

p

p+ xlab("MTBF") + ylab("normalized utilisation of h111") + theme(axis.title.x = element_text(size = 14, angle = 0),axis.title.y = element_text(size = 14, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) + theme(legend.position = "top") + ylim(0.96,1.08)

