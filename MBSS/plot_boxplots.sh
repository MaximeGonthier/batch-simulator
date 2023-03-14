# bash plot_boxplots.sh ${date1} ${date2}

date1=$1
date2=$2

python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF core_time 0 boxplot
python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF core_time 0 hist
python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF stretch 0 boxplot

python3 src/plot_boxplot.py ${date1} ${date2} byuser BF core_time 0 boxplot
python3 src/plot_boxplot.py ${date1} ${date2} byuser BF core_time 0 hist
python3 src/plot_boxplot.py ${date1} ${date2} byuser BF stretch 0 boxplot
