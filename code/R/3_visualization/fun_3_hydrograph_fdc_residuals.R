# cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")  #with grey
# cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7") #with black

plot_hydrograph <- function(station_no, convRatio){
  
  all_q <- read.csv(paste0(dir, 'rf_result_', station_no,'.csv'), header = T) %>%
    mutate(datetime=as.Date(datetime)) %>% select(., datetime:res_corrected)
  all_q$pcr[is.na(all_q$obs)] <- NA
  all_q$pcr_corrected[is.na(all_q$obs)] <- NA
  
  plotData <- all_q %>% select(-c('res','res_corrected')) %>% 
    gather(.,condition, value, obs:pcr_corrected)
  
  ggplot(plotData,
         aes(x=datetime, y=value, col=condition, group = condition)) +
    geom_line(aes(linetype=condition), size=0.5) +
    geom_point(aes(shape=condition), size=1.5, alpha = 0.6) +
    # ggtitle(paste0(station_no,' : ', str_to_title(stationInfo$station[i]), ' (', 
    #                str_to_title(stationInfo$river[i]), ', ', stationInfo$country[i], ')', 
    #                ' ; ', 'lat: ', stationInfo$lat[i], ', lon: ', stationInfo$lon[i])) +
    xlab('date') + ylab('flow depth (m/d)') +
    scale_y_continuous(sec.axis = sec_axis(~.*convRatio, name=expression('discharge (' *m^{3}/s* ')'))) +
    scale_color_manual(values=c("#56B4E9","#000000","#E69F00"))+
    theme_minimal() +
    theme(legend.title=element_blank(), axis.title = element_text(face="bold"))
  
}


plot_ecdf <- function(station_no, convRatio){
  
  all_q <- read.csv(paste0(dir, 'rf_result_', station_no,'.csv'), header = T) %>%
    mutate(datetime=as.Date(datetime)) %>% select(., datetime:res_corrected) %>%
    na.omit(.)
  
  plotData <- all_q %>% select(-c('res','res_corrected')) %>% 
    gather(.,condition, value, obs:pcr_corrected)
  
  ggplot(plotData, aes(value, col=condition)) +
    stat_ecdf(size=1, alpha=0.6)+
    # ggtitle(paste0(station_no,' : ', str_to_title(stationInfo$station[i]), ' (', 
    #                str_to_title(stationInfo$river[i]), ', ', stationInfo$country[i], ')', 
    #                ' ; ', 'lat: ', stationInfo$lat[i], ', lon: ', stationInfo$lon[i])) +
    scale_x_continuous(sec.axis = sec_axis(~.*convRatio, name=expression('discharge (' *m^{3}/s* ')'))) +
    coord_flip() +
    labs(col='CDF') +
    xlab('flow depth (m/d)') + ylab('p') +
    scale_color_manual(values=c("#56B4E9","#000000","#E69F00")) +
    theme_minimal() +
    theme(legend.title=element_blank(), axis.title = element_text(face="bold"))

}


plot_residuals <- function(station_no, convRatio){
  
  all_q <- read.csv(paste0(dir, 'rf_result_', station_no,'.csv'), header = T) %>%
    mutate(datetime=as.Date(datetime)) %>% select(., datetime:res_corrected) %>%
    na.omit()
  
  plotData <- all_q %>% select(-c('pcr','pcr_corrected')) %>% 
    gather(.,condition, value, res:res_corrected)
  
  ggplot(plotData, aes(x=obs, y=value, col=condition)) +
    geom_point(size=2,alpha=0.6)+
    # ggtitle(paste0(station_no,' : ', str_to_title(stationInfo$station[i]), ' (', 
    #                str_to_title(stationInfo$river[i]), ', ', stationInfo$country[i], ')', 
    #                ' ; ', 'lat: ', stationInfo$lat[i], ', lon: ', stationInfo$lon[i])) +
    scale_y_continuous(sec.axis = sec_axis(~.*convRatio, name=expression('discharge (' *m^{3}/s* ')'))) +
    labs(col='residual') +
    xlab('observed flow depth (m/d)') +
    ylab('residual (m/d)') +
    scale_color_manual(values=c("#000000","#E69F00")) +
    theme_minimal() +
    theme(legend.title=element_blank(), axis.title = element_text(face="bold"))
  
}
