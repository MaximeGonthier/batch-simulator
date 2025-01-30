import pandas as pd

# Read the file (assuming no header)
df = pd.read_csv("test.txt", header=None)

# Extract the column
values = df.iloc[:, 0]

# Compute mean and median
mean_value = values.mean()
median_value = values.median()

print(f"Mean: {mean_value}")
print(f"Median: {median_value}")
