# python3 src/get_stats_fixed_slice.py

import pandas as pd
import glob
import re

# Function to extract the slice number from filename
def extract_slice_number(filename):
    match = re.search(r"slice_(\d+)", filename)
    return int(match.group(1)) if match else float('inf')

# Get all slice_* files and sort them numerically
files = sorted(glob.glob("outputs/slice_*"), key=extract_slice_number)

# Process each file
for file in files:
    df = pd.read_csv(file)

    # Filter rows where User_id == 0
    df = df[df[" User_id"] == 0]

    # Count occurrences of each Selected_endpoint (0, 1, 2, 3)
    endpoint_counts = df[" Selected_endpoint"].value_counts().reindex([0, 1, 2, 3], fill_value=0)

    # Compute proportions
    total_lines = len(df)
    endpoint_proportions = (endpoint_counts / total_lines) * 100 if total_lines > 0 else 0

    # Print sorted output
    print(f"\nFile: {file}")
    for endpoint in [0, 1, 2, 3]:
        print(f"Selected_endpoint {endpoint}: {endpoint_counts[endpoint]} ({endpoint_proportions[endpoint]:.2f}%)")
