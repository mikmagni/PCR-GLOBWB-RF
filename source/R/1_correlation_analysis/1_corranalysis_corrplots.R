####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####

#### all predictors ####
bigOne_all <- vroom('../../../data/bigTable_allpredictors.csv', show_col_type=FALSE)
outputDir <- '../../..//RF/viz/'
dir.create(outputDir, showWarnings = FALSE, recursive = TRUE)

allvars_all <- select(bigOne_all, -c('datetime','obs')) %>% rename(pcrFlowDepth=pcr)

# reordering #
dynamicPreds <- allvars_all %>% select(desalinationAbstraction:nonIrrWaterConsumption)
alphabeticDynamicPreds <- dynamicPreds %>% select(order(colnames(dynamicPreds)))
staticPreds <- allvars_all %>% select(airEntry1:tanSlope)
allvars_all_ordered <- allvars_all %>% select(pcrFlowDepth:referencePotET) %>% 
  cbind(.,alphabeticDynamicPreds) %>% cbind(staticPreds)
  
# calculate correlation #
corAll_all <- cor(allvars_all)

png(filename=paste0(outputDir, 'corrplot.png'), units='in', width=10, height=10, res=600)
corrplot(corAll_all, method='square')
dev.off()

# #### only time-variant predictors
# bigOne <- vroom('../data/bigTable_allpredictors.csv', show_col_type=FALSE)
# 
# allvars <- bigOne %>% select(., -c('datetime','obs')) %>% select(.,pcr:nonIrrWaterConsumption)
# corAll <- cor(allvars)
# 
# png(filename="../RF/viz/corrplot_qMeteoStatevars.png", units="in", width=10, height=10, res=300)
# corrplot(corAll, method='square')
# dev.off()
# 
# ### catchment attributes 
# bigOne_2 <- vroom('../data/bigTable_allpredictors.csv', show_col_type=FALSE)
# 
# allvars_2 <- bigOne_2 %>% select(., airEntry1:tanSlope)
# corAll_2 <- cor(allvars_2)
# 
# png(filename="../RF/viz/corrplot_catchAttr.png", units="in", width=10, height=10, res=600)
# corrplot(corAll_2, method='square')
# dev.off()
