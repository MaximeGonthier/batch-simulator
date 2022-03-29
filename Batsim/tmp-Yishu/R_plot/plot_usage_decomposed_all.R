rm(list=ls())
heuristic=rep(c("h0", "h111"),7)
heuristic <- factor(heuristic, levels = c("h0","h111"))

#2017 June
time_computig_idle_downtime_decompose_mean_h0_2017June =c(7.931678e-01, 5.967533e-02, 8.075759e-02, 0.000000e+00, 1.392941e-02, 5.244921e-02, 2.068207e-05)
time_computig_idle_downtime_decompose_mean_h111_2017June = c(8.067943e-01, 6.121385e-02, 8.359893e-02, 1.195285e-03, 1.441717e-02, 3.275978e-02, 2.068207e-05)

#2018 March
time_computig_idle_downtime_decompose_mean_h0_2018March = c(7.738221e-01, 6.018682e-02, 8.999558e-02, 0.000000e+00, 1.849006e-02, 5.748478e-02, 2.068207e-05)
time_computig_idle_downtime_decompose_mean_h111_2018March = c(7.849982e-01, 6.093047e-02, 8.837619e-02, 8.311925e-04, 1.772181e-02, 4.712148e-02, 2.068207e-05)


Useful_compute_h0_2017June=time_computig_idle_downtime_decompose_mean_h0_2017June[1]
Useful_compute_h111_2017June=time_computig_idle_downtime_decompose_mean_h111_2017June[1]
checkpoint_time_h0_2017June=time_computig_idle_downtime_decompose_mean_h0_2017June[2]
checkpoint_time_h111_2017June=time_computig_idle_downtime_decompose_mean_h111_2017June[2]
compute_wasted_due_to_failure_h0_2017June=time_computig_idle_downtime_decompose_mean_h0_2017June[3]
compute_wasted_due_to_failure_h111_2017June=time_computig_idle_downtime_decompose_mean_h111_2017June[3]
compute_wasted_due_to_node_stealing_h0_2017June=time_computig_idle_downtime_decompose_mean_h0_2017June[4]
compute_wasted_due_to_node_stealing_h111_2017June=time_computig_idle_downtime_decompose_mean_h111_2017June[4]
recovery_cost_h0_2017June=time_computig_idle_downtime_decompose_mean_h0_2017June[5]
recovery_cost_h111_2017June=time_computig_idle_downtime_decompose_mean_h111_2017June[5]
time_idle_h0_2017June=time_computig_idle_downtime_decompose_mean_h0_2017June[6]
time_idle_h111_2017June=time_computig_idle_downtime_decompose_mean_h111_2017June[6]
Downtime_h0_2017June=time_computig_idle_downtime_decompose_mean_h0_2017June[7]
Downtime_h111_2017June=time_computig_idle_downtime_decompose_mean_h111_2017June[7]

Useful_compute_h0_2018March=time_computig_idle_downtime_decompose_mean_h0_2018March[1]
Useful_compute_h111_2018March=time_computig_idle_downtime_decompose_mean_h111_2018March[1]
checkpoint_time_h0_2018March=time_computig_idle_downtime_decompose_mean_h0_2018March[2]
checkpoint_time_h111_2018March=time_computig_idle_downtime_decompose_mean_h111_2018March[2]
compute_wasted_due_to_failure_h0_2018March=time_computig_idle_downtime_decompose_mean_h0_2018March[3]
compute_wasted_due_to_failure_h111_2018March=time_computig_idle_downtime_decompose_mean_h111_2018March[3]
compute_wasted_due_to_node_stealing_h0_2018March=time_computig_idle_downtime_decompose_mean_h0_2018March[4]
compute_wasted_due_to_node_stealing_h111_2018March=time_computig_idle_downtime_decompose_mean_h111_2018March[4]
recovery_cost_h0_2018March=time_computig_idle_downtime_decompose_mean_h0_2018March[5]
recovery_cost_h111_2018March=time_computig_idle_downtime_decompose_mean_h111_2018March[5]
time_idle_h0_2018March=time_computig_idle_downtime_decompose_mean_h0_2018March[6]
time_idle_h111_2018March=time_computig_idle_downtime_decompose_mean_h111_2018March[6]
Downtime_h0_2018March=time_computig_idle_downtime_decompose_mean_h0_2018March[7]
Downtime_h111_2018March=time_computig_idle_downtime_decompose_mean_h111_2018March[7]


# df2 <- data.frame(
#   group=c("Useful","Useful","checkpoint","checkpoint","wasted_failure","wasted_failure","wasted_nodestealing","wasted_nodestealing","Downtime","Downtime","timeidle","timeidle","recovery","recovery"),
#   makespan=c(Useful_compute_h0,Useful_compute_h111,checkpoint_time_h0,checkpoint_time_h111,compute_wasted_due_to_failure_h0,compute_wasted_due_to_failure_h111,compute_wasted_due_to_node_stealing_h0,compute_wasted_due_to_node_stealing_h111,recovery_cost_h0,recovery_cost_h111,time_idle_h0,time_idle_h111,Downtime_h0,Downtime_h111),
#   heuristic)
df2 <- data.frame(
  type=c(rep("2017June",14),rep("2018March",14)),
  group=rep(c("Useful","Useful","checkpoint","checkpoint","wasted_failure","wasted_failure","wasted_nodestealing","wasted_nodestealing","recovery","recovery","timeidle","timeidle","Downtime","Downtime"),2),
  makespan=c(Useful_compute_h0_2017June,Useful_compute_h111_2017June,checkpoint_time_h0_2017June,checkpoint_time_h111_2017June,compute_wasted_due_to_failure_h0_2017June,compute_wasted_due_to_failure_h111_2017June,compute_wasted_due_to_node_stealing_h0_2017June,compute_wasted_due_to_node_stealing_h111_2017June,recovery_cost_h0_2017June,recovery_cost_h111_2017June,time_idle_h0_2017June,time_idle_h111_2017June,Downtime_h0_2017June,Downtime_h0_2017June,Useful_compute_h0_2018March,Useful_compute_h111_2018March,checkpoint_time_h0_2018March,checkpoint_time_h111_2018March,compute_wasted_due_to_failure_h0_2018March,compute_wasted_due_to_failure_h111_2018March,compute_wasted_due_to_node_stealing_h0_2018March,compute_wasted_due_to_node_stealing_h111_2018March,recovery_cost_h0_2018March,recovery_cost_h111_2018March,time_idle_h0_2018March,time_idle_h111_2018March,Downtime_h0_2018March,Downtime_h111_2018March),
  heuristic)

head(df2)

df2$group = factor(df2$group, levels=c("checkpoint","wasted_failure","wasted_nodestealing","recovery","timeidle","Downtime","Useful"))

# Stacked barplot with multiple groups
ggplot() +  geom_bar(data = df2, aes(x=heuristic, y=makespan, fill=group), stat="identity") +
  facet_grid(.~type) + theme(legend.position = "top") +
  theme(axis.title.x = element_text(size = 14, angle = 0),axis.title.y = element_text(size = 14, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=16)) + ylab("time_computing+time_idle+downtime")+ 
  scale_fill_manual(values=c("checkpoint" = "green", "wasted_failure" = "red", "wasted_nodestealing" = "black" , "recovery" = "yellow", "timeidle" = "orange", "downtime" = "purple", "Useful" = "blue"))


