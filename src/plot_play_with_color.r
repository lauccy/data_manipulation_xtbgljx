# R语言绘图颜色选择，你想知道的都在这里！
# https://mp.weixin.qq.com/s?__biz=Mzg2OTcxMzUwNQ==&mid=2247484161&idx=3&sn=e568e1d648373832c479d04345eb5bf4&chksm=ce99900ff9ee1919c333c04df38830f2f02a1de60766e3b41b443ad65da2e6c15af08214df83&scene=132#wechat_redirect


######################################
########## 1、图片颜色捕捉

# 首先给大家分享一个很有趣的R包：RImagePalette，能直接捕获图片里面的颜色，非常有趣。

# 这里举两个例子：

#加载R包，未安装先用install.packages("RImagePalette")安装
pacman::p_load(RImagePalette,jpeg)
#导入图片：
p1 <- png::readPNG('data/银耳相思鸟.png') #先安装一个jpeg包
display_image(p1) #可直接在Rstudio展示图片


#捕获颜色：
color1<-image_palette(p1,n=40) 
#这里可以多设置一点数量，因为有很多背景色被捕获，如果没有背景色，
#就可以直接设置自己需要的颜色数量，然后绘图时直接用col=color1就好了。
color1  #列出颜色名（十六进制颜色编码）
scales::show_col(color1)  #直接以图方式展示颜色


#示例绘图以展示这些颜色：
barplot(rnorm(6,mean =10,sd=1),
        col=c('#F3D32C','#AAA26F','#DB520F','#B4470D','#B6A650','#32240C'))

###是不是很有趣呢，赶紧用自己喜欢的图片去提取颜色绘图吧，嘿嘿！


###### 2、RColorBrewer包
# 很常用的绘图配色包，有很多组颜色可供选择。

#加载包：
pacman::p_load(RColorBrewer)
#展示该包内推荐的颜色组合，有连续型和离散型。
display.brewer.all()
#示例绘图使用这些颜色组合：
barplot(rnorm(6,mean =10,sd=1),col=brewer.pal(6,"Set1"))

barplot(rnorm(6,mean =10,sd=1),col=brewer.pal(5,"Greens"))



############## 3、paletteer包
# 直接在控制台显示出颜色及编码，还能无缝对接ggplot2

#加载包：
pacman::p_load(paletteer,RColorBrewer)

#主要有三种颜色形式的函数：
#paletteer_c：连续型配色
#paletteer_d：离散型配色
#paletteer_dynamic，即动态配色，就是说可以把一组颜色任意切分成n个颜色
#使用时，直接输入函数，按tab键，选择（包名::配色名）,后面再加需要显示的颜色个数
paletteer_c(`"ggthemes::Blue-Green Sequential"`,6)

paletteer_d(`"wesanderson::BottleRocket1"`)

paletteer_dynamic(`"cartography::blue.pal"`, 5)

#对接ggplo2等其他包：函数直接调用颜色
pacman::p_load(ggplot2)
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_paletteer_d("ggsci::nrc_npg") #这个函数调用paletteer包颜色


#与pheatmap包的热图对接：
pacman::p_load(pheatmap)
pheatmap::pheatmap(volcano,
                   color =paletteer_c("scico::berlin", n =100))


############# 4、Colorspace包
# 直接调出一个配色弹窗，手动调节选择颜色

pacman::p_load(colorspace)
#调出配色弹窗：
colorspace::choose_palette()


#在绘图区域显示多种配色方案：
hcl_palettes(plot =TRUE)

colors<-qualitative_hcl(4,palette ="Set3")
colors

## [1] "#FFB3B5" "#BBCF85" "#61D8D6" "#D4BBFC"
data("EuStockMarkets") #R自带数据

#调用颜色作图：
plot(EuStockMarkets,plot.type="single",col=colors,lwd=2.5)
legend("topleft",colnames(EuStockMarkets),col=colors,lwd =2.5)
图片

#当然还可以在ggplot2作图时调用颜色，大家可以自己去试试


################ 5、文献图片配色：ggsci包
# 有时候我们看到一些高分期刊里的图都有其自身的配色风格，也都挺好看的，怎么模仿使用呢？一个ggsci包帮我们解决这个问题。

pacman::p_load(ggsci)
p<-ggplot(iris,aes(Sepal.Length,Sepal.Width,color=Species))+
  geom_point(position ="jitter")+
  geom_smooth(se=F,span=0.8,cex=1.5)+
  theme_test(base_size =15)+
  theme(legend.position =c(0.85,0.9),
        legend.title =element_blank())
p+scale_color_nejm()  #新英格兰风格

p+scale_color_lancet() #柳叶刀风格

p+scale_color_aaas()  #AAAS风格

#此外还有很多配图风格,大家快写起代码试试自己喜欢哪种吧。
p+scale_color_jama()  #JAMA风格
p+scale_color_npg()  #Nature风格
p+scale_color_jco()
p+scale_color_ucscgb()
p+scale_color_d3()
p+scale_color_locuszoom()
p+scale_color_igv()
p+scale_color_startrek()
