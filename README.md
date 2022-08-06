# PCR-GLOBWB-RF

## Introduction
Models are plagued by uncertainty in their components. A variety of methdologies exist that address uncertainty. \
We correct streamflow simulations from global hydrological model PCR-GLOBWB ([Sutanudjaja et al., 2018](https://doi.org/10.5194/gmd-11-2429-2018)) using random forest regression, for the years 1979-2019.
In addition to meteorological input and catchment attributes, we use hydrological state variables from PCR-GLOBWB as predictors of observed discharge (response variable). \
This repo is an update of the method by [Shen et al. (2022)](https://doi.org/10.1016/j.cageo.2021.105019) to the global scale. 

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
The R module follows the post-processing phases described in **manuscript**.
The necessary packages are loaded at the beginning of each script and installed if missing using fun_0_loadLibrary.R

### 0_preprocess_grdc
0. Upscales daily discharge to monthly, merges daily and monthly if a station has both, keeps upscaled daily if available at a timestep.
1. Merges stations from stationLatLon_daily.csv and stationLatLon_monthly.csv into stationLatLon.csv
2. Calculates % missing data for the modelled years (here 1979-2019).
3. Visualizes stations map and relative data availability. 

### 0_preprocess_predictors
0. Parameters: generates timeseries of static catchment attributes (.csv)
0. qMeteoStatevars: merges timeseries of meteo input and state variables (.csv)
1. Merge all predictors : merges Parameters and qMeteoStatevars (.csv)

### 1_correlation_analysis
bigTable : puts together all stations predictor tables *allpredictors* \
corrplot : visualizes correlation plot of all predictors

### 2_randomForest
0. Subsample -> Subsamples stationLatLon.csv to generate a training table that contains ~70% of all available timesteps. 
1. Tune -> Uses training table from 0 to tune Random Forest hyperaparameters. 
2. Train / Testing -> Can be done separately (train and then validate) or in batch (train_test). Calculates variable importance and KGE (before and after post-processing).

### 3_visualization
