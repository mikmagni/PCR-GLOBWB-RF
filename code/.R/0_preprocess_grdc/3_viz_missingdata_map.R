####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####

stationInfo <- read.csv('../../../data/stationLatLon.csv') %>%
  select(., grdc_no, lon, lat, miss) %>% 
  mutate(available=100-miss)

outputDir <- paste0('../../../RF/viz/')
dir.create(outputDir, showWarnings = F, recursive = T)

wg <- map_data("world")
stations_xy <- stationInfo %>% select(grdc_no, lat, lon)

myPalette <- colorRampPalette((brewer.pal(9, "RdYlBu")))
sc <- scale_fill_gradientn(colours = myPalette(100), limits=c(0,100), 
                           name='Available data (%)\n')

missing_map <- ggplot() +
  geom_map(
    data = wg, map = wg,
    aes(long, lat, map_id = region),
    color = "white", fill= "black"
  ) +
  theme_map()+
  xlim(-180,180)+
  ylim(-55,75)+
  geom_point(stationInfo, mapping = aes(x = lon, y = lat,  fill=available),
             color='black', pch=21, size = 2) +
  sc+
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size = 12),
        # legend.position="bottom",
        legend.position = c(0.5,-0.025), legend.direction = "horizontal",
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())
missing_map


ggsave(paste0(outputDir,'map_miss.png'), missing_map, height=7, width=14, units='in', dpi=600)

