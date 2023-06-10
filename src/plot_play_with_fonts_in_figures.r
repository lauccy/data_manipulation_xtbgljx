
# Change Font of Plot in R (3 Examples)
# https://statisticsglobe.com/change-font-of-plot-in-r

# The extrafont package makes it easier to use fonts other than the basic PostScript fonts that R uses.
# https://cran.r-project.org/web/packages/extrafont/README.html

# Specifying fonts
# https://cran.r-project.org/web/packages/svglite/vignettes/fonts.html



# Using different fonts with ggplot2
# https://www.r-bloggers.com/2021/07/using-different-fonts-with-ggplot2/

# What is the default font for ggplot2
# https://stackoverflow.com/questions/34610165/what-is-the-default-font-for-ggplot2
### use ggplot2::theme_get()$text to check current setting
ggplot2::theme_get()




# Using Fonts with ggplot2 in Windows
# https://psrc.github.io/intro-ggplot2/content/using_fonts.html

pacman::p_load(extrafont)
pacman::p_load(ghostscript)
pacman::p_load(remotes)
remotes::install_version("Rttf2pt1", version = "1.3.8") #
font_import() #将windows系统中安装的所有字体倒入，花很长时间
# font_import("D:\\fonts") #如果只想倒入某几个字体可以提前把需要的字体放到指定的文件夹中导入
loadfonts("win")
fonts()
# windowsFonts()

library(ggplot2)
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point() +
  ggtitle("Fuel Efficiency of 32 Cars") +
  xlab("Weight (x1000 lb)") + ylab("Miles per Gallon") +
  theme(text=element_text(size=16,  family="Arial Black"))

