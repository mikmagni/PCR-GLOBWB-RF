# !/usr/bin/env python2
# -*- coding: utf-8 -*-
"""

@author: mikmagni

"""
#========================================================================
#
#   This script extracts grdc time series (monthly scale)
#   based on grdc station number        
# 
#
#======================================================================== 

import pandas as pd
import os 
import numpy as np
from alive_progress import alive_bar
import time

filePath = '/scratch/6574882/grdc_discharge_monthly_complete/'
outputPath = '/home/6574882/PCR-GLOBWB-RF/data/preprocess/grdc_discharge_monthly/'
loc = pd.read_csv('../../data/stationLatLon_monthly.csv')

if not os.path.exists(outputPath):
	os.makedirs(outputPath)

with alive_bar(len(loc), force_tty=True) as bar:
	
	for j in range(len(loc)):
		
		station_no = str(loc['grdc_no'][j])
		# ~ station_name = loc['station'][j].lower()  
		# ~ print(station_no, ':', station_name)

		# read discharge, values start from line 40 of .txt files idx[39]
		grdc_discharge = open(filePath + station_no + '_Q_Month.txt', encoding= 'unicode_escape')
		lines = grdc_discharge.readlines()

		df = pd.DataFrame(lines[39:])
		
		df = df[0].str.split(pat=';',expand=True)
		df.columns=['datetime','hour','obs','calculated','flag']
		df.drop('hour', inplace=True, axis=1)
		
		df['datetime'] = pd.to_datetime(df['datetime'])
		df['obs'] = pd.to_numeric(df['obs'])
		df['calculated'] = pd.to_numeric(df['calculated'])
		df['flag'] = pd.to_numeric(df['flag'])
		
		df.to_csv(outputPath+'grdc_monthly_'+station_no+'.csv', index=False, float_format='%.3f')

		bar()
