
source("scripts/functions.R")
## Simulating dataset1
## output: .csv file of longitudinal dataset with N=70000 datapoints and N=10000 individuals 



####### Directories ####################
# set the directory


# Creating new folder for the simulation project
new_folder_path <- "OSA_simulations"
create_new_folder(new_folder_path)



####################### Packages ######################################
# simstudy-for simulations
# mvnfast - for simulation multivariate normal or student's t distribution
# truncnorm - Truncated Normal Distribution
# lubridate - for a timestamp
# sn - the skew-normal and related distributions
# faux - for simulation especially correlated data
# ggplot2 - for graphs
# splines - simulate non-linear relationships

## required packages
required_packages <- c("simstudy", "mvnfast", "truncnorm", "lubridate", "sn", "faux", "ggplot2", "splines", "corrplot")
installed_packages <- installed.packages()[, "Package"]
missing_packages <- required_packages[!(required_packages %in% installed_packages)]

if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}

# Load required packages
lapply(required_packages, library, character.only = TRUE)

################ defining the variables and their features##################################
# sample size
N <- 10000

########################## cross-sectional defintion of simulated variables ############################

# Sex: 0: male (approximately 50%), 1: female (approximately 50%)
def <- defData(
  varname = "sex",
  dist = "binary",
  formula = 0.5
)

# 7-20 years. Starting with an age window between 7 and 8 years and continuing every two years to
# 20 years: Wave 1 – 7-8 years-of-age; Wave 2 – 9-10 years-of-age; Wave 3 – 11-12 years-of-age; Wave 4
# – 13-14 years-of-age; Wave 5 – 15-16 years-of-age; Wave 6 – 17-18 years-of-age; Wave 7 – 19-20 yearsof-
#  age.
def <-
  defData(def,
    varname = "age_wave1",
    dist = "uniform",
    formula = "84;96"
  )


# parental_education	Integer		What is the highest grade or level of school either parent has completed or the highest degree they have received?
# 0 = less than 12th grade ; 1= High school graduate or GED or equivalent Diploma; 2 = Bachelor's degree; 3 = Master's degree or higher;
# 777 = Refused to answer; use NA or blank for missing
# it may be to consider, whether NA is somehow related to some other variables
def <-
  defData(def,
    varname = "parental_education",
    dist = "categorical",
    formula = "0.053;0.354;0.253;0.34"
  ) # US population adapted (0.053;0.354;0.253;0.34)


# Autism diagnosis: 0: no, 1: yes.
### A1:***male at least twice more often with diagnosis than female ***###
### A2:***autism diagnosis was given once at the beginning of data acquisition ***###
def <- defData(
  def,
  varname = "autism_diagnosis",
  dist = "binary",
  formula = "ifelse(sex == 0, rbinom(10000, size = 1, prob = 0.015),
               rbinom(10000, size = 1, prob = 0.005))"
) # assumption that autism is distributed not more than 2% in population



# Cognitive measures: IQ (mean = 100, standard deviation = 15)
### A1:*** IQ not below 80 and not above 164 *** ####
### A2:*** IQ lower in individuals diagnosed with autism***###
def <- defData(
  def,
  varname = "iq",
  dist = "normal",
  formula = "ifelse(autism_diagnosis == 1,  rtruncnorm(10000,a=75,b=120, mean = 90, sd = 10),
               rtruncnorm(10000, a=80, b=164, mean=100, sd=15))"
)



####### Behavior ################

# Behavioral measures: internalizing and externalizing symptoms and attention problems scale based on
# child behavior checklist (CBCL)
# Sum of scores for externalizing section of CBCL, range 0-70
# Sum of scores for the internalizing section of CBCL, range 0-64
# Sum of scores for the attention problem section of CBCL, range 0-20


################## CBCL ###################################
### A1:*** Boys score higher on externalizing scale than girls(Nikstat et al. 2020) *** ####
### A2:*** Autism -> higher values in externalizing and internalizing scores (Guerrera et al. 2019)*** ####
### A3:*** Autism boys with even higher internalizing behavior (Guerrera et al. 2019):with males
# exhibiting more internalizing problems than females. *** ####

def <- defData(
  def,
  varname = "cbcl_externalizing_raw",
  formula = "ifelse(sex == 0 & autism_diagnosis ==0,
                                 rtruncnorm(10000, a = 0, b = 70, mean = 33.5, sd = 15),
                                 0)+

                          ifelse(sex == 1 & autism_diagnosis ==0,
                                 rtruncnorm(10000, a = 0, b = 70, mean = 31.8, sd = 15),0)+

                          ifelse(sex == 0 & autism_diagnosis ==1,
                                 rtruncnorm(10000, a = 0, b = 70, mean = 33.7, sd = 15),
                                 0)+

                          ifelse(sex == 1 & autism_diagnosis ==1,
                                 rtruncnorm(10000, a = 0, b = 70, mean = 32.2, sd = 15),0)"
)

def <- defData(
  def,
  varname = "cbcl_internalizing_raw",
  formula = "ifelse(sex == 0 & autism_diagnosis ==0,
                                 rtruncnorm(10000, a = 0, b = 64, mean = 32, sd = 10),
                                 0)+

                          ifelse(sex == 1 & autism_diagnosis ==0,
                                rtruncnorm(10000, a = 0, b = 64, mean = 34, sd = 10),0)+

                          ifelse(sex == 0 & autism_diagnosis ==1,
                                 rtruncnorm(10000, a = 0, b = 64, mean = 35, sd = 10),
                                 0)+

                          ifelse(sex == 1 & autism_diagnosis ==1,
                                 rtruncnorm(10000, a = 0, b = 64, mean = 33, sd = 10),0)"
)

def <- defData(
  def,
  varname = "cbcl_attentionproblem_raw_score",
  formula = "ifelse(sex == 0 & autism_diagnosis ==0,
                                 rtruncnorm(10000, a = 0, b = 20, mean = 11, sd = 3),
                                0)+

                        ifelse(sex == 1 & autism_diagnosis ==0,
                                 rtruncnorm(10000, a = 0, b = 20, mean = 9, sd = 3),0)+

                        ifelse(sex == 0 & autism_diagnosis ==1,
                                 rtruncnorm(10000, a = 0, b = 20, mean = 11.5, sd = 3),
                                 0)+

                        ifelse(sex == 1 & autism_diagnosis ==1,
                                 rtruncnorm(10000, a = 0, b = 20, mean = 9.6, sd = 3),0)"
)


############################### Generating Cross-sectional dataset ###################################################################
# generating the dataset
set.seed(87261)
dd <- genData(N, def)


######### CBCL adding correlations #############################################################################
###### defining the correlation between cbcl variables
### A1:***CBCL internalizing and externalizing behavior are positively correlated (Bornstein et al. 2010),
### and .587 in ABCD study in N~11402***###
### A2:***CBCL internalizing and attention problems behavior are positively correlated in ABCD study r=0.48***###
set.seed(123)
dd$cbcl_internalizing_raw_score <- pmin(pmax(rnorm_pre(
  dd[, c("cbcl_attentionproblem_raw_score")],
  mu = 32,
  sd = 8,
  r = c(0.48),
  empirical = TRUE
), 0), 64)

set.seed(1234)
dd$cbcl_externalizing_raw_score <- pmin(pmax(rnorm_pre(
  dd[, c(
    "cbcl_internalizing_raw_score",
    "cbcl_attentionproblem_raw_score"
  )],
  mu = 38,
  sd = 8.5,
  r = c(.58, .58),
  empirical = TRUE
), 0), 70)



#####################

# renaming the id variable to subject_id
colnames(dd)[1] <- "subject_id"

# modifyding parents education to the scale between 0-3
# Assign specific values and labels
dd$parental_education <-
  factor(dd$parental_education,
    levels = 1:4,
    labels = c(0, 1, 2, 3)
  )
dd$parental_education <- as.numeric(dd$parental_education) - 1

# Please choose a name for your group
dd$site_id <- "OSA"

# Create a specific date
date <- ymd("2010-06-15")

# Format the date in ISO 8601 (YYYY-MM-DD)
variability <- sample(-15:15, nrow(dd), replace = TRUE)
dd$brain_behavior_measurement_date <-
  format(date + variability, format = "%Y-%m-%d")


# Convert ages to date of birth
dates_of_birth <-
  as.Date(dd$brain_behavior_measurement_date) - days(round(dd$age_wave1 * 30.44 + variability))

# Format dates of birth in "%Y-%m-%d" format
dd$dob <- format(dates_of_birth, "%Y-%m-%d")



################# defining age #####################################################################################################
### Age in months at the time of the interview/test/sampling/imaging.
# Age is rounded to chronological month.
# If the research participant is 15-days-old at time of interview, the appropriate value would be 0 months.
# If the participant is 16-days-old, the value would be 1 month.

dd$age_wave1 <- ifelse((day(dd$brain_behavior_measurement_date) - day(dd$dob)) <= 15,
  (((
    year(dd$brain_behavior_measurement_date) - year(dd$dob)
  ) * 12) + month(dd$brain_behavior_measurement_date) - month(dd$dob) + 0
  ),
  (((
    year(dd$brain_behavior_measurement_date) - year(dd$dob)
  ) * 12) + month(dd$brain_behavior_measurement_date) - month(dd$dob) + 1
  )
)


#### creating age variable for each wave period
dd$age_wave2 <- dd$age_wave1 + 24 + sample(-12:12, nrow(dd), replace = TRUE)
dd$age_wave3 <- dd$age_wave2 + 24 + sample(-12:12, nrow(dd), replace = TRUE)
dd$age_wave4 <- dd$age_wave3 + 24 + sample(-12:12, nrow(dd), replace = TRUE)
dd$age_wave5 <- dd$age_wave4 + 24 + sample(-12:12, nrow(dd), replace = TRUE)
dd$age_wave6 <- dd$age_wave5 + 24 + sample(-3:3, nrow(dd), replace = TRUE)
dd$age_wave7 <- ifelse(dd$age_wave6 + 24 + sample(-3:3, nrow(dd), replace = TRUE) > 240, 240,
  dd$age_wave6 + 24 + sample(-3:3, nrow(dd), replace = TRUE)
)


####################### convert into longitudinal design ##########################################################
dtTime <-
  addPeriods(
    dd,
    nPeriods = 7,
    idvars = "subject_id",
    timevars = c(
      "age_wave1",
      "age_wave2",
      "age_wave3",
      "age_wave4",
      "age_wave5",
      "age_wave6",
      "age_wave7"
    ),
    timevarName = "age"
  )

# wave number ranging from 1 to 7
dtTime$period <- dtTime$period + 1
indx_per <- which(colnames(dtTime) == "period")
colnames(dtTime)[indx_per] <- "wave_number"

# changing the brain_behavior_measurement_date Date according to the age for wave periods 2-7
# Perform date (adding age to the measurement date)
dtTime$brain_behavior_measurement_date[dtTime$wave_number > 1] <-
  format(as.Date(as.Date(dtTime$dob[dtTime$wave_number > 1]) +
    (dtTime$age[dtTime$wave_number > 1] * 30.44)), "%Y-%m-%d")



############################################ BRAIN ##############################################

############# ICV ############

theta_ICV <- c(0.4, 0.45, 0.55, 0.58, 0.6)
knots_ICV <- c(0.3, 0.7)

viewSplines(knots = knots_ICV, theta = theta_ICV, degree = 2)

set.seed(23467)
dtTime <- genSpline(
  dt = dtTime, newvar = "icv_spline", predictor = "age",
  theta = theta_ICV, knots = knots_ICV, degree = 2,
  newrange = "1212968.517;1594190.923", noise.var = 1
)


# Simulate correlated variable
# A1: parental education is correlated with icv, as in elderly, it was shown that icv correlated with years of education r=.172 Buchpiguel et al.
set.seed(9823458)
dtTime$icv <- rnorm_pre(
  dtTime[, c("parental_education", "sex", "icv_spline")],
  mu = 1396825.843,
  sd = 119460.3495,
  r = c(0.09, -0.6, 0.7)
)

ggplot(dtTime, aes(x = age, y = icv)) +
  geom_point(col = "lightgrey") +
  theme_classic() +
  geom_smooth(aes(col = factor(sex)), method = "auto", se = FALSE) +
  geom_smooth(aes(col = "Overall"), method = "auto", se = FALSE)



################# hippocampus ####################
theta_girls_hipp <- c(0.56, 0.62, 0.68, 0.7, 0.68)
theta_boys_hipp <- c(0.56, 0.63, 0.68, 0.72, 0.69)

knots_girls_hipp <- c(0.25, 0.75)
knots_boys_hipp <- c(0.3, 0.75)

viewSplines(knots = knots_girls_hipp, theta = theta_girls_hipp, degree = 2)
viewSplines(knots = knots_boys_hipp, theta = theta_boys_hipp, degree = 2)


# Generate spline for age
set.seed(234)
dtTime <- genSpline(
  dt = dtTime, newvar = "hipp_age_girls_spline",
  predictor = "age",
  theta = theta_girls_hipp, knots = knots_girls_hipp, degree = 2,
  newrange = "6082.65;9582.65", noise.var = 1
)

set.seed(2344)
dtTime <- genSpline(
  dt = dtTime, newvar = "hipp_age_boys_spline",
  predictor = "age",
  theta = theta_boys_hipp, knots = knots_boys_hipp, degree = 2,
  newrange = "6082.65;9582.65", noise.var = 1
)


# Simulate correlated variable
set.seed(3470)
dtTime$hippo_volume[which(dtTime$sex == 1 & dtTime$autism_diagnosis == 0)] <- rnorm_pre(
  dtTime[which(dtTime$sex == 1 & dtTime$autism_diagnosis == 0), c("parental_education", "iq", "hipp_age_girls_spline", "icv")], # include age_spline
  mu = 7732.65,
  sd = 350,
  r = c(0.2, 0.09, 0.7, 0.4)
)


# correlations
set.seed(4753845)
dtTime$hippo_volume[which(dtTime$sex == 0 & dtTime$autism_diagnosis == 0)] <- rnorm_pre(
  dtTime[
    which(dtTime$sex == 0 & dtTime$autism_diagnosis == 0),
    c("parental_education", "iq", "hipp_age_boys_spline", "icv")
  ],
  mu = 7832.65,
  sd = 350,
  r = c(0.2, 0.09, 0.7, 0.4)
)


ggplot(dtTime, aes(x = age, y = hippo_volume)) +
  geom_point(col = "lightgrey") +
  theme_classic() +
  geom_smooth(aes(col = factor(sex)), method = "auto", se = FALSE) +
  geom_smooth(aes(col = "Overall"), method = "auto", se = FALSE)


######## hipp & autism
theta_age_girls_autis <- c(0.57, 0.635, 0.68, 0.66, 0.65)
theta_age_boys_autis <- c(0.575, 0.64, 0.68, 0.66, 0.65)

knots_girls_autis <- c(0.25, 0.75)
knots_boys_autis <- c(0.3, 0.75)

viewSplines(knots = knots_girls_autis, theta = theta_age_girls_autis, degree = 2)
viewSplines(knots = knots_boys_autis, theta = theta_age_boys_autis, degree = 2)

set.seed(67844)
dtTime <- genSpline(
  dt = dtTime, newvar = "hippo_age_girls_aut", predictor = "age", theta = theta_age_girls_autis,
  knots = knots_girls_autis, degree = 2, newrange = "5082.65;8682.65", noise.var = 1
)
set.seed(2784)
dtTime <- genSpline(
  dt = dtTime, newvar = "hippo_age_boys_aut", predictor = "age", theta = theta_age_boys_autis,
  knots = knots_boys_autis, degree = 2, newrange = "5082.65;8682.65", noise.var = 1
)

set.seed(465698)
dtTime$hippo_volume[which(dtTime$sex == 1 & dtTime$autism_diagnosis == 1)] <- rnorm_pre(
  dtTime[which(dtTime$sex == 1 & dtTime$autism_diagnosis == 1), c("parental_education", "iq", "hippo_age_girls_aut", "icv")], # include age_spline
  mu = 7900.2925,
  sd = 470.77,
  r = c(0.2, 0.09, 0.7, 0.4)
)

set.seed(2354556)
dtTime$hippo_volume[which(dtTime$sex == 0 & dtTime$autism_diagnosis == 1)] <- rnorm_pre(
  dtTime[which(dtTime$sex == 0 & dtTime$autism_diagnosis == 1), c("parental_education", "iq", "hippo_age_boys_aut", "icv")],
  mu = 7964.2925,
  sd = 470.77,
  r = c(0.2, 0.09, 0.7, 0.4)
)

ggplot(dtTime, aes(x = age, y = hippo_volume)) +
  geom_point(col = "lightgrey") +
  theme_classic() +
  geom_smooth(aes(col = factor(autism_diagnosis)), method = "auto", se = FALSE) +
  geom_smooth(aes(col = "Overall"), method = "auto", se = FALSE)

##### AMYGDALA ######
set.seed(98776)
dtTime$amygdala_volume <- rnorm_pre(
  dtTime[, c("hippo_volume")],
  mu = 3550.04,
  sd = 224.10,
  r = c(0.7)
)

ggplot(dtTime, aes(x = age, y = amygdala_volume)) +
  geom_point(col = "lightgrey") +
  theme_classic() +
  geom_smooth(aes(col = factor(sex)), method = "auto", se = FALSE) +
  geom_smooth(aes(col = "Overall"), method = "auto", se = FALSE)

ggplot(dtTime, aes(x = age, y = amygdala_volume)) +
  geom_point(col = "lightgrey") +
  theme_classic() +
  geom_smooth(aes(col = factor(autism_diagnosis)), method = "auto", se = FALSE) +
  geom_smooth(aes(col = "Overall"), method = "auto", se = FALSE)


#### white matter volume ####
theta_girls_wm <- c(0.4, 0.66, 0.68, 0.65, 0.64)
theta_boys_wm <- c(0.4, 0.67, 0.68, 0.65, 0.64)

knots_girls_wm <- c(0.53, 0.9) # peak at 10.5 Ladouceura et al. 2012
knots_boys_wm <- c(0.725, 0.95) # peak at 14.5 Ladouceura et al. 2012

viewSplines(knots = knots_girls_wm, theta = theta_girls_wm, degree = 2)
viewSplines(knots = knots_boys_wm, theta = theta_boys_wm, degree = 2)


# Generate spline for age and sex
set.seed(23234)
dtTime <- genSpline(
  dt = dtTime, newvar = "wm_age_girls_spline",
  predictor = "age",
  theta = theta_girls_wm, knots = knots_girls_wm, degree = 2,
  newrange = "299327.59;542004.5714", noise.var = 1
)

set.seed(23444)
dtTime <- genSpline(
  dt = dtTime, newvar = "wm_age_boys_spline",
  predictor = "age",
  theta = theta_boys_wm, knots = knots_boys_wm, degree = 2,
  newrange = "299327.59;542004.5714", noise.var = 1
)



# Simulate correlated variable
set.seed(34730)
dtTime$wm_volume[which(dtTime$sex == 1)] <- rnorm_pre(
  dtTime[which(dtTime$sex == 1), c("wm_age_girls_spline", "icv")],
  mu = 420000.082,
  sd = 24267.6979,
  r = c(0.8, 0.5)
)

set.seed(23545866)
dtTime$wm_volume[which(dtTime$sex == 0)] <- rnorm_pre(
  dtTime[which(dtTime$sex == 0), c("wm_age_boys_spline", "icv")],
  mu = 420666.082,
  sd = 24267.6979,
  r = c(0.8, 0.5)
)

ggplot(dtTime, aes(x = age, y = wm_volume)) +
  geom_point(col = "lightgrey") +
  theme_classic() +
  geom_smooth(aes(col = factor(sex)), method = "auto", se = FALSE) +
  geom_smooth(aes(col = "Overall"), method = "auto", se = FALSE)

###################### GM ################
theta_girls_gm <- c(0.69, 0.69, 0.65, 0.55, 0.4)
theta_boys_gm <- c(0.69, 0.69, 0.68, 0.64, 0.4)

knots_girls_gm <- c(0.4, 0.6) # peak at 10.5 Ladouceura et al. 2012
knots_boys_gm <- c(0.45, 0.6) # peak at 14.5 Ladouceura et al. 2012

viewSplines(knots = knots_girls_gm, theta = theta_girls_gm, degree = 2)
viewSplines(knots = knots_boys_gm, theta = theta_boys_gm, degree = 2)


# Generate spline for age and sex
set.seed(2323234)
dtTime <- genSpline(
  dt = dtTime, newvar = "gm_age_girls_spline",
  predictor = "age",
  theta = theta_girls_gm, knots = knots_girls_gm, degree = 2,
  newrange = "500000;619795.45", noise.var = 1
)

set.seed(223444)
dtTime <- genSpline(
  dt = dtTime, newvar = "gm_age_boys_spline",
  predictor = "age",
  theta = theta_boys_gm, knots = knots_boys_gm, degree = 2,
  newrange = "500000;619795.45", noise.var = 1
)


set.seed(3477930)
dtTime$gm_volume[which(dtTime$sex == 1)] <- rnorm_pre(
  dtTime[which(dtTime$sex == 1), c("gm_age_girls_spline", "icv")], # include age_spline
  mu = 594000.6667,
  sd = 53263.33333,
  r = c(0.4, 0.1)
)


set.seed(2390866)
dtTime$gm_volume[which(dtTime$sex == 0)] <- rnorm_pre(
  dtTime[which(dtTime$sex == 0), c("gm_age_boys_spline", "icv")],
  mu = 594930.6667,
  sd = 53263.33333,
  r = c(0.4, 0.1)
)

ggplot(dtTime, aes(x = age, y = gm_volume)) +
  geom_point(col = "lightgrey") +
  theme_classic() +
  geom_smooth(aes(col = factor(sex)), method = "auto", se = FALSE) +
  geom_smooth(aes(col = "Overall"), method = "auto", se = FALSE)

### frontal lobe thickness ###
theta_girls_thickness <- c(0.69, 0.3, 0.2, 0.15, 0.05)
theta_boys_thickness <- c(0.69, 0.4, 0.3, 0.25, 0.20)

knots_girls_thickness <- c(0.25, 0.7) # peak at 10.5 Ladouceura et al. 2012
knots_boys_thickness <- c(0.25, 0.7) # peak at 14.5 Ladouceura et al. 2012

viewSplines(knots = knots_girls_thickness, theta = theta_girls_thickness, degree = 2)
viewSplines(knots = knots_boys_thickness, theta = theta_boys_thickness, degree = 2)


# Generate spline for age and sex
set.seed(22234)
dtTime <- genSpline(
  dt = dtTime, newvar = "thickness_age_girls_spline",
  predictor = "age",
  theta = theta_girls_thickness, knots = knots_girls_thickness, degree = 2,
  newrange = "3600;3000", noise.var = 1
)

set.seed(444)
dtTime <- genSpline(
  dt = dtTime, newvar = "thickness_age_boys_spline",
  predictor = "age",
  theta = theta_boys_thickness, knots = knots_boys_thickness, degree = 2,
  newrange = "3600;3000", noise.var = 1
)

set.seed(930)
dtTime$frontal_lobe_gm_thickness[which(dtTime$sex == 1)] <- rnorm_pre(
  dtTime[which(dtTime$sex == 1), c("thickness_age_girls_spline", "iq")],
  mu = 2.84,
  sd = 0.13,
  r = c(0.5, -0.4)
)

set.seed(866)
dtTime$frontal_lobe_gm_thickness[which(dtTime$sex == 0)] <- rnorm_pre(
  dtTime[which(dtTime$sex == 0), c("thickness_age_boys_spline", "iq")],
  mu = 2.85,
  sd = 0.13,
  r = c(0.5, -0.4)
)

ggplot(dtTime, aes(x = age, y = frontal_lobe_gm_thickness)) +
  geom_point(col = "lightgrey") +
  theme_classic() +
  geom_smooth(aes(col = factor(sex)), method = "auto", se = FALSE) +
  geom_smooth(aes(col = "Overall"), method = "auto", se = FALSE)

#### checking if we have all variables ####
data_final <- dtTime[, c(
  "subject_id",
  "site_id",
  "dob",
  "brain_behavior_measurement_date",
  "wave_number",
  "autism_diagnosis",
  "age",
  "sex",
  "parental_education",
  "cbcl_externalizing_raw_score",
  "cbcl_internalizing_raw_score",
  "cbcl_attentionproblem_raw_score",
  "iq",
  "wm_volume",
  "gm_volume",
  "hippo_volume",
  "amygdala_volume",
  "frontal_lobe_gm_thickness",
  "icv"
)]



###### Missing values ######
attrition_rate <- 0.19

# adding 777=refused to answer to parental_education
educ_refuse <- 0.01

# Identify rows to introduce missing data
set.seed(126735863)
rows_to_missing <- sample(1:nrow(data_final), size = round(attrition_rate * nrow(data_final)))

set.seed(126735867)
rows_to_refuse <- sample(1:nrow(data_final), size = round(educ_refuse * nrow(data_final)))


# Introduce missing data
data_final[rows_to_refuse,c("parental_education")] <-777

data_final[rows_to_missing, c(
  "autism_diagnosis", "parental_education",
  "cbcl_attentionproblem_raw_score",
  "cbcl_internalizing_raw_score", "cbcl_externalizing_raw_score",
  "age", "iq",
  "wm_volume", "gm_volume", "hippo_volume",
  "amygdala_volume", "frontal_lobe_gm_thickness",
  "icv"
)] <- NA


# changing data types
data_final$subject_id=as.character(data_final$subject_id)


# saving as csv files
write.csv(data_final, file = paste0(new_folder_path, "/OSA_data1.csv"), row.names = FALSE)
