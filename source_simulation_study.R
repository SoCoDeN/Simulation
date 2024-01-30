# Simulation Study Source Script
# SoCoDeN Lab NIMH
# Isabelle van der Velpen

# Libraries
library(tidyverse)
#library(ggplot2)
library(ggpubr)
library(cowplot)
library(gridExtra)
library(lattice)
library(foreign)
library(haven)
library(xlsx)
#library(lubridate) 
library(data.table)
library(readxl)
library(table1)
#library(forcats)
library(htmltools)
library(psych)
library(mice)
library(miceadds)
library(visdat)
library(VIM)
library(corrplot)
library(nlme)
library(geepack)
library(splines)


# Original simulation data N Sadeghi December 2023 ####

# Load datasets
getwd()
setwd("/Users/vandervelpenif/Library/CloudStorage/OneDrive-NationalInstitutesofHealth/Local files loaner laptop/Simulation study/")
sim1 <- read.csv(file = "Datasets Neda Dec2023/simulation1.csv")
sim2 <- read.csv(file = "Datasets Neda Dec2023/simulation2.csv")
sim3 <- read.csv(file = "Datasets Neda Dec2023/simulation3_with_iq.csv")

#colorblind-friendly palette
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# Explore datasets
source("R_scripts/exploration.R")

# Histograms / Bar plots
source("R_scripts/histograms.R")

# Box plots / Violin plots


# Scatter plots / Heat map
source("R_scripts/scatter.R")

# Wide to Long format
source("wide_to_long.R")

# Spaghetti plots / Line plots
load(file = "R_scripts/sim1_long.RData")
load(file = "R_scripts/sim2_long.RData")
load(file = "R_scripts/sim3_long.RData")
source("line_plots.R")

# Summary stats
setwd("/Users/vandervelpenif/Library/CloudStorage/OneDrive-NationalInstitutesofHealth/Local files loaner laptop/Simulation study/")
source("R_scripts/table1.R")
rm(list=setdiff(ls(),c("sim1_long", "sim2_long","sim3_long")))

# Missing data analysis
#   n.v.t.

#Linear Mixed Model exploration
setwd("/Users/vandervelpenif/Library/CloudStorage/OneDrive-NationalInstitutesofHealth/Local files loaner laptop/Simulation study/")
source("R_scripts/spaghettiplots.R")
source("R_scripts/descriptives_long.R")
rm(list=setdiff(ls(),c("sim1_long", "sim2_long","sim3_long")))

# LMM TEST RANDOM EFFECTS
setwd("/Users/vandervelpenif/Library/CloudStorage/OneDrive-NationalInstitutesofHealth/Local files loaner laptop/Simulation study/")
source("R_scripts/LMM_test_random_effects.R")
rm(list=setdiff(ls(),c("sim1_long", "sim2_long","sim3_long")))
# fit3 lowest AIC and BIC --> random intercept, linear slope and quadratic slope


# LMM TEST COVARIANCE MATRIX
setwd("/Users/vandervelpenif/Library/CloudStorage/OneDrive-NationalInstitutesofHealth/Local files loaner laptop/Simulation study/")
source("R_scripts/LMM_test_covariance_matrix.R")
rm(list=setdiff(ls(),c("sim1_long", "sim2_long","sim3_long")))
# logChol parameterized variance-covariance matrix
# amygvol: symmetrical matrix

# LMM TEST (NON-)LINEARITY OF THE TIME VARIABLE FOR EACH DETERMINANT AND OUTCOME 
setwd("/Users/vandervelpenif/Library/CloudStorage/OneDrive-NationalInstitutesofHealth/Local files loaner laptop/Simulation study/")
source("R_scripts/LMM_test_nonlinear_time.R")
rm(list=setdiff(ls(),c("sim1_long", "sim2_long","sim3_long")))
# gmVol:      linear age
# attention:  spline df=3 age
# external:   spline df=2 age
# internal:   spline df=3 age
# amygVol:    spline df=2 age


# LMM TEST INTERACTIONS BETWEEN DETERMINANTS
setwd("/Users/vandervelpenif/Library/CloudStorage/OneDrive-NationalInstitutesofHealth/Local files loaner laptop/Simulation study/")
source("R_scripts/LMM_test_fixed_structure.R")
rm(list=setdiff(ls(),c("sim1_long", "sim2_long","sim3_long")))




