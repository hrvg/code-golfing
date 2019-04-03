#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 10 19:06:53 2019

@author: lauraelisa
"""

### MODULES ###
import numpy as np 
import matplotlib.pyplot as plt
from scipy import stats
import pandas as pd
import seaborn as sns

### USER DEFINED FUNCTIONS ###
def read_streamflow_data(file = '/Users/lauraelisa/Documents/Code Golf/Challenge_1/sacramento-bendbridge-paleo.csv'):
	df = pd.read_csv(file, parse_dates=True) #index_col=0,
	return df

### MAIN ###
sac_flow = read_streamflow_data()

### UNITS ###
taf_to_Hm3 = 1233.48/1000000

# TODO

# 1. add a column to the dataframe and convert the annual flow from acre-foot to cubic meters 
sac_flow['Flow_Hm3'] = sac_flow['Flow_AF'].multiply(taf_to_Hm3)

# 2. plot the time series of the flow in cubic meters
sac_flow.plot(y='Flow_Hm3')
plt.ylabel('Streamflow (Hm3)')

# 3. calculate the mean, median and standard deviation of the annual flow per calendar century (e.g. 901 - 1000, 1001 - 1100, ... 2001 - 2019)
sac_stats = sac_flow.groupby(pd.cut(sac_flow['Year'], np.arange(900, 2017, 100))).sum()
sac_stats_mean = sac_flow.groupby(pd.cut(sac_flow['Year'], np.arange(900, 2017, 100))).mean()
sac_stats_median = sac_flow.groupby(pd.cut(sac_flow['Year'], np.arange(900, 2017, 100))).median()
sac_stats_std = sac_flow.groupby(pd.cut(sac_flow['Year'], np.arange(900, 2017, 100))).std()

# (opt. add those three timeseries to the plot created in 2) 
sac_stats['Mean_Hm3']= sac_stats_mean['Flow_Hm3']
sac_stats['Median_Hm3']= sac_stats_median['Flow_Hm3']
sac_stats['Std_Hm3']= sac_stats_std['Flow_Hm3']

sac_stats.plot(y=['Mean_Hm3', 'Median_Hm3', 'Std_Hm3'])

ax = sac_flow.plot(y='Flow_Hm3') 
sac_stats.plot(y=['Mean_Hm3', 'Median_Hm3', 'Std_Hm3'],ax=ax)


#4 re-order the data-frame so that the data are ordered by increasing mean flow
#sac_stats.sort_values(by=['Mean_Hm3'], inplace =True)












