import pandas as pd
from collections import defaultdict

df = pd.read_csv("outputs/set_of_endpoints_2_meggie_and_emmy_count_from_database_carbon.csv")

df = df[df[" User_id"] == 0]

endpoint_usage = defaultdict(int)

slice_to_endpoints = defaultdict(set)

for _, row in df.iterrows():
    selected_endpoint = row[" Selected_endpoint"]
    slices = list(map(int, str(row[" slices"]).split()))  # Convert slices column to list of integers

    for slice_idx in slices:
        if endpoint_usage[selected_endpoint] < 8760:
            # ~ print("selected_endpoint", selected_endpoint)
            # ~ print("slice_idx", slice_idx)
            slice_to_endpoints[slice_idx].add(selected_endpoint)
            endpoint_usage[selected_endpoint] += 1  # Increase usage count

slice_to_endpoints = {k: list(v) for k, v in slice_to_endpoints.items()}

for slice_idx, endpoints in sorted(slice_to_endpoints.items()):
    print(f"Slice {slice_idx}: {endpoints}")
