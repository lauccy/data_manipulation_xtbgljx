library(tidyverse)

#### define common features of all subplots
# define font
# devtools::install_github("GuangchuangYu/yyplot")
# library(yyplot)
## check https://guangchuangyu.github.io/cn/2017/09/ggplot2-set-font/ for more infor about yyplot

# https://www.jianshu.com/p/7c6060f01029 ggplot2绘图之一键修改全局字体
# windowsFonts(A = windowsFont("Arial"))

# define color for barplot, points and errorbars
bar_point_erreo_color <- "grey51"

?color

# define geo_bar
geom_bar_setting <- geom_bar(stat="identity", fill=alpha(bar_point_erreo_color, 0.9), width = 0.6)
# ?geom_bar
# ?geom_bar
# ?geom_bar
# define x-axis ticks and lable orders
x_ticks_labes <- scale_x_discrete(limits = c("Jan","Feb","Mar","Apr","May","Jun",
                                             "Jul", "Aug","Sep","Oct","Nov","Dec"),
                                  labels = c("Jan.","Feb.","Mar.","Apr.","May.","Jun.",
                                             "Jul.", "Aug.","Sep.","Oct.","Nov.","Dec."))

# ?scale_x_discrete
# define text will be added to bar plot, not used later
# bar_txt <- geom_text(aes(label = Num, family = "A", size = 5), vjust = -0.5)

# define theme
theme_custom <- theme(legend.position = "None",
                      # https://blog.csdn.net/weixin_43948357/article/details/103043518 关于字体
                      text = element_text(size = 10, family = "sans"), # , family = "A" 稍后在研究字体
                      line = element_line (colour = 'black', size = 0.5),
                      axis.text.y = element_text(angle = 90, hjust = 0.5),
                      axis.text.y.right = element_text(angle = 270, hjust = 0.5, vjust = 1),
                      legend.background = element_rect(fill = "transparent"),
                      legend.box.background = element_rect(fill = "transparent"),
                      panel.background = element_rect(fill = "transparent"),
                      panel.grid.major = element_blank(),
                      panel.grid.minor = element_blank(),
                      plot.background = element_rect(fill = "transparent", color = NA))


