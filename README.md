# PCR-GLOBWB-RF
Post-processing streamflow simulations from PCR-GLOBWB using random forest regression

## Introduction
Physical models of real-world variables are plagued by uncertainty in model components. \
Here, we correct streamflow simulations from global hydrological model PCR-GLOBWB using random forest regression, for the years 1979-2019. \
In addition to meteorological input and catchment attributes, we use hydrological state variables from PCR-GLOBWB as predictors of observed discharge (response variable).

## Streamflow observations
River discharge data was downloaded from the Global Runoff Data Centre (GRDC). 
2286 stations with variable availability of observations were selected (min. area = 10 000 km<sup>2</sup>)
The selected stations can be found in data/stationLatLon.csv 
