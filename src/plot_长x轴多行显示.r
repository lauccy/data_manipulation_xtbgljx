## Liujingxin
## learning notes from https://mp.weixin.qq.com/s/WUoOrUL9P4dyafeh1w_Mkw?
## 20220318

library(tidyverse)
library(ggbreak)


### Example code from the package
library(ggplot2)
library(ggbreak)
p <- ggplot(economics, aes(x=date, y = unemploy, colour = uempmed)) +
  geom_line()
p + scale_wrap(n=4)


## play it with myown data
temp <- read_csv("data/temp_2005-2018_monthly.csv")

head(temp)
table(temp$Year)

temp %>% mutate(moths = c(1:nrow(temp))) -> temp

library(ggplot2)
library(ggbreak)
p <- ggplot(temp, aes(x=moths, y = AverTemp)) +
  geom_bar(stat = "identity")
  
p + scale_wrap(n=14)


p <- ggplot(mpg, aes(class, hwy))
p <- p + geom_violin()
p 

p1 <- p + scale_wrap(2)
p1

## 改变分类的顺序
set.seed(123)
lv = sample(unique(mpg$class), 7)
lv

p1 + aes(x=factor(class, levels=lv))
