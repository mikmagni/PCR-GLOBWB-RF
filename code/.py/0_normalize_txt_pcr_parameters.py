# !/usr/bin/env python2
# -*- coding: utf-8 -*-
"""

@author: mikmagni 11-6-2022 00:42

"""
#========================================================================
#
#   Normalization of upstream averaged parameter maps values.
#	Note: these are statics predictors (same value for the whole timeseries.
# 
#
#======================================================================== 

import pandas as pd
import os 
import numpy as np
from alive_progress import alive_bar
import re

filePath = '../../data/preprocess/pcr_parameters_txt/'
parameterList = os.listdir(filePath)
outputPath = '../../data/preprocess/pcr_parameters_normalized/'

## normalize catchment attributes, 
## save to .csv in /data/../pcr_parameters_normalized 
for i in range(len(parameterList)):

	varName = re.search('upstream_(.*).txt', parameterList[i])
	varName = varName.group(1)
	print(varName)
	
	#open file
	df = pd.read_csv((filePath + parameterList[i]), delim_whitespace=True)
	df.columns = ['lon','lat','value']
		
	#calculate mean and standard dev.
	df_mean = stats.mean(df['value'])
	df_stdev= stats.stdev(df['value'])
	
	#normalize 
	df_normalized = ((df['value'] - df_mean)) / df_stdev

	#write new .txt file
	df['value'] = df_normalized
	df.to_csv((outputPath + 'upstream_norm_' + varName +'.txt') , index=False)
