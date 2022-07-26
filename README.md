# PCR-GLOBWB-RF
Post-processing streamflow simulations from PCR-GLOBWB using random forest regression.

## Introduction
Physical models of real-world variables are plagued by uncertainty in model components. \
We correct streamflow simulations from global hydrological model PCR-GLOBWB ([Sutanudjaja et al., 2018](https://doi.org/10.5194/gmd-11-2429-2018)) using random forest regression, for the years 1979-2019.
In addition to meteorological input and catchment attributes, we use hydrological state variables from PCR-GLOBWB as predictors of observed discharge (response variable).
Here, we update the method by [Shen et al. (2022)](https://doi.org/10.1016/j.cageo.2021.105019) to global scale. 

## Streamflow observations 
River discharge data was downloaded from the Global Runoff Data Centre ([GRDC](https://www.bafg.de/GRDC)). \
2286 stations with variable availability of observations were selected (min. area = 10 000 km<sup>2</sup>) \
The selected stations can be found stationLatLon.csv (merged daily and monthly).

## Python module
The python module is used to extract raw data into homogeneous .csv files. 
- Extraction of GRDC discharge, either daily or monthly (from .txt)
- Extraction of PCR-GLOBWB upstream averaged parameters (from data/allpoints_catchAttr.csv into stationLatLon.csv)
- Extraction of PCR-GLOBWB upstream averaged meteo input and state variables (from .netCDF).

## R module
The R module follows the post-processing phases described in **manuscript**

### 0_preprocess_grdc
0. Upscales daily discharge to monthly, merges daily and monthly if a station has both, keeps upscaled daily if available at a timestep.
1. Merges stations from stationLatLon_daily.csv and stationLatLon_monthly.csv into stationLatLon.csv
2. Calculates % missing data for the modelled years (here 1979-2019).
3. Visualizes stations map and relative data availability. 

### 0_preprocess_predictors


### 1_correlation_analysis


### 2_randomForest


### 3_visualization
