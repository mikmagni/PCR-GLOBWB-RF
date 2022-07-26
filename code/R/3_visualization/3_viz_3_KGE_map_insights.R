# cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")  #with grey
# cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7") #with black

####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####
library('ggh4x')

#script that plots map of KGE for uncalibrated and allpredictors, averaged over
#5 test subsamples and insights on which stations have high/low KGE

outputDir <- '../../../RF/viz/'
dir.create(outputDir, showWarnings = F, recursive = T)

stationInfoMissing <- read.csv('../../../data/stationLatLon.csv') %>% 
  select(grdc_no, miss)
stationInfo <- read.csv('../../../data/stationLatLon_catchAttr.csv') %>% 
  select(grdc_no, lon, lat, area, aridityIdx) %>% inner_join(., stationInfoMissing)

#### data preparation ####
subsample_KGE_list <- list ()
for(subsample in 1:5){
  
  rf.eval.uncalibrated <- read.csv(paste0('../../../RF/validate/subsample_', subsample,
                                          '/KGE_allpredictors.csv')) %>%
    select(.,grdc_no, KGE) %>%
    mutate(.,setup=factor('uncalibrated')) %>% 
    mutate(.,subsample=factor(subsample)) 
  
  #read allpredictors
  rf.eval.allpredictors <- read.csv(paste0('../../../RF/validate/subsample_', subsample,
                                           '/KGE_allpredictors.csv')) %>% 
    select(.,grdc_no, KGE_corrected) %>% 
    rename(., KGE=KGE_corrected) %>% 
    mutate(.,setup=factor('allpredictors'))  %>% 
    mutate(.,subsample=factor(subsample)) 
  
  #put together in one list
  subsample_KGE <- rbind(rf.eval.uncalibrated, rf.eval.allpredictors)
  
  subsample_KGE_list[[subsample]] <- subsample_KGE
  
}

plotData <- do.call(rbind, subsample_KGE_list)

plotData_uncalibrated <- plotData %>% filter(.,setup=='uncalibrated') %>% 
  group_by(grdc_no) %>% 
  summarise(mean_test_KGE_uncalibrated = mean(KGE)) %>% na.omit(.) %>% 
  inner_join(., stationInfo) %>%
  mutate(.,setup=factor('uncalibrated'))


plotData_allpredictors <- plotData %>% filter(.,setup=='allpredictors') %>% 
  group_by(grdc_no) %>% 
  summarise(mean_test_KGE_allpredictors = mean(KGE)) %>% na.omit(.) %>% 
  inner_join(., stationInfo) %>%
  mutate(.,setup=factor('allpredictors'))


#### plot KGE map uncalibrated, allpredictors ####
wg <- map_data("world")

#-----------KGE--------------#
#set KGE intervals 
breaks=c(-Inf, -0.41, 0, 0.2, 0.4, 0.6, 0.8, 0.9, 1)
labels=c('z < -0.41','-0.41 < z < 0', '0 < z < 0.2','0.2 < z < 0.4',
         '0.4 < z < 0.6','0.6 < z < 0.8','0.8 < z < 0.9','0.9 < z < 1')

KGE_map_uncalibrated <- ggplot() +
  geom_map(
    data = wg, map = wg,
    aes(long, lat, map_id = region),
    color = "white", fill= "black"
  ) +
  theme_map()+
  xlim(-180,180)+
  ylim(-55,75)+
  geom_point(plotData_uncalibrated, mapping = aes(x = lon, y = lat,
                                      fill=cut(mean_test_KGE_uncalibrated, breaks=breaks, labels=labels)),
             color='black', pch=21, size = 2) +
  scale_fill_brewer(palette='RdYlBu', guide = guide_legend(reverse=TRUE), name='KGE')+
  labs(title='Uncalibrated PCR-GLOBWB\n') +
  xlab('longitude')+
  ylab('latitude') +
  theme(plot.title = element_text(hjust = 0.5, size=20),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())

KGE_map_allpredictors <- ggplot() +
  geom_map(
    data = wg, map = wg,
    aes(long, lat, map_id = region),
    color = "white", fill= "black"
  ) +
  theme_map()+
  xlim(-180,180)+
  ylim(-55,75)+
  geom_point(plotData_allpredictors, mapping = aes(x = lon, y = lat,
                                                  fill=cut(mean_test_KGE_allpredictors, breaks=breaks, labels=labels)),
             color='black', pch=21, size = 2) +
  scale_fill_brewer(palette='RdYlBu', guide = guide_legend(reverse=TRUE), name='KGE') +
labs(title="Postprocessed - 'allpredictors'\n") +
  xlab('longitude')+
  ylab('latitude') +
  theme(plot.title = element_text(hjust = 0.5, size=20),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())

#patch it 
combined <- ( KGE_map_uncalibrated / KGE_map_allpredictors ) + 
  plot_layout(guides = "collect", width=c(2,2)) &
  guides(fill = guide_legend(override.aes = list(size = 5))) &
  theme(legend.position = 'bottom',
        legend.title = element_text(size=16),
        legend.text = element_text(size=16))
combined

#save
ggsave(paste0(outputDir,'map_kge.png'), combined, height=15, width=15, units='in', dpi=600)




# #performance: improved or degraded KGEf
# eval_allG <- inner_join(plotData_uncalibrated,plotData_allpredictors, by='grdc_no')
# 
# improvement <- eval_allG$mean_test_KGE_allpredictors[which(eval_allG$mean_test_KGE_allpredictors > -0.41)]
# 
# KGE_map_improvement <- ggplot() +
#   geom_map(
#     data = wg, map = wg,
#     aes(long, lat, map_id = region),
#     color = "black", fill= "white"
#   ) +
#   xlim(-180,180)+
#   geom_point(eval_allG, mapping = aes(x = long, y = lat,
#                                       color=improvement),
#              size = 2, show.legend = T) +
#   # labs(title='Performance') +
#   xlab('longitude')+
#   ylab('latitude') +
#   theme_bw()+
#   theme(plot.title = element_text(hjust = 0.5))
# KGE_map_improvement
