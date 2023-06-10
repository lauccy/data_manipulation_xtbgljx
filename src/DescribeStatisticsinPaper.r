
########### examples on how to describe statistical methods in a paper
######################


#### example 1
## https://www.sciencedirect.com/science/article/pii/S0005789421000204#b0110

### R Software
 # We conducted analyses in R version 3.5.1 (R Core Team, 2018).

## R base packages
 # We conducted analyses of demographic, clinical, and behavioral data using the R base statistical software package version 3.5.1 (R Core Team, 2018)

## mixed model and details etc.
 # Linear mixed effects (LME) analyses were conducted using the lmerTest package (Kuznetsova et al., 2017). A marginal analysis of variance (ANOVA) was applied to each LME model to examine F tests for interactions and main effects. In the event of significant interactions, fixed-effect summaries were examined for clarification. The Kenwardoger approximation of degrees of freedom was used for all LME analyses. To provide estimates of effect size for significant findings, R2 statistics for the ANOVA main effects were computed using the r2glmm package in R (Jaeger, 2017) as described in Edwards et al. (2008) and Cohen's d was calculated for each level of the LME fixed effects using lme.dscore in the EMAtools package (Kleiman, 2017). Figures were created using the ggplot2 package (Wickham, 2011). 


#### example 2

##### https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0258836#pone.0258836.s004

# Statistical analyses
# EF nectar carbohydrate composition.
# All analyses were performed in RStudio with R version 3.6.3 [37]. The monosaccharides, glucose and fructose (hexoses), in EF nectar are the result of post-secretory hydrolysis of the disaccharide sucrose by invertase enzymes [38]. Due to the shared origin of glucose and fructose (i.e., non-independent measurements), the variables are analyzed separately as sucrose, the sum of the hexose concentrations (glucose + fructose), and total sugar content. Quantities were square-root transformed to meet assumptions of normality.
# 
# To test for the effects of herbivory (N = 46) on sucrose, hexose, and total sugar content, repeated measures ANOVA was carried out. These data are the S1 Dataset and the R code for statistical analysis is the S1 Script. To test for positional differences between the first-position flowers on neighboring branches of non-treated plants in the absence of herbivory (N = 19), one-way repeated measures ANOVA was performed. These data are the S2 Dataset and the R code for statistical analysis is the S2 Script. Residuals were tested for normality using Shapiro-Wilk¡¯s test and homogeneity of variance tested with Levene¡¯s test from the ¡°car¡± package (version 3.0¨C7) [39].
# 
# Ant recruitment.
# Ant recruitment to constitutive and induced EF nectar formulations were compared two ways: the percentage of vials in each transect that contained one ant or more (hit percent, [36]) and the average number of ants recruited to vials that had at least one ant (empty vials are not included in the computation of the average recruitment). Each transect constitutes the unit of replication, and N = 10 for both groups.
# 
# To test for differences in hit percent, a generalized linear mixed effect model (GLMM) with a binomial distribution was carried out in R using the ¡°lme4¡± package (version 1.1¨C23) [40]. Hits were treated as a Bernouilli response variable (0: no ants, 1: at least one ant), formulation (constitutive or induced) as the fixed effect, and transect nested within site as the random effect.
# 
# To test for differences in the number of ants recruited, a GLMM with a zero-truncated negative binomial distribution (from ¡°glmmTMB¡± package version 1.0.2.1, [41]) was used because no zeroes (i.e., only vials containing ants) were included in the analysis. This model took the same form as above, with ant count as the response variable, formulation (constitutive or induced) as the fixed effect, and transect nested within site as the random effect. Model diagnostics were performed with the ¡°DHARMa¡± package (version 0.3.3.0) [42]. These data are the S3 Dataset and the R code for statistical analysis is the S3 Script.