# library
library(tidyverse)
library(ggpubr)
library(patchwork)
library(viridis)
library(ggridges)
library(lubridate)
library(grid)


# date was applied by jingxin liu, received at 20211118

###############################################
###################### 气象数据
### temperature
# import data, check etc.
temp_daily <- read_csv("data/temp_2010-2018_daily.csv")

glimpse(temp_daily)
str(temp_daily)
head(temp_daily)
summary(temp_daily) # there are 6 NAs in "max_airT"
# temp_daily$month <- as.factor(temp_daily$month)

temp_daily %>% 
  select(month, year, day, mean_airT, max_airT, min_airT) %>% 
  group_by(month) %>%  
  summarise(mean_mean_airT = mean(mean_airT, na.rm = T),
            sd_mean_airT = sd(mean_airT, na.rm = T),
            mean_max_airT = mean(max_airT, na.rm = T),
            sd_max_airT = sd(max_airT, na.rm = T),
            mean_min_airT = min(min_airT, na.rm = T),
            sd_min_airT = sd(min_airT, na.rm = T)) -> mean_sd_airT

# write.csv(mean_sd_airT, "results/cleaned_data/monthly_tempature_2010-2018.csv")


# mean_sd_airT %>% select(month, mean_max_airT, mean_min_airT) %>% 
#   pivot_longer(cols = c(2,3), names_to = "cate", values_to = "mean_airT") -> mean_airT
# 
# mean_sd_airT %>% select(month, sd_max_airT, sd_min_airT) %>% 
#   pivot_longer(cols = c(2,3), names_to = "cate", values_to = "sd_airT") -> sd_airT

# ?mean
# mean_sd_airT %>% mutate(month_day = paste(month, day, sep = "_")) -> mean_sd_airT

#### import common settings for features of all subplots
source("src/plot_define_common_settings.r")

## plot
plot_temp_ljx <- ggplot(data = mean_sd_airT) +
  # add mean monthly maximu temperature
  geom_errorbar(aes(x = month, ymin=mean_max_airT-sd_max_airT,
                    ymax=mean_max_airT+sd_max_airT),color = bar_point_erreo_color, width = 0.1)+
  geom_line(aes(y=mean_max_airT, x = month), color = bar_point_erreo_color)+
  geom_point(aes(y=mean_max_airT, x = month),color = bar_point_erreo_color, shape = 15, size = 2)+
  # add mean monthly mean temperature
  geom_errorbar(aes(x = month, ymin=mean_mean_airT-sd_mean_airT,
                    ymax=mean_mean_airT+sd_mean_airT),color = bar_point_erreo_color, width = 0.1)+
  geom_line(aes(y=mean_mean_airT, x = month), color = bar_point_erreo_color)+
  geom_point(aes(y = mean_mean_airT, x = month),color = bar_point_erreo_color, shape = 16, size = 2)+
  # add mean monthly minmum temperature
  geom_errorbar(aes(x = month, ymin=mean_min_airT-sd_min_airT,
                    ymax=mean_min_airT+sd_min_airT),color = bar_point_erreo_color, width = 0.1)+
  geom_line(aes(y=mean_min_airT, x = month), color = bar_point_erreo_color)+
  geom_point(aes(y = mean_min_airT, x = month),color = bar_point_erreo_color, shape = 17, size = 2)+
  ylab("Monthly air temperature (°C)") + # (°C)
  xlab("")+
  scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10,11,12),
                     labels = c("Jan.","Feb.","Mar.","Apr.","May.",
                                "Jun.","Jul.","Aug.","Sep.","Oct.","Nov.","Dec."))+
  theme_classic()+
  theme(axis.title.x = element_text(hjust = 0.5), #将X轴标题居中展示
        axis.title.y = element_text(hjust = 0.5)) + #将y轴标题居中展示
  theme_custom
# ?element_text
# ?geom_line
# plot_temp_new
plot_temp_ljx

### add legend
grob <- grobTree(textGrob(c("Maximum", "Mean","Minimum"), 
                          x=c(0.35,0.58,0.75),
                          y=c(0.1,0.1,0.1),hjust=0,
                          gp = gpar(col=rep(bar_point_erreo_color, 3), fontsize=8)),
                 pointsGrob(x=c(0.33,0.56,0.73), 
                            y=c(0.1,0.1,0.1), 
                            pch = c(15,16,17),
                            size = unit(0.6,"char"), 
                            gp = gpar(col=rep(bar_point_erreo_color, 3))))
# ?grobTree
# ?textGrob
# range(develop$Weight)
plot_temp_ljx  + annotation_custom(grob) -> plot_temp_ljx

# plot_temp_ljx <- ggplot() +
#   geom_errorbar(data = sd_airT, aes(x = month, ymin=mean_max_airT-sd_max_airT, 
#                     ymax=mean_max_airT+sd_max_airT), width = 0.1)+
#   geom_point(aes(y=mean_max_airT, x = month),color="black", shape = 16, size = 2)+
#   geom_line(aes(y=mean_max_airT, x = month), color = bar_point_erreo_color)+
#   geom_errorbar(aes(x = month, ymin=mean_min_airT-sd_min_airT, 
#                     ymax=mean_min_airT+sd_min_airT), width = 0.1)+
#   geom_point(aes(y = mean_min_airT, x = month),color="black", shape = 21, size = 2)+
#   geom_line(aes(y=mean_min_airT, x = month), color = bar_point_erreo_color)+
#   ylab("Mean air temperature (°C)") + # (°C)
#   xlab("")+
#   scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10,11,12),
#                      labels = c("Jan.","Feb.","Mar.","Apr.","May.",
#                                 "Jun.","Jul.","Aug.","Sep.","Oct.","Nov.","Dec."))+
#   theme_classic()+
#   theme(axis.title.x = element_text(hjust = 0.5), #将X轴标题居中展示
#         axis.title.y = element_text(hjust = 0.5)) + #将y轴标题居中展示
#   theme_custom
# # ?element_text
# # ?geom_line
# # plot_temp_new
plot_temp_ljx



##################
## 如何将一个宽数据中分组转换成长数据（比如此例中 平均温度mean有3列，同时对应有3列sd，如何将3列mean和sd分别转成长格式，同时保留在一个数据表当中）

### 方案1：将3列数据分别转换，然后再组合

## 转换 mean
mean_sd_airT %>% select(c(1,2,4,6)) %>%
  gather(key = "means",value ="meanT",-1) -> meanT_long

## 作图
meanT_long %>% ggplot() +
  geom_line(aes(y=meanT, x = month, group = means, color = means))+
  geom_point(aes(y=meanT, x = month, group = means, color = means))+
  scale_color_manual(name="",values=c("Red","black","green"),label=c("Max T", "Average T","Min T"))

## 转换 sd 
mean_sd_airT %>% select(c(1,3,5,7)) %>%
  gather(key = "sds",value ="sdT",-1) -> sdT_long

## 作图
sdT_long %>% ggplot() +
  geom_errorbar(aes(x = month, ymin=meanT_long$meanT-sdT,
                    ymax=meanT_long$meanT+sdT, color = sds), width = 0.1)

### combine
meanT_sdT_long <- cbind(meanT_long, sdT_long[,2:3])

## 作图
meanT_sdT_long %>% ggplot() +
  geom_line(aes(y=meanT, x = month, group = means, color = means))+
  geom_point(aes(y=meanT, x = month, group = means, color = means))+
  scale_color_manual(name="",values=c("Red","black","green"),label=c("Max T", "Average T","Min T"))+
  geom_errorbar(aes(x = month, ymin=meanT-sdT,
                    ymax=meanT+sdT, color = means), width = 0.1)


### 方案2：将3列mean各自对应的sd列合并成一列，得到3列mean_sd, 然后宽转长，再讲mean_sd分成两列

mean_sd_airT %>% mutate (mean_airT = paste(mean_mean_airT, sd_mean_airT, sep = "/"),
                         max_airT = paste( mean_max_airT,  sd_max_airT, sep = "/"),
                         min_airT = paste( mean_min_airT,  sd_min_airT, sep = "/")) %>% 
  select(c(1,8:10)) %>% 
  gather(key = "type",value ="Temp",-1) %>% 
  separate(3, sep = "/", into = c("mean","sd")) -> mean_sd_airT_long

mean_sd_airT_long$month <- as.integer(mean_sd_airT_long$month)
mean_sd_airT_long$type <- as.factor(mean_sd_airT_long$type)  
mean_sd_airT_long$mean <- as.numeric(mean_sd_airT_long$mean)
mean_sd_airT_long$sd <- as.numeric(mean_sd_airT_long$sd)

# 作图
mean_sd_airT_long %>% 
  ggplot() +
  # add mean monthly maximu temperature
  geom_line(aes(y=mean, x = month, group = type, color = type))+
  geom_point(aes(y=mean, x = month, group = type, color = type))+
  geom_errorbar(aes(x = month, ymin=mean-sd,
                    ymax=mean+sd, color = type), width = 0.1)+
  scale_color_manual(name="",values=c("Red","black","green"),label=c("Max T", "Average T","Min T"))+
  ylab("Monthly air temperature (°C)") + # (°C)
  xlab("")+
  scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10,11,12),
                     labels = c("Jan.","Feb.","Mar.","Apr.","May.",
                                "Jun.","Jul.","Aug.","Sep.","Oct.","Nov.","Dec."))+
  theme_classic()+
  theme(legend.position = c(0.5, 0.1),
        legend.direction = "horizontal")
  
# theme_custom +
#   theme(legend.position = c(0.5,0.1),
#         legend.direction = "horizontal",
# 不知道为啥用过 theme_custom去掉legend后再用 theme()添加legend，legend周围会有一圈边线，虽然可以用过增加下面一行代码使黑框不显示
        # legend.background = element_rect(color = "white", linetype = "solid", size = 1))


