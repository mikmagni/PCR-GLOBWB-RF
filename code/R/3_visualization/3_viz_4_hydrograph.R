####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####
source('fun_3_hydrograph_fdc_residuals.R')
####-------------------------------####

## plot observed, uncalibrated, corrected hydrograph
#~ subsample <- '1' # choose subsample number here

combiPlot <- function(i){  
    
  station_no <- stationInfo$grdc_no[i]
  upstreamArea <- stationInfo$area[i]
  convRatio <- upstreamArea/0.0864
  
  print(station_no)
  
  KGE_uncalib <- round(KGE_table$KGE[KGE_table$grdc_no==station_no],2)
  KGE_corrected <- round(KGE_table$KGE_corrected[KGE_table$grdc_no==station_no],2)
  miss_data <- KGE_table$miss[KGE_table$grdc_no==station_no]
  
  hg <- plot_hydrograph(station_no, convRatio)
  fdc <- plot_ecdf(station_no, convRatio)
  resPlot <- plot_residuals(station_no, convRatio)
  
  combined <- hg / fdc  / resPlot 
  combined <- combined + 
    plot_annotation(
      title = (paste0(station_no,' : ', str_to_title(stationInfo$station[i]), ' (',
                      str_to_title(stationInfo$river[i]), ', ', stationInfo$country[i], ')')),
      subtitle = paste0('lat: ', stationInfo$lat[i], ', lon: ', stationInfo$lon[i],
                        '\nUpstream area: ', upstreamArea, ' km2'),
      caption = paste0('KGE: ', KGE_uncalib, ' (uncalibrated), ', KGE_corrected, ' (RF-corrected)\n',
                       'Missing data (1979-2019): ', miss_data, '%')) &
    theme(plot.title = element_text(hjust= 0.5, size = 18, face='bold')) &
    theme(plot.subtitle = element_text(hjust= 0.5, size = 14)) &
    theme(plot.caption = element_text(size = 12)) &
    theme(text = element_text('mono')) 
  combined
  
  ggsave(paste0(outputDirCombo,'comboPlot_',station_no,'.png'), combined, height=10, width=20, units='in', dpi=300)
  
}

for(subsample in 1:5){
    
    print(paste0('subsample: ', subsample))
    
    dir <- paste0('../../../RF/validate/subsample_', subsample, '/tables_allpredictors/')

    stationInfo <- read.csv(paste0('../../../RF/rf_input/subsample_',subsample,'/test_stations.csv'))

    KGE_table <- read.csv(paste0('../../../RF/validate/subsample_',subsample,'/KGE_allpredictors.csv')) %>%
      inner_join(.,read.csv('../../../data/stationLatLon.csv') %>% 
                   select(c('grdc_no','miss')), by='grdc_no')

    #### a combined plot test ####
    outputDirCombo <- paste0('../../../RF/viz/subsample_', subsample, '/comboPlots/')
    dir.create(outputDirCombo, showWarnings = F, recursive = T)
    print('plotting...')


    mclapply(1:nrow(stationInfo), combiPlot, mc.cores=48)
}
