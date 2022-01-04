# Data:2022-01-04
# Creater: Liu Jing-Xin
# Modified from https://mp.weixin.qq.com/s/YcQlq5Y7yQAnioNZm_wXLw
                # 用R语言画个动图祝大家新年快乐！


# 安装相关r包，先判断是否已经安装，如果否就安装
if (!require("pacman")) install.packages("pacman")
if (!require("gifski")) devtools::install_github("r-rust/gifski")
library(pacman)
p_load(tidyverse,stringr,gganimate,ggsci,RColorBrewer,gifski) #p_load命令会先判断要加载的包有没有安装，如果没有安装就帮忙安装，之后再加载

# 清空工作空间
rm(list = ls())

##
# 绘制happy new year 字样
dat_a <- data.frame(word=str_split("HappyNewYear2022","",simplify = T)[1,],
                    x=c(seq(0,1,length.out=5),seq(1.7,2.3,length.out=3),
                        seq(3,3.8,length.out=4),seq(4,4.8,length.out=4)),
                    y=c(rep(5,12),rep(3.5,4)),
                    type=rep(2,16))


dat_b <- data.frame(word=str_split("HappyNewYear2022","",simplify = T)[1,],
                    x=c(seq(0,1,length.out=5),seq(1.7,2.3,length.out=3),
                        seq(3,3.8,length.out=4),seq(4,4.8,length.out=4)),
                    y=c(rep(5,12),rep(3.5,4))-3,
                    type=rep(4,16))

dat_c <- data.frame(word=str_split("HappyNewYear2022","",simplify = T)[1,],
                    x=c(seq(0,1,length.out=5),seq(1.7,2.3,length.out=3),
                        seq(3,3.8,length.out=4),seq(4,4.8,length.out=4)),
                    y=c(rep(5,12),rep(3.5,4))+5,
                    type=rep(6,16))



# 定义生成随机数据框的函数
random <- function(x){
  dat <- data.frame(word=str_split("HappyNewYear2022","",simplify = T)[1,],
                    x=sample(seq(0,4.8,by=0.2),16),
                    y=sample(seq(0,10,by=0.5),16),
                    type=rep(x,16))
  return(dat)
}


# dat_b <- do.call(rbind,lapply(c(1,3),random))

# 合并数据框
dat <- rbind(random(1),dat_a,random(3),dat_b,random(5),dat_c)

# 定义颜色
colors <- heat.colors(30)

# 绘图
animation_to_save <- ggplot(dat)+
  geom_text(aes(x,y,label=word,color=word),size=10,fontface="italic")+
  xlim(0,4.8)+ ylim(0,10)+
  #scale_color_ucscgb()+
  #scale_color_lancet()+
  scale_color_manual(values = colors)+
  theme_bw()+
  theme(legend.position = "none")+
  theme(axis.title =element_blank(),
        axis.text=element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),)+
  transition_states(type, transition_length = rep(5,6), 
                    state_length = c(0,2,0,2,0,2))

# 查看效果
animate(animation_to_save, renderer = gifski_renderer())

# 保存
anim_save("results/happy-new-year.gif", animation = animation_to_save, renderer = gifski_renderer())



####################################
######## 再来展示下如何用gganimate动态可视化你的数据
####################################
p_load(gganimate,gapminder)

animation_to_save<- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')

anim_save("results/gapminder.gif", animation = animation_to_save, renderer = gifski_renderer())


