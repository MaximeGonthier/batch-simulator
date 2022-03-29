# xdata <- c(rep("20min", times=5),rep("40min", times=5),rep("1h", times=5),rep("2h", times=5),rep("5h", times=5),rep("10h", times=5))
# type <- rep(c("2017June"),times=30)
# D <- rep(c("10min"),times=30)
# df_2017June_10min <- data.frame(xdata,
#                            ydata=utilization_gain_eachMTBF,
#                            type,
#                            D)
# df <- df_2017June_10min
# 
# 
# 
# xdata <- c(rep("20min", times=5),rep("40min", times=5),rep("1h", times=5),rep("2h", times=5),rep("5h", times=5),rep("10h", times=5))
# type <- rep(c("2017June"),times=30)
# D <- rep(c("1h"),times=30)
# df_2017June_1h <- data.frame(xdata,
#                                 ydata=utilization_gain_eachMTBF,
#                                 type,
#                                 D)
# df <- rbind(df, df_2017June_1h)
# 
# 
# xdata <- c(rep("20min", times=5),rep("40min", times=5),rep("1h", times=5),rep("2h", times=5),rep("5h", times=5),rep("10h", times=5))
# type <- rep(c("2017June"),times=30)
# D <- rep(c("1day"),times=30)
# df_2017June_1day <- data.frame(xdata,
#                              ydata=utilization_gain_eachMTBF,
#                              type,
#                              D)
# df <- rbind(df, df_2017June_1day)
# 
# 
# 
# xdata <- c(rep("20min", times=5),rep("40min", times=5),rep("1h", times=5),rep("2h", times=5),rep("5h", times=5),rep("10h", times=5))
# type <- rep(c("2018March"),times=30)
# D <- rep(c("10min"),times=30)
# df_2018March_10min <- data.frame(xdata,
#                                 ydata=utilization_gain_eachMTBF,
#                                 type,
#                                 D)
# df <- rbind(df, df_2018March_10min)
# 
# 
# xdata <- c(rep("20min", times=5),rep("40min", times=5),rep("1h", times=5),rep("2h", times=5),rep("5h", times=5),rep("10h", times=5))
# type <- rep(c("2018March"),times=30)
# D <- rep(c("1h"),times=30)
# df_2018March_1h <- data.frame(xdata,
#                                  ydata=utilization_gain_eachMTBF,
#                                  type,
#                                  D)
# df <- rbind(df, df_2018March_1h)
# 
# 
# 
# xdata <- c(rep("20min", times=5),rep("40min", times=5),rep("1h", times=5),rep("2h", times=5),rep("5h", times=5),rep("10h", times=5))
# type <- rep(c("2018March"),times=30)
# D <- rep(c("1day"),times=30)
# df_2018March_1day <- data.frame(xdata,
#                               ydata=utilization_gain_eachMTBF,
#                               type,
#                               D)
# df <- rbind(df, df_2018March_1day)

x1 = factor(df$xdata, levels=c("20min", "40min", "1h", "2h", "5h", "10h"))

#change facet order to the right order: 10min 1h 1day
df <- within(df, D <- factor(df$D, levels = c("10min","1h","1day")))
with(df, levels(D))

tikz("/home/yishu/node-stealing-for-resilience/paper/newfiguresfinal/test.tex",width=5,height=5)

p<-ggplot(data=df, aes(x=x1,y=ydata)) + geom_boxplot(outlier.size = 0.5)+
  stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4)

# p

p+ xlab("MTBF") + ylab("Normalized Utilisation") + theme(axis.title.x = element_text(size = 16, angle = 0),axis.title.y = element_text(size = 16, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) + theme(legend.position = "top")  + facet_grid(D~type) + 
  theme(axis.text.x = element_text(size = 10, angle = 270, hjust = 0.5, vjust = 0.5)) +
  theme(axis.text.y = element_text(size = 10))

dev.off()
