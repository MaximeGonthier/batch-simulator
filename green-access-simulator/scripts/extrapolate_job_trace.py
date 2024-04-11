import pandas as pd
import numpy as np

from fancyimpute import KNN
from sklearn.mixture import GaussianMixture
from sklearn.impute import IterativeImputer
from sklearn.linear_model import LinearRegression
import gmr

task_stats = pd.read_csv("inputs/machine-function-history.csv", index_col=0)
task_stats["machine"] = task_stats["machine"].str.title()
task_stats["llc_misses_per_sec"] = task_stats["llc_misses"]/task_stats["duration_s"]
task_stats["instructions_per_sec"] = task_stats["instructions_retired"]/task_stats["duration_s"]
task_stats["avg_rel_freq"] = task_stats["core_cycles"]/task_stats["ref_cycles"]
task_stats["llc_misses_per_sec"] = task_stats["llc_misses_per_sec"] / 1e6
task_stats["llc_misses"] = task_stats["llc_misses"] / 1e6
task_stats["instructions_per_sec"] = task_stats["instructions_per_sec"] / 1e8
task_stats["instructions_retired"] = task_stats["instructions_retired"] / 1e8
task_stats = task_stats.dropna(subset=["llc_misses", "energy", "running_duration"])
midway_data = task_stats[task_stats["machine"] == "Midway"]
clf = GaussianMixture(n_components=4)
clf.fit(midway_data[["avg_power_W", "llc_misses_per_sec"]].to_numpy())
midway_model = gmr.GMM(
    n_components=4, priors=clf.weights_, means=clf.means_,
    covariances=clf.covariances_)

jobs = pd.read_csv("inputs/workloads/meggie-raw", on_bad_lines='warn')
jobs = jobs.rename(columns={
    "Power used per node": "ppn", " Job Id": "jid", " Number of nodes used": "nodes", " Number of cores used": "cores", " Requested Walltime": "req_walltime", " Runtime": "duration_s", " Username": "user"
})
jobs["ppn"] = pd.to_numeric(jobs["ppn"], errors="coerce")
jobs["nodes"] = pd.to_numeric(jobs["nodes"], errors="coerce")
jobs["cores"] = pd.to_numeric(jobs["cores"], errors="coerce")
jobs["duration_s"] = pd.to_numeric(jobs["duration_s"], errors="coerce")
jobs = jobs.dropna()
idle_power = jobs["ppn"].min()
jobs["avg_power_W"] = ((jobs["ppn"] - idle_power) * jobs["nodes"]) /(jobs["cores"])
jobs["func_name"] = jobs.groupby(["nodes", "req_walltime", "user"]).ngroup().astype(str)
jobs["machine"] = "Midway"
jobs["llc_misses_per_sec"] = jobs["avg_power_W"].apply(lambda v : max(midway_data["llc_misses_per_sec"].min(), midway_model.condition([0,], [v]).sample(1)[0,0]))
jobs["llc_misses"] = jobs["llc_misses_per_sec"] * jobs["duration_s"]
jobs["avg_rel_freq"] = midway_data["avg_rel_freq"].iloc[0]

new_jobs = pd.concat([task_stats, jobs])[["machine", "func_name", "duration_s", "avg_power_W", "avg_rel_freq", "llc_misses", "llc_misses_per_sec"]]
cross_platform_df = pd.pivot_table(new_jobs, values=["avg_power_W", "duration_s", "avg_rel_freq", "llc_misses", "llc_misses_per_sec"], index=["func_name"],
                       columns=["machine"], aggfunc="mean")

cross_platform_array_full = cross_platform_df[["duration_s", "llc_misses"]].to_numpy()
X_filled_1 = IterativeImputer(LinearRegression(positive=True), max_iter=25, min_value=0.01).fit_transform(cross_platform_array_full)

cross_platform_array_full = cross_platform_df[["avg_power_W", "avg_rel_freq", "duration_s", "llc_misses_per_sec"]].to_numpy()
X_filled_2 = KNN(k=2).fit_transform(cross_platform_array_full)

cross_platform_df[("duration_s", "Desktop")] = X_filled_1[:, 0]
cross_platform_df[("duration_s", "Faster")] = X_filled_1[:, 1]
cross_platform_df[("duration_s", "Theta")] = X_filled_1[:, 3]

cross_platform_df[("avg_power_W", "Desktop")] = X_filled_2[:, 0]
cross_platform_df[("avg_power_W", "Faster")] = X_filled_2[:, 1]
cross_platform_df[("avg_power_W", "Theta")] = X_filled_2[:, 3]

jobs["req_walltime"] = jobs["req_walltime"].astype(np.float64)
cross_platform_df.columns = cross_platform_df.columns.to_flat_index()
new_job_trace = pd.merge(cross_platform_df, pd.pivot_table(jobs, values=["cores","req_walltime"], index=["func_name"], aggfunc="mean"), how="left", left_index=True, right_index=True)
new_job_trace = pd.merge(new_job_trace, jobs["func_name"].value_counts(ascending=True), how="left", left_index=True, right_index=True)
new_job_trace = new_job_trace.rename(columns={"func_name": "count"})
new_job_trace["cores"] = new_job_trace["cores"] * 16/20
new_job_trace[("nodes", "Desktop")] = np.ceil(new_job_trace["cores"] / 16)
new_job_trace[("nodes", "Faster")] = np.ceil(new_job_trace["cores"] / 64)
new_job_trace[("nodes", "Midway")] = np.ceil(new_job_trace["cores"] / 48)
new_job_trace[("nodes", "Theta")] = np.ceil(new_job_trace["cores"] / 64)

new_job_trace[("total_power", "Desktop")] = (new_job_trace[("nodes", "Desktop")] * 6.51) + (new_job_trace["cores"] * new_job_trace[("avg_power_W", "Desktop")])
new_job_trace[("total_power", "Faster")] = (new_job_trace[("nodes", "Faster")] * 205) + (new_job_trace["cores"] * new_job_trace[("avg_power_W", "Faster")])
new_job_trace[("total_power", "Midway")] = (new_job_trace[("nodes", "Midway")] * 136) + (new_job_trace["cores"] * new_job_trace[("avg_power_W", "Midway")])
new_job_trace[("total_power", "Theta")] = (new_job_trace[("nodes", "Theta")] * 110) + (new_job_trace["cores"] * new_job_trace[("avg_power_W", "Theta")])
new_job_trace[("total_power", "Desktop")] = np.minimum(new_job_trace[("total_power", "Desktop")], new_job_trace[("nodes", "Desktop")] * 65)
new_job_trace[("total_power", "Faster")] = np.minimum(new_job_trace[("total_power", "Faster")], new_job_trace[("nodes", "Faster")] * 410)
new_job_trace[("total_power", "Midway")] = np.minimum(new_job_trace[("total_power", "Midway")], new_job_trace[("nodes", "Midway")] * 410)
new_job_trace[("total_power", "Theta")] = np.minimum(new_job_trace[("total_power", "Theta")], new_job_trace[("nodes", "Theta")] * 215)

new_job_trace[("total_energy", "Desktop")] = new_job_trace[("total_power", "Desktop")]  * new_job_trace[("duration_s", "Desktop")]
new_job_trace[("total_energy", "Faster")] = new_job_trace[("total_power", "Faster")]  * new_job_trace[("duration_s", "Faster")]
new_job_trace[("total_energy", "Midway")] = new_job_trace[("total_power", "Midway")]  * new_job_trace[("duration_s", "Midway")]
new_job_trace[("total_energy", "Theta")] = new_job_trace[("total_power", "Theta")]  * new_job_trace[("duration_s", "Theta")]

new_job_trace = new_job_trace.drop(columns=[
    ("avg_rel_freq", "Desktop"),
    ("avg_rel_freq", "Faster"),
    ("avg_rel_freq", "Midway"),
    ("avg_rel_freq", "Theta"),
    ("llc_misses_per_sec", "Desktop"),
    ("llc_misses_per_sec", "Faster"),
    ("llc_misses_per_sec", "Midway"),
    ("llc_misses_per_sec", "Theta"),
    ("total_power", "Desktop"),
    ("total_power", "Faster"),
    ("total_power", "Midway"),
    ("total_power", "Theta"),
    ("llc_misses", "Desktop"),
    ("llc_misses", "Faster"),
    ("llc_misses", "Midway"),
    ("llc_misses", "Theta")
]).dropna()
new_index = pd.MultiIndex.from_tuples(new_job_trace.drop(columns=["cores", "req_walltime", "count"]).columns, names=["metric", "machine"])
df = new_job_trace.drop(columns=["cores", "req_walltime", "count"])
df.columns = new_index
df["cores"] = new_job_trace["cores"]
df["req_walltime"] = new_job_trace["req_walltime"]
df["count"] = new_job_trace["count"]
meggie_job_trace = df

jobs = pd.read_csv("inputs/workloads/emmy-raw", on_bad_lines='warn')
jobs = jobs.rename(columns={
    "Power used per node": "ppn", " Job Id": "jid", " Number of nodes used": "nodes", " Number of cores used": "cores", " Requested Walltime": "req_walltime", " Runtime": "duration_s", " Username": "user"
})
jobs["ppn"] = pd.to_numeric(jobs["ppn"], errors="coerce")
jobs["nodes"] = pd.to_numeric(jobs["nodes"], errors="coerce")
jobs["cores"] = pd.to_numeric(jobs["cores"], errors="coerce")
jobs["duration_s"] = pd.to_numeric(jobs["duration_s"], errors="coerce")
jobs = jobs.dropna()
idle_power = jobs["ppn"].min()
jobs["avg_power_W"] = ((jobs["ppn"] - idle_power) * jobs["nodes"]) /(jobs["cores"])
jobs["func_name"] = jobs.groupby(["nodes", "req_walltime", "user"]).ngroup().astype(str)
jobs["machine"] = "Midway"
jobs = jobs.drop(jobs[jobs['duration_s'] == 0].index)
jobs["llc_misses_per_sec"] = jobs["avg_power_W"].apply(lambda v : max(midway_data["llc_misses_per_sec"].min(), midway_model.condition([0,], [v]).sample(1)[0,0]))
jobs["llc_misses"] = jobs["llc_misses_per_sec"] * jobs["duration_s"]
jobs["avg_rel_freq"] = midway_data["avg_rel_freq"].iloc[0]
new_jobs = pd.concat([task_stats, jobs])[["machine", "func_name", "duration_s", "avg_power_W", "avg_rel_freq", "llc_misses", "llc_misses_per_sec"]]
cross_platform_df = pd.pivot_table(new_jobs, values=["avg_power_W", "duration_s", "avg_rel_freq", "llc_misses", "llc_misses_per_sec"], index=["func_name"],
                       columns=["machine"], aggfunc="mean")
cross_platform_array_full = cross_platform_df[["duration_s", "llc_misses"]].to_numpy()
X_filled_1 = IterativeImputer(LinearRegression(positive=True), max_iter=25, min_value=0.01).fit_transform(cross_platform_array_full)

cross_platform_array_full = cross_platform_df[["avg_power_W", "avg_rel_freq", "duration_s", "llc_misses_per_sec"]].to_numpy()
X_filled_2 = KNN(k=2).fit_transform(cross_platform_array_full)

cross_platform_df[("duration_s", "Desktop")] = X_filled_1[:, 0]
cross_platform_df[("duration_s", "Faster")] = X_filled_1[:, 1]
cross_platform_df[("duration_s", "Theta")] = X_filled_1[:, 3]

cross_platform_df[("avg_power_W", "Desktop")] = X_filled_2[:, 0]
cross_platform_df[("avg_power_W", "Faster")] = X_filled_2[:, 1]
cross_platform_df[("avg_power_W", "Theta")] = X_filled_2[:, 3]

jobs["req_walltime"] = jobs["req_walltime"].astype(np.float64)
cross_platform_df.columns = cross_platform_df.columns.to_flat_index()
new_job_trace = pd.merge(cross_platform_df, pd.pivot_table(jobs, values=["cores","req_walltime"], index=["func_name"], aggfunc="mean"), how="left", left_index=True, right_index=True)
new_job_trace = pd.merge(new_job_trace, jobs["func_name"].value_counts(ascending=True), how="left", left_index=True, right_index=True)
new_job_trace = new_job_trace.rename(columns={"func_name": "count"})
new_job_trace["cores"] = new_job_trace["cores"] * 16/20
new_job_trace[("nodes", "Desktop")] = np.ceil(new_job_trace["cores"] / 16)
new_job_trace[("nodes", "Faster")] = np.ceil(new_job_trace["cores"] / 64)
new_job_trace[("nodes", "Midway")] = np.ceil(new_job_trace["cores"] / 48)
new_job_trace[("nodes", "Theta")] = np.ceil(new_job_trace["cores"] / 64)

new_job_trace[("total_power", "Desktop")] = (new_job_trace[("nodes", "Desktop")] * 6.51) + (new_job_trace["cores"] * new_job_trace[("avg_power_W", "Desktop")])
new_job_trace[("total_power", "Faster")] = (new_job_trace[("nodes", "Faster")] * 205) + (new_job_trace["cores"] * new_job_trace[("avg_power_W", "Faster")])
new_job_trace[("total_power", "Midway")] = (new_job_trace[("nodes", "Midway")] * 136) + (new_job_trace["cores"] * new_job_trace[("avg_power_W", "Midway")])
new_job_trace[("total_power", "Theta")] = (new_job_trace[("nodes", "Theta")] * 110) + (new_job_trace["cores"] * new_job_trace[("avg_power_W", "Theta")])
new_job_trace[("total_power", "Desktop")] = np.minimum(new_job_trace[("total_power", "Desktop")], new_job_trace[("nodes", "Desktop")] * 65)
new_job_trace[("total_power", "Faster")] = np.minimum(new_job_trace[("total_power", "Faster")], new_job_trace[("nodes", "Faster")] * 410)
new_job_trace[("total_power", "Midway")] = np.minimum(new_job_trace[("total_power", "Midway")], new_job_trace[("nodes", "Midway")] * 410)
new_job_trace[("total_power", "Theta")] = np.minimum(new_job_trace[("total_power", "Theta")], new_job_trace[("nodes", "Theta")] * 215)

new_job_trace[("total_energy", "Desktop")] = new_job_trace[("total_power", "Desktop")]  * new_job_trace[("duration_s", "Desktop")]
new_job_trace[("total_energy", "Faster")] = new_job_trace[("total_power", "Faster")]  * new_job_trace[("duration_s", "Faster")]
new_job_trace[("total_energy", "Midway")] = new_job_trace[("total_power", "Midway")]  * new_job_trace[("duration_s", "Midway")]
new_job_trace[("total_energy", "Theta")] = new_job_trace[("total_power", "Theta")]  * new_job_trace[("duration_s", "Theta")]

new_job_trace = new_job_trace.drop(columns=[
    ("avg_rel_freq", "Desktop"),
    ("avg_rel_freq", "Faster"),
    ("avg_rel_freq", "Midway"),
    ("avg_rel_freq", "Theta"),
    ("llc_misses_per_sec", "Desktop"),
    ("llc_misses_per_sec", "Faster"),
    ("llc_misses_per_sec", "Midway"),
    ("llc_misses_per_sec", "Theta"),
    ("total_power", "Desktop"),
    ("total_power", "Faster"),
    ("total_power", "Midway"),
    ("total_power", "Theta"),
    ("llc_misses", "Desktop"),
    ("llc_misses", "Faster"),
    ("llc_misses", "Midway"),
    ("llc_misses", "Theta")
]).dropna()

new_index = pd.MultiIndex.from_tuples(new_job_trace.drop(columns=["cores", "req_walltime", "count"]).columns, names=["metric", "machine"])
df = new_job_trace.drop(columns=["cores", "req_walltime", "count"])
df.columns = new_index
df["cores"] = new_job_trace["cores"]
df["req_walltime"] = new_job_trace["req_walltime"]
df["count"] = new_job_trace["count"]
emmy_job_trace = df

extrapolated_trace = task_stats = pd.concat([meggie_job_trace, emmy_job_trace])
extrapolated_trace.to_csv("inputs/workloads/meggie_and_emmy-job-trace-extrapolated.csv")