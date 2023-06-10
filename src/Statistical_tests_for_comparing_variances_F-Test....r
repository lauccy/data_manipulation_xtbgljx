# Statistical tests for comparing variances
# Equal variances across samples is called "homogeneity of variances".

## Jingxin Liu's notes from
## http://sthda.com/english/wiki/f-test-compare-two-variances-in-r
## https://www.educba.com/f-test-formula/
## https://www.itl.nist.gov/div898/handbook/eda/section3/eda359.htm
## http://www.sthda.com/english/wiki/compare-multiple-sample-variances-in-r#statistical-tests-for-comparing-variances
## 20220310

###3 There are many solutions to test for the equality (homogeneity) of variance across groups, including:

 # F-test: Compare the variances of two samples. The data must be normally distributed.
 # Bartlett’s test: Compare the variances of k samples, where k can be more than two samples. The data must be normally distributed. The Levene test is an alternative to the Bartlett test that is less sensitive to departures from normality.
 # Levene’s test: Compare the variances of k samples, where k can be more than two samples. It’s an alternative to the Bartlett’s test that is less sensitive to departures from normality.
 # Fligner-Killeen test: a non-parametric test which is very robust against departures from normality.

###############
####  F-test: used to assess whether the variances of two populations (A and B) are equal. It’s adapted for normally distributed data.
# F-test is a statistical test which helps us in finding whether two population sets which have a normal distribution of their data points have the same standard deviation or variances. But the first and foremost thing to perform F-test is that the data sets should have a normal distribution. This is applied to F distribution under the null hypothesis. F-test is a very crucial part of the Analysis of Variance (ANOVA) and is calculated by taking ratios of two variances of two different data sets. As we know that variances give us the information about the dispersion of the data points. F-test is also used in various tests like regression analysis, the Chow test, etc.

# F-Test, as discussed above, helps us to check for the equality of the two population variances. So when we have two independent samples which are drawn from a normal population and we want to check whether or not they have the same variability, we use F-test. F-test also has great relevance in regression analysis and also for testing the significance of R2. So in a nutshell, F-Test is a very important tool in statistics if we want to compare the variation of 2 or more data sets. But one should keep all the assumptions in mind before performing this test.


# The F-test can be used to answer the following questions:
#   Do two samples come from populations with equal variances?
#   Does a new process, treatment, or test reduce the variability of the current process?


## How to do F-test in R
# Store the data in the variable my_data
my_data <- ToothGrowth # read the build-in R data set

# have a look at the data by displaying a random sample of 10 rows using the function sample_n()[in dplyr package]

library("dplyr")
sample_n(my_data, 10)

# Preleminary test to check F-test assumptions
# F-test is very sensitive to departure from the normal assumption. You need to check whether the data is normally distributed before using the F-test.

# Shapiro-Wilk test can be used to test whether the normal assumption holds. It’s also possible to use Q-Q plot (quantile-quantile plot) to graphically evaluate the normality of a variable. Q-Q plot draws the correlation between a given sample and the normal distribution.

# normality test and check
library(tidyverse)
library(ggpubr)
library(rstatix)
ToothGrowth %>%
  group_by(supp) %>%
  shapiro_test(len) ## group "OJ" not normal (p = 0.02), group "VC" normal (p = 0.43)

# qq-plot
library(ggpubr)
ggqqplot(ToothGrowth, x = "len",
         facet.by = "supp", 
         color = "supp", 
         palette = c("#0073C2FF", "#FC4E07"),
         ggtheme = theme_pubclean()) ## qq plot looks good for both groups


# If there is doubt about normality, the better choice is to use Levene’s test or Fligner-Killeen test, which are less sensitive to departure from normal assumption.

# Compute F-test
# F-test
res.ftest <- var.test(len ~ supp, data = my_data)
res.ftest
# Interpretation of the result
# The p-value of F-test is p = 0.2331 which is greater than the significance level 0.05. In conclusion, there is no significant difference between the two variances.

#######################
############# Bartlett’s test: used for testing homogeneity of variances in k samples, where k can be more than two. It’s adapted for normally distributed data.

# Bartlett’s test with one independent variable
ToothGrowth$dose <- as.factor(ToothGrowth$dose)
res <- bartlett.test(len ~ dose, data = ToothGrowth)
res

# Bartlett’s test with multiple independent variables: the interaction() function must be used to collapse multiple factors into a single variable containing all combinations of the factors.
bartlett.test(len ~ interaction(supp,dose), data=ToothGrowth)


###########################
## Levene’s test: an alternative to Bartlett’s test when the data is not normally distributed.
##### https://www.statology.org/levenes-test-r/
library(car)

# Levene's test with one independent variable
res.ltest <- leveneTest(len ~ supp, data = my_data)
res.ltest
# Interpretation of the result
# The p-value of F-test is p = 0.2752 which is greater than the significance level 0.05. In conclusion, there is no significant difference between the two variances.

# Levene's test with multiple independent variables
leveneTest(len ~ supp*dose, data = ToothGrowth)


###########################
# Fligner-Killeen test: the most robust against departures from normality.

# with one independent variable
fligner.test(len ~ supp, data = my_data)

# with multiple independent variables
fligner.test(len ~ interaction(supp,dose), data = ToothGrowth)

############
#### Visualizing the Differences in Variances
# we can create boxplots that display the distribution of len for each of the two groups so that we can gain a visual understanding of why Levene’s test accept the null hypothesis of equal variances.
boxplot(len ~ supp,
        data = my_data)
# We can see that the variances (the “length” of the boxplot) are very similar between two groups

# Thus, it makes sense that Levene’s test lead to the conclusion that the variances are equal among the two groups.

