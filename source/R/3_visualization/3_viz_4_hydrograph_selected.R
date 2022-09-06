####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####
source('fun_3_hydrograph_fdc_residuals.R')
####-------------------------------####

## plot observed, uncalibrated, corrected hydrograph
#~ subsample <- '1' # choose subsample number here

combiPlot <- function(station_no){  
  
  print(station_no)
  
  KGE_uncalib <- round(KGE_table$KGE[KGE_table$grdc_no==station_no],2)
  KGE_corrected <- round(KGE_table$KGE_corrected[KGE_table$grdc_no==station_no],2)
  miss_data <- KGE_table$miss[KGE_table$grdc_no==station_no]
  
  hg <- plot_hydrograph(station_no, convRatio)
  fdc <- plot_ecdf(station_no, convRatio)
  resPlot <- plot_residuals(station_no, convRatio)
  
  combined <- hg / ( fdc  | resPlot )
  combined <- combined + 
    plot_layout(guides = 'collect') +
    plot_annotation(
      title = (paste0(station_no,' : ', station, ' (',
                      river, ', ', country, ')')),
      subtitle = paste0('Upstream area: ', upstreamArea, ' km2\n'),
      caption = paste0('KGE: ', KGE_uncalib, ' (uncalibrated), ', KGE_corrected, ' (post-processed)')) &
    theme(plot.title = element_text(hjust= 0.5, size = 22, face='bold'),
          plot.subtitle = element_text(hjust= 0.5, size = 18),
          plot.caption = element_text(size = 16),
          text = element_text('mono'),
          legend.position = 'none')
  # combined
  
  ggsave(paste0(outputDirCombo,'comboPlot_',station_no,'.png'), combined, height=7, width=14, units='in', dpi=600)
  
}


#### select subsample and station number ####
subsample <- '1'

# read from right directory
dir <- paste0('../../../RF/validate/subsample_', subsample, '/tables_allpredictors/')
stationInfo <- read.csv(paste0('../../../RF/rf_input/subsample_',subsample,'/test_stations.csv'))
KGE_table <- read.csv(paste0('../../../RF/validate/subsample_',subsample,'/KGE_allpredictors.csv')) %>%
  inner_join(.,read.csv('../../../data/stationLatLon.csv') %>% 
               select(c('grdc_no','miss')), by='grdc_no')

# set output directory
outputDirCombo <- paste0('../../../RF/viz/subsample_', subsample, '/comboPlots/')
dir.create(outputDirCombo, showWarnings = F, recursive = T)

station_no <- '1134300'
upstreamArea <- stationInfo$area[stationInfo$grdc_no==station_no]
convRatio <- upstreamArea/0.0864
station <-  str_to_title(stationInfo$station[stationInfo$grdc_no==station_no])
river <- str_to_title(stationInfo$river[stationInfo$grdc_no==station_no])
country <- stationInfo$country[stationInfo$grdc_no==station_no]
latitude <- stationInfo$lat[stationInfo$grdc_no==station_no]
longitude <- stationInfo$lon[stationInfo$grdc_no==station_no]

good_plot1 <- combiPlot(station_no)

station_no <- '4113303'
upstreamArea <- stationInfo$area[stationInfo$grdc_no==station_no]
convRatio <- upstreamArea/0.0864
station <-  str_to_title(stationInfo$station[stationInfo$grdc_no==station_no])
river <- str_to_title(stationInfo$river[stationInfo$grdc_no==station_no])
country <- stationInfo$country[stationInfo$grdc_no==station_no]
latitude <- stationInfo$lat[stationInfo$grdc_no==station_no]
longitude <- stationInfo$lon[stationInfo$grdc_no==station_no]

good_plot2 <- combiPlot(station_no)




combiPlot <- function(station_no){  
  
  print(station_no)
  
  KGE_uncalib <- round(KGE_table$KGE[KGE_table$grdc_no==station_no],2)
  KGE_corrected <- round(KGE_table$KGE_corrected[KGE_table$grdc_no==station_no],2)
  miss_data <- KGE_table$miss[KGE_table$grdc_no==station_no]
  
  hg <- plot_hydrograph(station_no, convRatio)
  fdc <- plot_ecdf(station_no, convRatio)
  resPlot <- plot_residuals(station_no, convRatio)
  
  combined <- hg / ( fdc  | resPlot )
  combined <- combined + 
    plot_layout(guides = 'collect') +
    plot_annotation(
      title = (paste0(station_no,' : ', station, ' (',
                      river, ', ', country, ')')),
      subtitle = paste0('Upstream area: ', upstreamArea, ' km2\n'),
      caption = paste0('KGE: ', KGE_uncalib, ' (uncalibrated), ', KGE_corrected, ' (post-processed)')) &
    theme(plot.title = element_text(hjust= 0.5, size = 22, face='bold'),
          plot.subtitle = element_text(hjust= 0.5, size = 18),
          plot.caption = element_text(size = 16),
          text = element_text('mono'),
          legend.position = 'bottom')
  # combined
  
  ggsave(paste0(outputDirCombo,'comboPlot_',station_no,'.png'), combined, height=7, width=14, units='in', dpi=600)
  
}

station_no <- '2178950'
upstreamArea <- stationInfo$area[stationInfo$grdc_no==station_no]
convRatio <- upstreamArea/0.0864
station <-  str_to_title(stationInfo$station[stationInfo$grdc_no==station_no])
river <- str_to_title(stationInfo$river[stationInfo$grdc_no==station_no])
country <- stationInfo$country[stationInfo$grdc_no==station_no]
latitude <- stationInfo$lat[stationInfo$grdc_no==station_no]
longitude <- stationInfo$lon[stationInfo$grdc_no==station_no]

bad_plot <- combiPlot(station_no)



