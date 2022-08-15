KGE_map <- function(rf.eval, breaks, labels, gof_col_select, title, legend_yn,
                    KGE_comp, KGE_comp_corrected){
  
  eval_allG <- rf.eval %>% 
    inner_join(.,stations_xy, by='grdc_no') %>%
    gather(.,'gof','value', as.name(KGE_comp):as.name(KGE_comp_corrected)) %>%
    mutate(gof_col=ifelse(grepl('corrected', gof), 'pcr_RFcorrected',
                          'pcr_uncalibrated')) %>%
     filter(.,gof_col==gof_col_select) %>% na.omit()
  
  KGE_map <- ggplot() +
    geom_map(
      data = wg, map = wg,
      aes(long, lat, map_id = region),
      color = "white", fill= "black"
    ) +
    theme_map()+
    xlim(-180,180)+
    ylim(-55,75)+
    geom_point(eval_allG, mapping = aes(x = lon, y = lat,
               fill=cut(value, breaks=breaks, labels=labels)),
               color='black', pch=21, size = 2 , show.legend = legend_yn) +
    scale_fill_brewer(palette='RdYlBu',name = legendName,
                       guide = guide_legend(reverse=TRUE))+
    labs(title=title) +
    xlab('longitude')+
    ylab('latitude') +
    theme(plot.title = element_text(hjust = 0.5, size=14),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          axis.ticks = element_blank(),
          panel.grid = element_blank())
    
  
  return(KGE_map)
}