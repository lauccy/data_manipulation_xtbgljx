## gtsummary包，完美的基线特征统计描述R包
## https://mp.weixin.qq.com/s/obHNLM1BEZXI62ZcOGbrxQ
## UTF-8 coded

## gtsummary包，这个R包的主要作用是汇总数据、回归建模，
## 然后将统计的结果以一种可自定义的、优美的格式输出出来，简化数据科学流程，极大提高数据统计效率。


## 安装并加载包
pacman::p_load(gtsummary)

## 加载案例数据
data(cancer, package="survival") ## load cancer data from "survival" package
## 数据信息
# id # 患者编号
# study # 所有患者都是1
# rx # 表示治疗方式，有三种：观察、Levamisole、Levamisole + 5-FU
# sex # 性别，男性为1，女性为0
# age # 年龄
# obstruct # 肿瘤是否阻塞结肠，1 为有，0 为无
# perfor # 结肠是否穿孔，1 为有，0 为无
# adhere # 肿瘤是否粘附邻近器官，1 为有，0 为无
# nodes # 检出淋巴结的数目
# status # 生存状态，1 为发生感兴趣终点事件，0 为删失
# differ # 肿瘤的分化程度(1=well, 2=moderate, 3=poor)
# extent # 局部转移程度（1=submucosa, 2=muscle, 3=serosa, 4=contiguous structures）
# surg # 从手术到登记注册的时间(0=short, 1=long)
# node4 # 超过4 个阳性淋巴结
# time # 直至发生感兴趣终点事件或删失的时间
# etype # 事件类型: 1= 复发,2= 死亡

## 查看数据类型。
str(colon) # 有些数字型变量其实是分类变量，需要先转换数据类型。

# 转换后构建新的数据集。
pacman::p_load(tidyverse)

mycolon <- colon %>% # 创建新数据集新变量
  transmute(time,
            status,
            Age = age,
            Sex = factor(sex, levels = c(0, 1),
                         labels = c("Female", "Male")),
            Obstruct = factor(colon$obstruct),
            Differ = factor(colon$differ))

str(mycolon) # 查看数据集结构, 数据集中保留6个变量，连续变量、分类变量都有。

## 下面来看下gtsummary包是怎么使用的

# 简单统计描述: 使用tbl_summary()汇总信息, 直接将数据集名称放在函数中即可输出整个数据集的统计描述结果。
mycolon %>% tbl_summary() # 得到常见的基本信息表

# 添加分组变量, 可以使用by参数来指定分组变量，使用add_p()来输出统计P值。
## 在这个mycolon数据集中，我们将分组变量设置为status，比较存活组和死亡组的统计差异，并输出P值。输出两组的统计描述以及比较的P值以及计算P值的方法。

mycolon %>% tbl_summary(by = status) %>% add_p()


###
## 自定义参数调整输出结果:调整tbl_summary()函数中的参数来调整表格的输出信息格式
## 添加digits参数来调整输出小数位数

mycolon %>% 
  tbl_summary(by = status,
              digits = list(Age ~ 2)) %>% # 设置年龄的小数位数
  add_p()

# 使用all_continuous()参数设置所有连续变量的小数位数，比如这里面年龄和生存时间都是连续变量。
mycolon %>% 
  tbl_summary(by = status,
              digits = list(all_continuous() ~ 2)) %>% 
  add_p()


##########
## 调整输出的变量名称: 使用label参数调整数据集中变量的名称
mycolon %>% 
  tbl_summary(by = status,
              label = list(Age ~ "Patient Age", # 修改年龄的名称。
                           time ~ "Time"),      # 修改生存时间的名称。
              digits = list(all_continuous() ~ 2)) %>% 
  add_p()


##########
## 指定统计描述结果输出方式: 连续变量常用均数±标准差或者中位数+四分位数来表示。 ## 使用statistic参数指定变量的统计输出格式，比如年龄，表格使用的中位数+四分位数，我想指定均数±标准差表示。

mycolon %>% 
  tbl_summary(by = status,
              label = list(Age ~ "Patient Age",
                           time ~ "Time"),
              statistic = list(Age ~ "{mean} ({sd})"),
              digits = list(all_continuous() ~ 2)) %>% 
  add_p()


## 将list里的Age替换成all_continuous()即可指定所有的连续变量使用均数±标准差表示。
mycolon %>% 
  tbl_summary(by = status,
              label = list(Age ~ "Patient Age",
                           time ~ "Time"),
              statistic = list(all_continuous() ~ "{mean} ({sd})"),
              digits = list(all_continuous() ~ 2)) %>% 
  add_p()


##############
## 添加总队列描述结果：使用add_overall()函数
mycolon %>% 
  tbl_summary(by = status,
              label = list(Age ~ "Patient Age",
                           time ~ "Time"),
              statistic = list(all_continuous() ~ "{mean} ({sd})"),
              digits = list(all_continuous() ~ 2)) %>% 
  add_p() %>% 
  add_overall()


###############
## 变量名称后添加统计标签：使用add_stat_label()参数
mycolon %>% 
  tbl_summary(by = status,
              label = list(Age ~ "Patient Age",
                           time ~ "Time"),
              statistic = list(all_continuous() ~ "{mean} ({sd})"),
              digits = list(all_continuous() ~ 2)) %>% 
  add_p() %>% 
  add_overall() %>% 
  add_stat_label()


########## add_stat_label()函数的其他细化参数还有很多，可以自行查阅帮助文件，这个R包是很强大的一个R包，汇总数据相当于输出基线特征表，包中还有其他函数可以用于统计建模结果的输出，后续简单介绍用法。



