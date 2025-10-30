
######## https://mp.weixin.qq.com/s/yQ08zIS2EL5GA5EeQIQ3iw
##### R语言aplot魔法：普通拼图已经Out了，自动对齐坐标轴位置才是真需求
# 号外，Y叔的aplot包正式发表于The Innovation期刊了。引用格式：Xu S., Wang Q., Wen S., et al. (2025). aplot: Simplifying the creation of complex graphs to visualize associations across diverse data types. The Innovation 6:100958.

#大家熟知的cowplot和patchwork包，只把图拼在一起，无法对齐坐标轴位置！
# Y叔的aplot包，会自动对每个小图的内容进行重新排列，使得图与图之间信息保持一一对应，这才是真需求。

# 先在RStudio中安装aplot包：install.packages("aplot")
### 下述函数包有则无需安装，没有就安装一下，后续案例会用到#安装patchwork包、ggplot2包、tidyr包 install.packages("patchwork")install.packages(c("ggplot2","tidyr","readr","dplyr"))
#安装ggtree包if (!requireNamespace("BiocManager", quietly = TRUE))    install.packages("BiocManager")BiocManager::install("ggtree")


#################################
######################
# 一、aplot效果展示
library(ggplot2)
library(aplot)

p <- ggplot(mtcars, aes(mpg, disp)) + 
  geom_point()

p2 <- ggplot(mtcars, aes(mpg)) +
  geom_density(fill='steelblue', alpha=.5) +
  ggtree::theme_dendrogram()

p3 <- ggplot(mtcars, aes(x=1, y=disp)) +
  geom_boxplot(fill='firebrick', alpha=.5) +
  theme_void()

ap <- p %>%
  insert_top(p2, height=.3) %>%
  insert_right(p3, width=.1)
## you can use `ggsave(filename="aplot.png", plot=ap)` to export the plot to image file
print(ap) # or just type ap will print the figure


# 注：aplot包的核心函数是insert_left(), insert_right(), insert_top(), 和 insert_bottom()。




#################################
######################
# 二、不同拼图包效果对比
# 2.1 patchwork包拼图效果（坐标轴位置没有对齐）
library(ggtree)

set.seed(2020-03-27)

x <- rtree(10)

d <- data.frame(taxa=x$tip.label, value = abs(rnorm(10)))

p <- ggtree(x) + 
  geom_tiplab(align = TRUE) +  #### Error in `geom_segment2()`:  ! Problem while converting geom to grob.i Error occurred in the 3rd layer.Caused by error in `is.waive()`:  ! 没有"is.waive"这个函数
  ###我怀疑是ggplot版本的问题，等aplot升级
  xlim(NA, 3)

p2 <- ggplot(d, aes(value, taxa)) + geom_col() +
  scale_x_continuous(expand=c(0,0))

library(patchwork)
p| p2

# 比如左图坐标轴位置18对着右图19，左图t7对着右图t10，这就是所说的：坐标轴位置没有对齐。如果子图多的话，要手动一一对齐，难度还是很大的！下面一起来看aplot包的自动对齐效果。


# 2.2 aplot包拼图效果（坐标轴位置一一对齐）p2 %>% insert_left(p)

p2 %>% insert_left(p)





#################################
######################
##### 三、aplot包高级拼图
library(tidyr)
library(ggplot2)
library(ggtree)
##创建数据集 
set.seed(2019-11-07)
d <- matrix(rnorm(25), ncol=5)
rownames(d) <- paste0('g', 1:5)
colnames(d) <- paste0('t', 1:5)
hc <- hclust(dist(d))
hcc <- hclust(dist(t(d)))

#绘制子图phr和phc (树状图ggtree)
phr <- ggtree(hc)
phc <- ggtree(hcc) + layout_dendrogram()

d <- data.frame(d)
d$gene <- rownames(d)
dd <- gather(d, 1:5, key="condition", value='expr')

##绘制主图p (热图geom_tile)
p <- ggplot(dd, aes(condition,gene, fill=expr)) + geom_tile() +
  scale_fill_viridis_c() +
  scale_y_discrete(position="right") +
  theme_minimal() +
  xlab(NULL) + ylab(NULL)

#绘制子图g (箱状图geom_boxplot)
g <- ggplot(dplyr::filter(dd, gene != 'g2'), aes(gene, expr, fill=gene)) +
  geom_boxplot() + coord_flip() +
  scale_fill_brewer(palette = 'Set1') +
  theme_minimal() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank()) +
  xlab(NULL) + ylab(NULL)

#创建数据集2
ca <- data.frame(condition = paste0('t', 1:5),
                 A1 = rep(LETTERS[1:2], times=c(3, 2)),
                 A2 = rep(letters[3:5], times=c(1, 3, 1)))
cad <- gather(ca, A1, A2, key='anno', value='type')

#绘制子图pc (热图geom_tile)
pc <- ggplot(cad, aes(condition, y=anno, fill=type)) + geom_tile() +
  scale_y_discrete(position="right") +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
  xlab(NULL) + ylab(NULL)

#创建数据集3
set.seed(123)
dp <- data.frame(gene=factor(rep(paste0('g', 1:5), 2)),
                 pathway = sample(paste0('pathway', 1:5), 10, replace = TRUE))

#绘制子图pp (散点图geom_point)
pp <- ggplot(dp, aes(pathway, gene)) +
  geom_point(size=5, color='steelblue') +
  theme_minimal() +
  theme(axis.text.x=element_text(angle=90, hjust=0),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
  xlab(NULL) + ylab(NULL)

## aplot包拼图
p %>% insert_left(phr, width=.3) %>%
  insert_right(pp, width=.4) %>%
  insert_right(g, width=.4) %>%
  insert_top(pc, height=.1) %>%
  insert_top(phc, height=.2)


########






# R语言图片叠加与排版
# https://mp.weixin.qq.com/s?__biz=Mzg2OTcxMzUwNQ==&mid=2247484161&idx=4&sn=171ec6e4842ae210e4add9f6f1d53bee&chksm=ce99900ff9ee1919d173e9e232b125ae9ac07a5de9a934d892440ced64a709e2db5ba806bfc2&cur_album_id=2149638522784350214&scene=189#wechat_redirect

### 图片叠加
# 在R语言绘图时，我们常常发现想将绘出的多张图片进行叠加，比如将一图B叠加到图A上的一个空白区域，这样能使我们的图片以最小的区域可视化更多的内容。虽然这些后期同Ai、PS等软件也可以做，但我们的最高目标就是用R语言直接画出可以最终使用的好图！本文分享了4种方法，大家可以根据自己的实际需要选择合适的方法使用图片。

### 图片排版
# 除此之外，我们常常还需要将画出的多张图片进行排版，最后组成一个大Figure，所以本文后面我也会介绍一个patchwork包，可以很好的帮我们完成这个任务图片。


#########################
### 图片叠加
# https://zhuanlan.zhihu.com/p/439651004 
#########################
### 第1种图片叠加方法：用ggplot2包的函数将两个ggplot2图片叠加
#加载R包：
pacman::p_load(tidyverse,ggsignif)  #tidyverse包含有ggplot2包的重要R包集合

#读取数据并预处理：“文章作者没有分享数据，所以没法练习”
data<- read.csv("C:/Users/dk/Desktop/R/write/21.11/data1126.CSV",header = T)
data <- gather(data,key ='sample',value ='count')
#ggplot2绘图p1,p2，完整绘图代码见文末，数据和箱线图绘制详见11.27推文
# p1 <- .... 

# p2 <- .....

#将p2先用ggplotGrob()函数处理：
p3 <- ggplotGrob(p2)
#将处理后的p2用annotation_custom函数叠加到p1上指定位置：
p1 + annotation_custom(p3,xmin =8.1,xmax =17.2,ymin =-0.08,ymax =0.85)

#################
### 第2种图片叠加方法：cowplot包帮忙实现
#可省略用ggplot2自带函数的第二步（将p2转换成grob）
pacman::p_load(cowplot)
ggdraw(p1)+
  draw_plot(p2,x=0.275,y=-0.36,scale =0.38,width =1,height =1.7)

#################
### 第3种图片叠加方法：ade4包，将基础绘图函数的绘图叠加到ggplot2绘图上
pacman::p_load(ade4)
p1
add.scatter(barplot(1:10),posi="bottomright",ratio=0.35,
            bg.col =NULL,
            inset =c(-0.02,-0.02))  #基础绘图函数barplot绘图结果


##################
### 第4种图片叠加方法：grid包结合ggplotify包使用，基础绘图函数叠加
pacman::p_load(grid)  # grid包相当于用于创建一个画布，
pacman::p_load(ggplotify)  #ggplotify包的as.grob将图片转换成grob展示于画布上。

p5 <- as.grob(~barplot(1:10)) 
grid.newpage()
grid.draw(p1)  #先用grid.draw绘出p1
vp =viewport(x=.8, y=.35, width=.4, height=.5)  #设定叠加区域、大小
pushViewport(vp)  
grid.draw(p5)   
upViewport()

# ggplot2的绘图同样先用as.grob处理:
p6 <- as.grob(p2)
grid.newpage()  
grid.draw(p1)  
vp =viewport(x=.78, y=.5, width=.38, height=.65)  
pushViewport(vp)  
grid.draw(p6) 
upViewport()

# 突然发现ggplotify包还有一个as.ggplot函数()，可以将基础绘图函数的绘图转换成ggplot2形式：
p7 <- as.ggplot(~barplot(1:10))+
  annotate('text',x=0.5,y=0.6,label='Base plot',size=10,
           color ='firebrick', angle=45,family='serif') #还可以用ggplot2里的加文本函数annotate()

ggdraw(p1)+
  draw_plot(p7,x=0.35,y=-0.05,scale =0.5,width =0.85,height =0.85) #这里为什么少显示了一点点大家可以自己去尝试修改参数


#########################
### 图片排版：patchwork包
pacman::p_load(patchwork)
#先使用R内置数据mtcars分别画出4张图
pa <- ggplot(mtcars) +
  geom_point(aes(mpg, disp)) +ggtitle('Plot a')
pb <- ggplot(mtcars) +
  geom_boxplot(aes(gear, disp, group = gear)) +ggtitle('Plot b')
pc <- ggplot(mtcars) +
  geom_point(aes(hp, wt, colour = mpg)) +ggtitle('Plot c')
pd <- ggplot(mtcars) +
  geom_bar(aes(gear)) +facet_wrap(~cyl) +ggtitle('Plot d')

# 简单排版：
pa + pb # + 表示按行显示两个图

pa / pb # / 表示按列显示两个图

(pa + pb + pc) / pd

# 排版后加标题：
pa + pb + labs(title ="title at last") #给后面的图加标题
pa +labs(title ="title at previous") + pb #给前面的图加标题
pa +labs(title ="title at previous") + 
  pb + labs(title ="title at last") # 给两个图分别加标题


# 用plot_layout()函数排版：
pa + pb + pc + pd + plot_layout(nrow =3, byrow =FALSE)
pa + pb + pc + pd + plot_layout(nrow =3, byrow =T)

# 排版图片的命名：大家可以自行试试 = '1'，='I'是什么样的
pa + pb + pc +
  plot_annotation(tag_levels ='A')  #tag_levels = 'I','1'

# 通过plot_spacer()函数来添加空白区域进行排版：
pa + plot_spacer() + 
  pb + plot_spacer() + 
  pc + plot_layout(nrow =1, byrow =T)

# 调整各区域的高度和宽度：
pa + pb + pc + pd +
  plot_layout(widths =c(2, 1))

pa + pb + pc + pd +
  plot_layout(widths =c(2, 1), heights =c(1,3))

# 通过#表示空白，自定义更复杂布局：

layout <- "
##BBBBB
AACCDDD
##CCDDD
"
pa + pb + pc + pd +
  plot_layout(design = layout)

# 自定义图片位置：
wrap_plots(A = pa, B= pb, C= pc, D= pa,  design = layout)



#########################
### 图片排版：cowplot包也是一款非常优秀的图片排版包，这里不做介绍可以在微信上搜索学习
