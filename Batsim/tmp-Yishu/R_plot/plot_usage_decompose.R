rm(list=ls())
heuristic=rep(c("h0", "h111"),6)
heuristic <- factor(heuristic, levels = c("h0","h111"))

#2017 June
time_computig_idle_decompose_mean_h0_2017June =c(0.79318419, 0.05967656, 0.08075926, 0.00000000, 0.01392969, 0.05245029)
time_computig_idle_decompose_mean_h111_2017June = c(0.806810982, 0.061215119, 0.083600668, 0.001195309, 0.014417465, 0.032760456)


#2018 March
time_computig_idle_decompose_mean_h0_2018March = c(0.77383807, 0.06018807, 0.08999745, 0.00000000, 0.01849044, 0.05748597)
time_computig_idle_decompose_mean_h111_2018March =c(0.7850144096, 0.0609317279, 0.0883780184, 0.0008312096, 0.0177221783, 0.0471224562)

Useful_compute_h0_2017June=time_computig_idle_decompose_mean_h0_2017June[1]
Useful_compute_h111_2017June=time_computig_idle_decompose_mean_h111_2017June[1]
checkpoint_time_h0_2017June=time_computig_idle_decompose_mean_h0_2017June[2]
checkpoint_time_h111_2017June=time_computig_idle_decompose_mean_h111_2017June[2]
compute_wasted_due_to_failure_h0_2017June=time_computig_idle_decompose_mean_h0_2017June[3]
compute_wasted_due_to_failure_h111_2017June=time_computig_idle_decompose_mean_h111_2017June[3]
compute_wasted_due_to_node_stealing_h0_2017June=time_computig_idle_decompose_mean_h0_2017June[4]
compute_wasted_due_to_node_stealing_h111_2017June=time_computig_idle_decompose_mean_h111_2017June[4]
recovery_cost_h0_2017June=time_computig_idle_decompose_mean_h0_2017June[5]
recovery_cost_h111_2017June=time_computig_idle_decompose_mean_h111_2017June[5]
time_idle_h0_2017June=time_computig_idle_decompose_mean_h0_2017June[6]
time_idle_h111_2017June=time_computig_idle_decompose_mean_h111_2017June[6]

Useful_compute_h0_2018March=time_computig_idle_decompose_mean_h0_2018March[1]
Useful_compute_h111_2018March=time_computig_idle_decompose_mean_h111_2018March[1]
checkpoint_time_h0_2018March=time_computig_idle_decompose_mean_h0_2018March[2]
checkpoint_time_h111_2018March=time_computig_idle_decompose_mean_h111_2018March[2]
compute_wasted_due_to_failure_h0_2018March=time_computig_idle_decompose_mean_h0_2018March[3]
compute_wasted_due_to_failure_h111_2018March=time_computig_idle_decompose_mean_h111_2018March[3]
compute_wasted_due_to_node_stealing_h0_2018March=time_computig_idle_decompose_mean_h0_2018March[4]
compute_wasted_due_to_node_stealing_h111_2018March=time_computig_idle_decompose_mean_h111_2018March[4]
recovery_cost_h0_2018March=time_computig_idle_decompose_mean_h0_2018March[5]
recovery_cost_h111_2018March=time_computig_idle_decompose_mean_h111_2018March[5]
time_idle_h0_2018March=time_computig_idle_decompose_mean_h0_2018March[6]
time_idle_h111_2018March=time_computig_idle_decompose_mean_h111_2018March[6]



df2 <- data.frame(
  type=c(rep("2017June",12),rep("2018March",12)),
  group=rep(c("Useful","Useful","checkpoint","checkpoint","wasted_failure","wasted_failure","wasted_nodestealing","wasted_nodestealing","recovery","recovery","timeidle","timeidle"),2),
  makespan=c(Useful_compute_h0_2017June,Useful_compute_h111_2017June,checkpoint_time_h0_2017June,checkpoint_time_h111_2017June,compute_wasted_due_to_failure_h0_2017June,compute_wasted_due_to_failure_h111_2017June,compute_wasted_due_to_node_stealing_h0_2017June,compute_wasted_due_to_node_stealing_h111_2017June,recovery_cost_h0_2017June,recovery_cost_h111_2017June,time_idle_h0_2017June,time_idle_h111_2017June,Useful_compute_h0_2018March,Useful_compute_h111_2018March,checkpoint_time_h0_2018March,checkpoint_time_h111_2018March,compute_wasted_due_to_failure_h0_2018March,compute_wasted_due_to_failure_h111_2018March,compute_wasted_due_to_node_stealing_h0_2018March,compute_wasted_due_to_node_stealing_h111_2018March,recovery_cost_h0_2018March,recovery_cost_h111_2018March,time_idle_h0_2018March,time_idle_h111_2018March),
  heuristic)

head(df2)

df2$group = factor(df2$group, levels=c("checkpoint","wasted_failure","wasted_nodestealing","recovery","timeidle","Useful"))

# Stacked barplot with multiple groups
ggplot() +  geom_bar(data = df2, aes(x=heuristic, y=makespan, fill=group), stat="identity")  +
  facet_grid(.~type) + theme(legend.position = "top") +
  theme(axis.title.x = element_text(size = 14, angle = 0),axis.title.y = element_text(size = 14, angle = 90)) +
  theme(plot.title=element_text(hjust=0.5)) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=16))+ ylab("time_computing+time_idle")+ 
  scale_fill_manual(values=c("checkpoint" = "green", "wasted_failure" = "red", "wasted_nodestealing" = "black" , "recovery" = "yellow", "timeidle" = "orange", "Useful" = "blue"))







