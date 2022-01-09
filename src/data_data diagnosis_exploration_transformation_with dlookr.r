
# 数据诊断
# 刘景欣 20220109 22:50
# modified from https://mp.weixin.qq.com/s/2nxaVmdyQFKGPTfsUPWLmg 一行代码“诊断”你的数据！
sessionInfo()
# R version 4.1.2 (2021-11-01)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 16299)

# dlookr: Tools for Data Diagnosis, Exploration, Transformation


#### 拿到数据后的第一步并不是着急的进行统计、作图， 而是了解数据的基本状况！ 
## 今天推荐一个非常实用的函数，用于解决这个问题。 

# After you have acquired the data, you should do the following:
#   
# Diagnose data quality.
# If there is a problem with data quality,
# The data must be corrected or re-acquired.
# Explore data to understand the data and find scenarios for performing the analysis.
# Derive new variables or perform variable transformations.
# The dlookr package makes these steps fast and easy:
#   
# Performs a data diagnosis or automatically generates a data diagnosis report.
# Discover data in a variety of ways, and automatically generate EDA(exploratory data analysis) report.
# Impute missing values and outliers, resolve skewed data, and binaries continuous variables into categorical variables. And generates an automated report to support it.
# dlookr increases synergy with dplyr. Particularly in data exploration and data wrangle, it increases the efficiency of the tidyverse package group.

## 安装并加载R包
# install.packages("dlookr")
# install.packages("palmerpenguins") # 提供本文使用到的数据集：“penguins”。
# 
# library(dlookr)
# library(palmerpenguins)

#可以用下面的代码一次性解决安装（如果没有的话）和加载
pacman::p_load(dlookr, palmerpenguins, tidyverse)

####################################
# Data quality diagnosis
## https://choonghyunryu.github.io/dlookr_vignette/diagonosis.html
overview(penguins)
overview(penguins) %>% plot()
diagnose(penguins)
# A tibble: 8 x 6
# variables           types   missing_count missing_percent unique_count unique_rate
# <chr>               <chr>           <int>           <dbl>        <int>       <dbl>
# 1 species           factor              0           0                3     0.00872
# 2 island            factor              0           0                3     0.00872
# 3 bill_length_mm    numeric             2           0.581          165     0.480  
# 4 bill_depth_mm     numeric             2           0.581           81     0.235  
# 5 flipper_length_mm integer             2           0.581           56     0.163  
# 6 body_mass_g       integer             2           0.581           95     0.276  
# 7 sex               factor             11           3.20             3     0.00872
# 8 year              integer             0           0                3     0.00872

# 返回的信息共包含8行 x 6列。每行为一个变量；每列为一项信息，含义分别为： 
# variables: 具体的变量名，共8个变量。
# types: 变量类型，比如factor，numeric和interger。
# missing_count: 缺失值的个数。
# missing_percent: 缺失值个数在总行数(此数据集一共有344行)中所占的比例。
# unique_count：即“独一无二的值”的个数，以第一个变量species为例，它是一个分类变量(factor)，共含有三个组别，因此它的unique_count就等于3。其他变量也是同一个道理。
# unique_rate: 指代unique_count在总行数中所占的比例。

diagnose_outlier(penguins)

plot_outlier(penguins)


####################################
# Exploratory Data Analysis
## https://choonghyunryu.github.io/dlookr_vignette/EDA.html



####################################
# Data Transformation
## https://choonghyunryu.github.io/dlookr_vignette/transformation.html