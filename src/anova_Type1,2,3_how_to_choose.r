## Jingxin Liu learning notes from
## https://ww2.coastal.edu/kingw/statistics/R-tutorials/unbalanced.html
## 20220309 night


## Three methods to calculate sums of squares: Type I, Type II, and Type III
## When sample sizes are balanced (equal in different treatment), three method give the same result
## When sample sizes are unbalanced, how should the total variability be partitioned among the the various main effects and interactions will be a problem.
## In any event, you should state in the written description of your analysis how the analysis was done, i.e., what type sums of squares were calculated!

#### in experimental research, the population is a fiction 在控制实验中，群体是不存在的。


#####################
### When to use type I
## Use type I if the design is a true experimental design, and the design is balanced, in this situation type II and III give the same result anyway.

### When to use type III
## Use Type III if the design is a true experimental design, and the design is mildly unbalanced
## in other words, Type III for mildly unbalanced experimental data, which the cell sizes are random and meaningless with respect to the treatments.

### When to use type II
## Use type II in the non-experimental case, and you must have something that resembles a traditional ANOVA, then Type II is the clear choice, but be sure you're aware of the problems with Type II tests when an interaction, significant or not, is in force.

### DO NOT choose a method because you like the result it gives. That would be called "fishing for statistics." If the three methods give you different results, however, then you're going to have to understand a lot of what follows. Sorry!


###################
# Type III sum of squares method can estimate the effect of B after A + A:B has been removed (in experimental research with mildly unbalanced data), which violate the principle of marginality (to be explained eventually).
# Type III sums of squares DO NOT, by some miracle of mathematics, make it meaningful to look at main effects in the presence of an interaction!


########################
#### Examples
## For these examples, we will look at a very simple, but unbalanced, two-way factorial design. The data are in the MASS library.
########################

## load data
data(genotype, package="MASS")
summary(genotype)

## checking for balance
with(genotype, table(Litter, Mother))
replications(Wt ~ Litter * Mother, data=genotype) # or use this
## the design is unbalanced, we now face the issue of what type analysis we should do.

## try type I
# Type I Analysis, R gives by default. Notice, however, that the result is different depending upon the order in which the factors are entered into the model formula. For this reason, most people do not like Type I, somewhat unfairly in my opinion.
(aov.out1 = aov(Wt ~ Litter * Mother, data=genotype))
summary(aov.out1)
# (lm.out1 = lm(Wt ~ Litter * Mother, data=genotype))
# summary(lm.out1)
# anova(lm.out1) ### lm结果与aov结果一致

aov(Wt ~ Mother+Litter, data=genotype) %>% summary()

# change order
(aov.out2 = aov(Wt ~ Mother * Litter, data=genotype))
summary(aov.out2)
anova(aov.out2)

## try type II
# Type II Analysis, The R base packages do not have a function for Type II tests. We need to install and load "car" package. Order of the factors will not matter in the Type II tests. 
library(car)
Anova(aov.out1)
Anova(aov.out2)
# The result are the same, shows order of the factors will not matter in the Type II tests. 

## try type III
# Type III Analysis, also need to use "car" package, Order of the factors will not matter in the Type III tests. 
Anova(aov.out1, type=3)    # "car" must be loaded; set type=3
Anova(aov.out2, type=3)    # "car" must be loaded; set type=3

###############################################
## 只有1个自变量时1，2，3型没有区别
#####
aov(Wt ~ Mother, data=genotype) %>% anova() # type 1
# Analysis of Variance Table
# Response: Wt
#           Df Sum_Sq Mean_Sq F_value   Pr(>F)   
# Mother     3  771.6 257.202  4.4045 0.007433 **
# Residuals 57 3328.5  58.395 

aov(Wt ~ Mother, data=genotype) %>% car::Anova(type = 2) # type 2
# Anova Table (Type II tests)
# Response: Wt
#           Sum_Sq Df F_value   Pr(>F)   
# Mother     771.6  3  4.4045 0.007433 **
# Residuals 3328.5 57

aov(Wt ~ Mother, data=genotype) %>% car::Anova(type = 3) # type 3
# Anova Table (Type III tests)
# Response: Wt
#             Sum_Sq Df  F_value    Pr(>F)    
# (Intercept)  49107  1 840.9361 < 2.2e-16 ***
# Mother         772  3   4.4045  0.007433 ** 
# Residuals     3329 57 
#############################################################

###############################################
## 有2个及以上自变量且没有交互作用时1型因两个自变量在模型中的顺序不同而不同
                                  ##2,3型不受顺序影响且结果相同
#####
aov(Wt ~ Mother+Litter, data=genotype) %>% anova() # type 1
# Analysis of Variance Table
# Response: Wt
#           Df Sum_Sq Mean_Sq F_value   Pr(>F)   
# Mother     3  771.6 257.202  4.2540 0.009055 **
# Litter     3   63.6  21.211  0.3508 0.788698   
# Residuals 54 3264.9  60.461

aov(Wt ~ Litter+Mother, data=genotype) %>% anova() # type 1
# Analysis of Variance Table
# Response: Wt
#           Df Sum_Sq Mean_Sq F_value   Pr(>F)   
# Litter     3   60.2  20.052  0.3317 0.802470   
# Mother     3  775.1 258.360  4.2732 0.008861 **
# Residuals 54 3264.9  60.461  

## 有2个及以上自变量但没有交互作用时2,3结果相同
aov(Wt ~ Mother+Litter, data=genotype) %>% car::Anova(type = 2) # type 2
# Anova Table (Type II tests)
# Response: Wt
#           Sum_Sq Df F_value   Pr(>F)   
# Mother     775.1  3  4.2732 0.008861 **
# Litter      63.6  3  0.3508 0.788698   
# Residuals 3264.9 54  

aov(Wt ~ Mother+Litter, data=genotype) %>% car::Anova(type = 3) # type 3
# Anova Table (Type III tests)
# Response: Wt
#             Sum_Sq Df  F_value    Pr(>F)    
# (Intercept)  31884  1 527.3435 < 2.2e-16 ***
# Mother         775  3   4.2732  0.008861 ** 
# Litter          64  3   0.3508  0.788698    
# Residuals     3265 54 
#############################################################

###############################################
## 有2个及以上自变量且有交互作用时1型因两个自变量在模型中的顺序不同而不同
                               ## 2,3型不受顺序影响但结果不同
#####
aov(Wt ~ Mother*Litter, data=genotype) %>% anova() # type 1
# Analysis of Variance Table
# Response: Wt
#                Df Sum_Sq Mean_Sq F_value   Pr(>F)   
# Mother         3  771.61 257.202  4.7419 0.005869 **
# Litter         3   63.63  21.211  0.3911 0.760004   
# Mother:Litter  9  824.07  91.564  1.6881 0.120053   
# Residuals     45 2440.82  54.240 

aov(Wt ~ Litter*Mother, data=genotype) %>% anova() # type 1
# Analysis of Variance Table
# Response: Wt
#                Df Sum_Sq Mean_Sq F_value   Pr(>F)   
# Litter         3   60.16  20.052  0.3697 0.775221   
# Mother         3  775.08 258.360  4.7632 0.005736 **
# Litter:Mother  9  824.07  91.564  1.6881 0.120053   
# Residuals     45 2440.82  54.240 

## 有2个及以上自变量且有有交互作用时2,3型不受顺序影响但结果不同
aov(Wt ~ Mother*Litter, data=genotype) %>% car::Anova(type = 2) # type 2
# Anova Table (Type II tests)
# Response: Wt
#                Sum_Sq Df F_value   Pr(>F)   
# Mother         775.08  3  4.7632 0.005736 **
# Litter          63.63  3  0.3911 0.760004   
# Mother:Litter  824.07  9  1.6881 0.120053   
# Residuals     2440.82 45 

aov(Wt ~ Mother*Litter, data=genotype) %>% car::Anova(type = 3) # type 3
# Anova Table (Type III tests)
# Response: Wt
#                Sum_Sq Df F_value   Pr(>F)    
# (Intercept)   20275.7  1 373.8122 < 2e-16 ***
# Mother          582.3  3   3.5782 0.02099 *  
# Litter          591.7  3   3.6362 0.01968 *  
# Mother:Litter   824.1  9   1.6881 0.12005    
# Residuals      2440.8 45 
#############################################################

#### 说明只有在含有两个或者两个以上自变量且模型中有交互项时才需要考虑用2型还是3型，1型一般不用
###############
## About interaction term
### Further Consideration of the "genotype" Data
# Notice in all the analyses we did above, the interaction term is always the same. The highest order effect term will always be the same no matter which of these analyses we choose. Thus, I guess one line of advice here might be "pray for an interaction." When the interaction term is significant, lower order effects are rarely of interest.

### Should we keep the non-significant interaction term(s) or not
# What if the interaction term is not significant? In the two-way analysis, that means interest is focused on the main effects. But, should we drop the interaction term and redo the analysis without it before looking at main effects? Or should the interaction term be retained even though nonsignificant? Opinions differ. 
# The majority consensus seems to be that nonsignificant interactions should be retained in the analysis. As nonsignificant does not mean nonexistent, and the existence of an interaction, significant or not, will eventually become an issue for us as we explore this topic.

# However, if the interaction term(s) is (are) dropped, so that the model becomes additive (just main effects), Type II and Type III analyses will give the same result.

# Changing the model from nonadditive to additive, which has no effect on the size of the main effects in the data, caused the Type III tests to change the evaluation of the main effects considerably, while the Type I and Type II tests changed hardly at all in their evaluation of the main effects.

# Dropping the interaction term in a Type III analysis is not justified, because unlike in the Type I and Type II case, the interaction sum of squares is not orthogonal to the main effects sums of squares.

######## 1型给出的结果与自变量在模型中的顺序相关，那么该不该用，何时用?
####### About entering order of the factors
# Concerning Type I tests, if entering the factors in different orders gives different results, then those results surely have different interpretations. Correct! 
# We'll get to interpretations below. Be aware for now, however, that Type I tests are the ones that least resemble what most people think of as a traditional ANOVA.


#######
### Notice that the row marginal means being tested by Type I and Type II are the weighted means. This is typical for the first factor entered into a Type I test, but is not typical for Type II, where the weighting scheme is usually considerably stranger. Thus, when the design is proportionally balanced, Type I and Type II tests become the same, but that's not because Type I becomes Type II. It's because Type II becomes Type I.



############################################
### Another Example: The Nature of the Problem
##### shows what happens when the factors are clearly confounded (有相关性，共线性)
## create data

## Question: How the quality of care received in two hospitals (variable "Hospital" with levels I and II) by two kinds of patients (variable "Patient" with levels Obstetric and Geriatric) influence the dependent variable "Stay" (length of stay in the hospital measured in days). A fourth variable is "Age" of the patient.

HM = read.table(
#####
header=T, 
text="
Stay   Patient Hospital  Age
   2 Obstetric        I 23.0
   2 Obstetric        I 27.8
   2 Obstetric        I 23.7
   3 Obstetric        I 24.1
   3 Obstetric        I 20.2
   3 Obstetric        I 24.6
   3 Obstetric        I 26.1
   4 Obstetric        I 23.2
   4 Obstetric        I 19.3
   4 Obstetric        I 24.2
   2 Obstetric       II 33.3
   2 Obstetric       II 26.5
   2 Obstetric       II 28.2
   3 Obstetric       II 21.4
   4 Obstetric       II 25.0
  20 Geriatric        I 76.3
  21 Geriatric        I 76.2
  21 Geriatric        I 67.2
  20 Geriatric        I 70.7
  19 Geriatric       II 77.6
  22 Geriatric       II 66.4
  22 Geriatric       II 68.0
  21 Geriatric       II 71.0
  20 Geriatric       II 71.8
  20 Geriatric       II 75.9
  23 Geriatric       II 80.3
  22 Geriatric       II 71.3
  21 Geriatric       II 75.9
  21 Geriatric       II 79.4
  20 Geriatric       II 74.1
  21 Geriatric       II 82.6
")
##### 
## 

HM %>% group_by(Patient) %>% summarise(ave = mean(Stay),
                                       sds = sd(Stay),
                                       num = n())
# Geriatric patients stay a lot longer (M = 20.9 days, SD = 1.02) than obstetric patients do (M = 2.9 days, SD = 0.83), 

table(HM$Patient, HM$Hospital)
#            I II
# Geriatric  4 12
# Obstetric 10  5

# However, Hospital I cares mostly for obstetric patients (n = 10) and relatively few geriatric patients (n = 4), while for Hospital II it's just the reverse (n = 5 obstetric patients, n = 12 geriatric patients).

HM %>% group_by(Hospital) %>% summarise(ave = mean(Stay),
                                       sds = sd(Stay),
                                       n = n())
# Thus, "Hospital" is confounded with the kind of "Patient" being routinely seen, and straightforward calculation of mean Stay by Hospital presents a biased picture (M = 8.0 days, SD = 8.24 for Hospital I, versus M = 15.6 days, SD = 8.70 for Hospital II).


### t-test for stay length is statisically significant, t(29) = 2.47, p = .02, two-tailed. The difference is quite large and "unmistakable" by the traditional Cohen's d criterion, d = 0.9.
## t-tes
t.test(Stay~Hospital, data = HM)
## calculate effect size: Cohen's d
library(effsize)
cohen.d(Stay~Hospital, data = HM)
## about Cohen's d https://www.statisticshowto.com/cohens-d/
## Cohen’s d , or standardized mean difference, measures the effect size of the difference between two means. 
##### Interprete cohen's d
## Small effect = 0.2
## Medium Effect = 0.5
## Large Effect = 0.8


###############################################################
#### How to remove this confound (Hospital) statistically?
   ### Fortunately, we have the Age variable, which we can use as a covariate. 

####******
#### 方法1：do analysis of covariance (ANCOVA)
### https://ww2.coastal.edu/kingw/statistics/R-tutorials/ancova.html
####******

### Type I by aov
# Hospital enter model first
aov(Stay~Hospital*Age, data = HM) # can show whether the design is balanced or not
aov(Stay~Hospital*Age, data = HM) %>% anova() # show the full "Analysis of Variance Table" infor
aov(Stay~Hospital*Age, data = HM) %>% summary() # show less information compared with anova()

# Age enter model first
aov(Stay~Age*Hospital, data = HM) %>% anova() ## hospital not significant anymore

### Type I by lm
# Hospital enter model first
lm(Stay~Hospital*Age, data = HM) %>% summary() # show the coefficients
lm(Stay~Hospital*Age, data = HM) %>% anova() ## get the same result as aov function
# Analysis of Variance Table
# Response: Stay
#              Df  Sum Sq Mean Sq F value    Pr(>F)    
# Hospital      1  442.08  442.08 108.189 6.062e-11 ***
# Age           1 1982.62 1982.62 485.207 < 2.2e-16 ***
# Hospital:Age  1    1.18    1.18   0.288    0.5959    
# Residuals    27  110.33    4.09  

# age enter model first
lm(Stay~Age*Hospital, data = HM) %>% summary() # show the coefficients
lm(Stay~Age*Hospital, data = HM) %>% anova() ## get the same result as aov function
# Analysis of Variance Table
# Response: Stay
#              Df  Sum Sq Mean Sq  F value Pr(>F)    
# Age           1 2422.16 2422.16 592.7764 <2e-16 ***
# Hospital      1    2.53    2.53   0.6199 0.4379    
# Age:Hospital  1    1.18    1.18   0.2880 0.5959    
# Residuals    27  110.33    4.09  

### Age

#### 把模型中的交互项去除
#### ### a weak and non-significant interaction between Age and Hospital is detected (p = 0.596), it can be removed from the analysis first as removing a weak interaction term does not change Type 1,2,3's results hugely and also as is often done in analysis of covariance (ANCOVA). 
### https://ww2.coastal.edu/kingw/statistics/R-tutorials/unbalanced.html

########
### Type II anova
# lm(Stay~Age+Hospital, data = HM) %>% summary() 
lm(Stay~Age+Hospital, data = HM) %>% Anova(type = 2) 

### Type III
# lm(Stay~Age+Hospital, data = HM) %>% summary()
lm(Stay~Age+Hospital, data = HM) %>% Anova(type = 3) 
lm(Stay~Age+Hospital, data = HM) %>% check_model() # check model

### 这里用了 lm来做ANCOVA,实际过程中需要对lm模型进行诊断，此处只是用来学习，暂时不做诊断

# visualize the result
library(effects)
library(ggeffects)
lm(Stay~Age+Hospital, data = HM) %>% allEffects() %>% plot()
lm(Stay~Age+Hospital, data = HM) %>% ggeffect(terms = "Hospital") %>% plot()
lm(Stay~Hospital+Age, data = HM) %>% ggeffect(terms = c("Age","Hospital")) %>% plot()

###### look at the model again
lm(Stay~Age+Hospital, data = HM) %>% summary()
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)    
#   (Intercept) -5.52563    0.80740  -6.844 1.95e-07 ***
#   Age          0.35959    0.01612  22.313  < 2e-16 ***
#   HospitalII  -0.64541    0.80923  -0.798    0.432

# We see that each additional year of Age results in (is associated with) a 0.4 day longer Stay, which is significantly different from 0 (H0: no effect of Age), p < .001, but the difference in average length of Stay (0.6 days less in Hospital II) is no longer statistically significant, p = .4. Adjusted mean Stay in each Hospital can be calculated by the usual method of using the regression equation twice and substituting overall mean Age (50.2 years, mean(HM$Age)):
  # adjusted mean Stay for Hospital I = -5.53 + 0.360 * 50.2 = 12.5 days
  # adjusted mean Stay for Hospital II = -5.53 + 0.360 * 50.2 - 0.65 = 11.9 days

####***********
####* an important issue
####* there are no patients in our sample with an age anywhere near the overall mean of 50.2. 
####* The overall mean age falls in the middle of a very dry well in our bimodal distribution of ages.
hist(HM$Age)
####***********
####* With considerable justification, many of you are probably thinking that by calculating the adjusted means as we just did, we have made an unwarranted 毫无根据的 extrapolation from our data. Hold that thought!)
####*

####***********
####* Suppose the Age variable was not available. Now we must rely on a 2x2 unbalanced factorial ANOVA to get at the truth (and perhaps rightly so given the strongly bimodal nature of the Age variable). We begin with an examination of the relevant means and group sizes.
####
HM %>% group_by(Patient, Hospital) %>% summarise(ave = mean(Stay),
                                                 sds = sd(Stay),
                                                 n = n())
# We can see that, in this sample, Geriatric patients stay a smidge longer in Hospital II, while Obstetric patients stay a smidge longer in Hospital I. Neither of these differences is likely to be meaningful, much less significant, given the sizes of the standard deviations.

####*********** a few relevant points about the design of this study. 
####* First, no subjects have been randomly assigned to any of the conditions of this study. It is an observational study, and both explanatory variables are quasi-independent variables. We might presume that the cell sizes are representative of the sizes of the sampled populations, although there is no guarantee of this and no way to tell from the data. In any event, the cell sizes are not different at random or by accident. 
####* Second, this is the simplest factorial design we can have, a 2x2 design with both variables being tested between groups. I.e., both variables will be tested on a single degree of freedom, which is not important in principle but turns out to be relevant in the calculations that follow. 
####* Third, we can see that we are unlikely to find a signficant interaction in these data, but, as I repeatedly try to hammer into my students, nonsignificant does not mean nonexistent! Perhaps more importantly, there seems (to me) to have been no way to predict a priori whether we should have expected to see an interaction or not.
####* 
####* 
####******
#### 方法2：用type 1 anova, 让patient先进入模型
####******
(aov(Stay ~ Patient + Hospital + Patient:Hospital, data=HM)) %>% anova()
# Analysis of Variance Table
# Response: Stay
#                  Df  Sum Sq Mean Sq   F value Pr(>F)    
# Patient           1 2510.71 2510.71 2801.2056 <2e-16 ***
# Hospital          1    0.00    0.00    0.0049 0.9447    
# Patient:Hospital  1    1.28    1.28    1.4269 0.2427    
# Residuals        27   24.20    0.90    
### 解读，当去除Patient的影响后，Hospital对住院时间无影响（两个医院之间病人的住院时长差异不显著）

ggplot(HM, aes(x=Patient, y = Age, color = Hospital))+
  geom_boxplot()
## boxplots shows that Patient type, hospital and Age all highly correlated with each other (confounded)


Model1 = aov(Stay ~ 1, data=HM)      # no predictors, just an intercept
Model2 = aov(Stay ~ Patient, data=HM)
Model3 = aov(Stay ~ Patient + Hospital, data=HM)
Model4 = aov(Stay ~ Patient + Hospital + Patient:Hospital, data=HM)
anova(Model1, Model2, Model3, Model4)
Model4 %>% summary()

(Model4 = aov(Stay ~ Patient + Hospital + Patient:Hospital, data=HM)) %>% anova()

Model1 = aov(Stay ~ 1, data=HM)      # no predictors, just an intercept
Model2 = aov(Stay ~ Hospital, data=HM)
Model3 = aov(Stay ~ Hospital+Patient, data=HM)
Model4 = aov(Stay ~ Hospital + Patient +  Patient:Hospital, data=HM)
anova(Model1, Model2)
anova(Model1, Model3)
anova(Model1, Model4)
anova(Model1, Model2, Model3, Model4)


#####********
#####* There are more explanations
#####*  https://ww2.coastal.edu/kingw/statistics/R-tutorials/unbalanced.html
