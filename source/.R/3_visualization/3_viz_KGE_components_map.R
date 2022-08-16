####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####
source('fun_3_KGE_1_mapBoxPlot.R')
# visualize global map of model performance

subsample <- 'subsample_1/'
stationInfo <- read.csv(paste0('../../../RF/rf_input/', subsample,'test_stations.csv'))

rf.eval.allpredictors <- read.csv(paste0('../../../RF/validate/', subsample,'KGE_allpredictors.csv'))
rf.eval.qstatevars <- read.csv(paste0('../../../RF/validate/', subsample,'KGE_qstatevars.csv'))
rf.eval.meteoCatchAttr <- read.csv(paste0('../../../RF/validate/', subsample,'KGE_meteoCatchAttr.csv'))
# rf.eval.xgboost <- read.csv(paste0('../../../XG/validate/', subsample, 'KGE_XG_allpredictors.csv'))

outputDir <- paste0('../../../RF/viz/',subsample)
dir.create(outputDir, showWarnings = F, recursive = T)

wg <- map_data("world")
stations_xy <- stationInfo %>% select(grdc_no, lat, lon)

#-----------KGE--------------#
#set KGE intervals 
breaks=c(-Inf, -5.0, -1, 0, 0.2, 0.6, 0.8, 0.9, 1)
labels=c('z < -5', '-5 < z < -1', '-1 < z < 0', '0 < z < 0.2','0.2 < z < 0.6',
         '0.6 < z < 0.8','0.8 < z < 0.9','0.9 < z < 1')
legendName = 'KGE'

#select KGE component
KGE_comp <- 'KGE'
KGE_comp_corrected <- 'KGE_corrected' 

yscale_lim = c(-0.5,1)

source('fun_3_KGE_2_griddedMapBox.R')

# combined
ggsave(paste0(outputDir,'map_kge.tiff'), combined, height=20, width=15, units='in', dpi=300)


#-----------KGE components - correlation--------------#
#set KGE intervals (correlation is only [0 1])
breaks=c(-Inf,0, 0.2, 0.4, 0.6, 0.8, 0.9, 1)
labels=c('cor <0','0 < cor < 0.2','0.2 < cor < 0.4','0.4 < cor < 0.6',
         '0.6 < cor < 0.8','0.8 < cor < 0.9','0.9 < cor < 1')
legendName = 'KGE: correlation'

#select KGE component
KGE_comp <- 'KGE_r'
KGE_comp_corrected <- 'KGE_r_corrected' 

#boxplot scale limits
yscale_lim = c(0.5,1)

source('fun_3_KGE_2_griddedMapBox.R')

# combined
ggsave(paste0(outputDir,'map_kge_r.tiff'), combined, height=20, width=15, units='in', dpi=300)

#-----------KGE components - alpha--------------#
#set KGE intervals 
breaks=c(-Inf, 0, 0.5, 0.9, 1.1, 1.5, 2, Inf)
labels=c('z < 0', '0 < z < 0.5', '0.5 < z < 0.9','0.9 < z < 1.1', 
         '1.1 < z < 1.5','1.5 < z < 2','z > 2')
legendName = 'KGE: alpha'

#select KGE component
KGE_comp <- 'KGE_alpha'
KGE_comp_corrected <- 'KGE_alpha_corrected' 

yscale_lim = c(0.5,1)

source('fun_3_KGE_2_griddedMapBox.R')

# combined
ggsave(paste0(outputDir,'map_kge_alpha.tiff'), combined, height=20, width=15, units='in', dpi=300)

#-----------KGE components - beta--------------#
#set KGE intervals 
breaks=c(-Inf, 0, 0.5, 0.9, 1.1, 1.5, 2, Inf)
labels=c('z < 0', '0 < z < 0.5', '0.5 < z < 0.9','0.9 < z < 1.1', 
         '1.1 < z < 1.5','1.5 < z < 2','z > 2')
legendName = 'KGE: beta'

#select KGE component
KGE_comp <- 'KGE_beta'
KGE_comp_corrected <- 'KGE_beta_corrected' 

source('fun_3_KGE_2_griddedMapBox.R')

# combined
ggsave(paste0(outputDir,'map_kge_beta.tiff'), combined, height=20, width=15, units='in', dpi=300)

####---------------------------------------####
####-----------some statistics-------------####
summary(rf.eval.allpredictors$KGE_corrected)
summary(rf.eval.qstatevars$KGE_corrected)
summary(rf.eval.meteoCatchAttr$KGE_corrected)
summary(rf.eval.xgboost$KGE_corrected)

### improvement percentage
vector <- rf.eval.allpredictors
improvement <- length(vector$grdc_no[vector$KGE_corrected > vector$KGE]) / nrow(stationInfo)
improvement

vector <- rf.eval.qstatevars
improvement <- length(vector$grdc_no[vector$KGE_corrected > vector$KGE]) / nrow(stationInfo)
improvement

### KGE passed from <0 to >0
vector <- rf.eval.allpredictors
to_positive <- length(vector$grdc_no[vector$KGE_corrected > 0 & vector$KGE < 0 ]) / nrow(stationInfo)
to_positive

vector <- rf.eval.qstatevars
to_positive <- length(vector$grdc_no[vector$KGE_corrected > 0 & vector$KGE < 0 ]) / nrow(stationInfo)
to_positive

vector <- rf.eval.xgboost
to_positive <- length(vector$grdc_no[vector$KGE_corrected > 0 & vector$KGE < 0 ]) / nrow(stationInfo)
to_positive




summary(rf.eval.allpredictors$KGE_r_corrected)
summary(rf.eval.qstatevars$KGE_r_corrected)
summary(rf.eval.allpredictors$KGE_alpha_corrected)
summary(rf.eval.qstatevars$KGE_alpha_corrected)
summary(rf.eval.allpredictors$KGE_beta_corrected)
summary(rf.eval.qstatevars$KGE_beta_corrected)

# ####------------------------------------------------------####
# #### map with all predictors KGE, stations that get worse ####
# breaks=c(-Inf, -5.0, -1, 0, 0.2, 0.6, 0.8, 0.9, 1)
# labels=c('z < -5', '-5 < z < -1', '-1 < z < 0', '0 < z < 0.2','0.2 < z < 0.6',
#          '0.6 < z < 0.8','0.8 < z < 0.9','0.9 < z < 1')
# legendName = 'KGE'
# 
# #select KGE component
# KGE_comp <- 'KGE'
# KGE_comp_corrected <- 'KGE_corrected' 
# 
# yscale_lim = c(-0.5,1)
# 
# 
# #uncalibrated
# gof_col_select = 'pcr_uncalibrated' # or 'pcr_RFcorrected'
# title = 'Uncalibrated PCR-GLOBWB'
# legend_yn=F
# 
# KGE_uncalibrated <- KGE_map(rf.eval=rf.eval.allpredictors, breaks=breaks,labels=labels,
#                             gof_col=gof_col_select, title=title, legend_yn=legend_yn,
#                             KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected)
# box_uncalibrated <- KGE_boxplot(rf.eval=rf.eval.allpredictors, gof_col=gof_col_select,
#                                 KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected)
# 
# #rf_corrected fitting observations
# gof_col_select = 'pcr_RFcorrected'
# title = 'RF-corrected (all predictors)'
# legend_yn=T
# 
# KGE_corrected_allpred <- KGE_map(rf.eval=rf.eval.allpredictors, breaks=breaks,labels=labels,
#                                  gof_col=gof_col_select, title=title, legend_yn=legend_yn, 
#                                  KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected)
# box_corrected_allpred <- KGE_boxplot(rf.eval=rf.eval.allpredictors, gof_col=gof_col_select,
#                                      KGE_comp=KGE_comp, KGE_comp_corrected=KGE_comp_corrected) 
# 
# 
#performance: improved or degraded KGE
eval_allG <- rf.eval.allpredictors %>%
  inner_join(.,stations_xy, by='grdc_no') %>%
  mutate(improvement=ifelse(KGE < KGE_corrected, 'yes', 'no')) %>%
  na.omit(.)


KGE_map_improvement <- ggplot() +
  geom_map(
    data = wg, map = wg,
    aes(long, lat, map_id = region),
    color = "black", fill= "white"
  ) +
  xlim(-180,180)+
  geom_point(eval_allG, mapping = aes(x = long, y = lat,
                                      color=improvement),
             size = 2, show.legend = T) +
  # labs(title='Performance') +
  xlab('longitude')+
  ylab('latitude') +
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
KGE_map_improvement
# 
# combined <- box_uncalibrated / box_corrected_allpred | 
#   KGE_uncalibrated / KGE_corrected_allpred / KGE_map_improvement
# combined <- combined + plot_layout(guides = "collect", width=c(1,2)) 
# # combined
# ggsave(paste0(outputDir,'map_kge_allpredictors.tiff'), combined, height=20, width=15, units='in', dpi=300)

