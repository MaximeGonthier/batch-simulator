# In our experiments we evaluate our schedulers week by week.
# Our workload is constituted of 51 weeks, ranging from January the 3rd 2022 to December the 25th 2022.
# This code randomly generate 10 numbers between 1 and 51 using the seed "0".
# We used these 10 randomly selected weeks to conduct our experiments.

import random

random.seed(0)

nums = list(range(1, 52)) # List of integers from 1 to 51

random.shuffle(nums)

print(nums[0:10]) # <- List of 10 unique random numbers

# The produce numbers are [28, 13, 43, 41, 42, 8, 6, 36, 2, 50]
# Which corresponds to the weeks (format is month-day):
# 2:	01-10 01-16
# 6:	02-07 02-13
# 8:	02-21 02-27
# 13:	03-28 04-03
# 28:	07-11 07-17
# 36:	09-05 09-11
# 41:	10-10 10-16
# 42:	10-17 10-23
# 43:	10-24 10-30
# 50:	12-12 12-28
