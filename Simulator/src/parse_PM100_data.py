# python3 src/parse_PM100_data.py ../../PM100.parquet
# Data from https://dl.acm.org/doi/pdf/10.1145/3624062.3624263 and https://zenodo.org/records/10127767
# Description of columns: https://github.com/francescoantici/PM100-data/blob/main/documentation/job_features.md

import pandas as pd
import sys
import csv
import numpy as np
import matplotlib.pyplot as plt

# 1) Load the Parquet file
df = pd.read_parquet(sys.argv[1])

pd.set_option('display.max_columns', None)
pd.set_option('display.max_colwidth', None)
pd.set_option('display.width', 0)

# Print the column names
print("Columns:")
print(df.columns.tolist())

df["submit_dt"] = pd.to_datetime(df["submit_time"])

# Set reference time as the earliest submit_dt
origin = df["submit_dt"].min()

# relative submit time in seconds
df["subtime"] = (df["submit_dt"] - origin).dt.total_seconds()

# relative start time in seconds
df["start_dt"] = pd.to_datetime(df["start_time"])
df["start_time_from_history"] = (df["start_dt"] - origin).dt.total_seconds()

# 3) Convert limits from minutes → seconds
df["walltime"] = df["time_limit"] * 60

# Runtime is already in seconds
df["runtime"]   = df["run_time"]

# Take the max cause runtime can't be bigger than walltime
df["runtime"] = df[["runtime", "walltime"]].min(axis=1)

# 4) Average the list/array of node_power_consumption values
df["power"] = df["node_power_consumption"].apply(lambda arr: float(np.mean(arr)) if (arr is not None and len(arr) > 0) else 0.0)

# 5) Prepare everything else
df["cores"]    = df["num_cores_req"]
df["gpu"]      = df["num_gpus_req"]
df["start_node_from_history"] = df["nodes"]
df["nodes"]    = df["num_nodes_req"]
df["shared"]   = df["shared"]
df["user"]     = df["user_id"]
df["function_name"] = 0

# sort by subtime
df = df.sort_values("subtime")

# 6) Formatter
def format_job(r):
    return (
        f"{{ id: {r.job_id}"
        f" subtime: {int(r.subtime)}"
        f" walltime: {int(r.walltime)}"
        f" runtime: {int(r.runtime)}"
        f" nodes: {r.nodes}"
        f" cores: {r.cores}"
        f" gpu: {r.gpu}"
        f" power: {r.power:.2f}"
        f" shared: {r.shared}"
        f" user: {r.user}"
        f" start_time_from_history: {int(r.start_time_from_history)}"
        f" start_node_from_history: {r.start_node_from_history}"
        f" function_name: {r.function_name} }}"
    )

# 7) Write out one record per line, no quotes
with open("inputs/workloads/converted/PM100.csv", "w") as f:
    for line in df.apply(format_job, axis=1):
        f.write(line + "\n")
