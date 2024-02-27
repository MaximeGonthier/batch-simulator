import seaborn as sns

# For some examples, we'll be able to use the raw data directly.
tips = sns.load_dataset('tips')
tips.head()
agg_tips = tips.groupby(['day', 'sex'])['tip'].sum().unstack().fillna(0)
agg_tips
from matplotlib import pyplot as plt

# Very simple one-liner using our agg_tips DataFrame.
agg_tips.plot(kind='bar', stacked=True)

ax = sns.histplot(
    tips,
    x='day',
    # Use the value variable here to turn histogram counts into weighted
    # values.
    weights='tip',
    hue='sex',
    multiple='stack',
    palette=['#24b1d1', '#ae24d1'],
    # Add white borders to the bars.
    edgecolor='white',
    # Shrink the bars a bit so they don't touch.
    shrink=0.8
)

ax.set_title('Tips by Day and Gender')
# Remove 'Count' ylabel.
ax.set_ylabel(None)
