######################################################################################

# This program reads in one dataset from the simulation project at our site and alters
# it in such a way that there is 100 percent prediction of the ASD variable, embedded
# in the code

# Date:             June 2024
# Modified:         February 14, 2025
# Author:           Tonya White, MD, PhD
# Location:         Bethesda, MD, & Moline, IL USA    

######################################################################################

import os
#import numpy as np
import pandas as pd
#import matplotlib.pyplot as plt


# Read in one of the datasets to modify
sim = pd.read_csv('./paint_data4.csv')
# Sort the dataframe to ensure proper ordering
sim = sim.sort_values(by=['subject_id','wave_number'])

# Extract the variables from the dataframe that will be used to calculate the new amygdala variable
y = sim[['wave_number','amygdala_volume','wm_volume','gm_volume','icv','iq','autism_diagnosis']].values
sz = y.shape[0]

for i in range(sz):
    if y[i,0] == 2:
        y[i,1] = (y[i-1,1] + ((y[i+1,1] - y[i-1,1]) * (y[i-1,2]*y[i-1,3]*y[i-1,5]) / (32 * (y[i,4] ** 2)))) - (y[i-1,6] * 10)

sim['amygdala_volume'] = y[:,1]

# Store the modified pandas dataframe to a csv file
sim.to_csv('./paint_data2.csv', index=False)

