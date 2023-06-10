pacman::p_load(ez)

# ezPrecis: This function provides a structure summary of a given data frame.

# Examples

#Read in the ANT2 data (see ?ANT2).
data(ANT2)
head(ANT2)

#Show a summary of the ANT2 data.
ezPrecis(ANT2)


# vtable package serves the purpose of outputting automatic variable documentation that can be easily viewed while continuing to work with data.
# https://cran.r-project.org/web/packages/vtable/vignettes/sumtable.html
pacman::p_load(vtable)
st(iris)
# 非常好的汇总原始数据生成表格的r包，看上面那个链接好好学习



# rstatix:: Pipe-Friendly Framework for Basic Statistical Tests
pacman::p_load(rstatix)

data("ToothGrowth")
ToothGrowth %>% get_summary_stats(len)

# Summary statistics of grouped data
# Show only common summary
ToothGrowth %>%
  group_by(dose, supp) %>%
  get_summary_stats(len, type = "common")

# Robust summary statistics
ToothGrowth %>% get_summary_stats(len, type = "robust")

# Five number summary statistics
ToothGrowth %>% get_summary_stats(len, type = "five_number")

# Compute only mean and sd
ToothGrowth %>% get_summary_stats(len, type = "mean_sd")

# Compute full summary statistics but show only mean, sd, median, iqr
ToothGrowth %>%
  get_summary_stats(len, show = c("mean", "sd", "median", "iqr"))
