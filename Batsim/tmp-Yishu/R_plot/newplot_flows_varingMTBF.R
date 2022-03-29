library(tikzDevice)
# xdata <- c(rep("20min", times=10),rep("40min", times=10),rep("1h", times=10),rep("2h", times=10),rep("5h", times=10),rep("10h", times=10))
# heuristic <- c(rep(rep(c("h0","h111"),times=5),times=6))
# type <- rep(c("max"),times=60)
# D <- rep(c("10min"),times=60)
# df_max_10min <- data.frame(xdata,
#                            ydata=max_32768_all_eachMTBF,
#                            heuristic,
#                            type,
#                            D)
# 
# type <- rep(c("mean"),times=60)
# D <- rep(c("10min"),times=60)
# df_mean_10min <- data.frame(xdata,
#                             ydata=max_32768_all_eachMTBF,
#                             heuristic,
#                             type,
#                             D)
# 
# df <- rbind(df_max_10min, df_mean_10min)
# 
# 
# xdata <- c(rep("20min", times=10),rep("40min", times=10),rep("1h", times=10),rep("2h", times=10),rep("5h", times=10),rep("10h", times=10))
# heuristic <- c(rep(rep(c("h0","h111"),times=5),times=6))
# type <- rep(c("max"),times=60)
# D <- rep(c("1h"),times=60)
# df_max_1h <- data.frame(xdata,
#                        ydata=max_32768_all_eachMTBF,
#                        heuristic,
#                        type,
#                        D)
# 
# type <- rep(c("mean"),times=60)
# D <- rep(c("1h"),times=60)
# df_mean_1h <- data.frame(xdata,
#                         ydata=max_32768_all_eachMTBF,
#                         heuristic,
#                         type,
#                         D)
# 
# df <- rbind(df, df_max_1h, df_mean_1h)
# 
# 
# xdata <- c(rep("20min", times=10),rep("40min", times=10),rep("1h", times=10),rep("2h", times=10),rep("5h", times=10),rep("10h", times=10))
# heuristic <- c(rep(rep(c("h0","h111"),times=5),times=6))
# type <- rep(c("max"),times=60)
# D <- rep(c("1day"),times=60)
# df_max_1day <- data.frame(xdata,
#                            ydata=max_32768_all_eachMTBF,
#                            heuristic,
#                            type,
#                            D)
# 
# type <- rep(c("mean"),times=60)
# D <- rep(c("1day"),times=60)
# df_mean_1day <- data.frame(xdata,
#                             ydata=max_32768_all_eachMTBF,
#                             heuristic,
#                             type,
#                             D)
# 
# 
# df <- rbind(df, df_max_1day, df_mean_1day)
# 
# 
# df$ydata = df$ydata/(24*60*60)

df$type[which(df$type =='max')] <- 'Maxflow(days)'
df$type[which(df$type =='mean')] <- 'Meanflow(days)'
df$heuristic[which(df$heuristic =='h0')] <- 'Baseline'
df$heuristic[which(df$heuristic =='h111')] <- 'Node-stealing'


x1 = factor(df$xdata, levels=c("20min", "40min", "1h", "2h", "5h", "10h"))

#change facet order to the right order: 10min 1h 1day
df <- within(df, D <- factor(df$D, levels = c("10min","1h","1day")))
with(df, levels(D))

tikz("/home/yishu/node-stealing-for-resilience/paper/newfiguresfinal/test.tex",width=5,height=5)

p<-ggplot(data=df, aes(x=x1,y=ydata,fill=heuristic)) + geom_boxplot(outlier.size = 0.5)+
  stat_summary(fun="mean", geom="point", size=2, position=position_dodge(width=0.75), color="black",pch=4)

# p

p+ xlab("MTBF") + ylab("Flow(days)") + theme(axis.title.x = element_text(size = 16, angle = 0),axis.title.y = element_text(size = 16, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) + theme(legend.title = element_text(size = 18), legend.text = element_text(size = 15), legend.position = "top") + facet_grid(D~type) + ylab(NULL) + 
  theme(axis.text.x = element_text(size = 10, angle = 270, hjust = 0.5, vjust = 0.5)) +
  theme(axis.text.y = element_text(size = 10))

dev.off()

