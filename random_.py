# %%
import pandas as pd
import random
df=pd.DataFrame({"Age":[random.randint(20, 60) for n in range(100)],
                "Weight":[random.randint(45, 100) for n in range(100)],
                "Income":[random.randint(200, 1000) for n in range(100)],
                "Sex":[random.choice(['Male', 'Female', 'Bi']) for n in range(100)]})
# df.plot.scatter(x = 'Age', y = 'Income')
# %%
import matplotlib.pyplot as plt
import seaborn as sns

# %%
sns.scatterplot(x='Age', y='Income', data = df, hue = 'Sex')

# %%
# 男性にfilterして散布図描画
# sns.scatterplot(x='Age', y='Income', data = df[df['Sex']=='Male'], hue = 'Sex')

# %%
pd.options.display.precision = 1
df.describe()

# %%
sns.violinplot(x = 'Sex', y = 'Income', data = df)

# %%
sns.boxplot(data = df, hue = 'Sex', x = 'Sex', y = 'Income')

# %%
# 性別別で総当たり
sns.pairplot(data = df, hue = 'Sex')

# %%
# 総当たり
sns.pairplot(data = df)

# %%
# サンプリング
df.sample(2)
# %%
# 女性をサンプリング
df[df['Sex']=='Female'].sample(2)

# %%
