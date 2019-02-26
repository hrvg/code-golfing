### MODULES ###
import numpy as np 
import matplotlib.pyplot as plt
from scipy import stats
import pandas as pd
import seaborn as sns

### USER DEFINED FUNCTIONS ###
def read_streamflow_data(file = './data/sacramento-bendbridge-paleo.csv'):
	import pandas as pd
	df = pd.read_csv(file, index_col=0, parse_dates=True)
	return df

### MAIN ###


# TODO

# 1. add a column to the dataframe and convert the annual flow from acre-foot to cubic meters 
df = read_streamflow_data()
cms = df['Flow_AF']*0.0283168
df['Flow_CMS'] = pd.Series(cms)

# 2. plot the time series of the flow in cubic meters
year = df.index.values
plt.plot(year,df['Flow_CMS'])
# plt.show()

# 3. calculate the mean, median and standard deviation of the annual flow per calendar century (e.g. 901 - 1000, 1001 - 1100, ... 2001 - 2019)
century_counter = 1
century = []
century_col = []
mean = []
median = []
stdev = []
for index, flow in enumerate(df['Flow_CMS']):
	century.append(df['Flow_CMS'].iloc[index])
	if len(century) == 100:
		mean.append(np.nanmean(century))
		median.append(np.nanmedian(century))
		stdev.append(np.std(century))
		century_col.append(century_counter)
		century = []
		century_counter += 1
d = {'Century':century_col, 'Mean':mean, 'Median':median, 'StDev':stdev}
stats = pd.DataFrame(d)
# (opt. add those three timeseries to the plot created in 2)

# 4. re-order the data-frame so that the data are ordered by increasing mean flow

df_sorted = df.sort_values('Flow_AF')
