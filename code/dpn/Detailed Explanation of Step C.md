The MATLAB script `C_devSimu.m` generates simulated datasets based on the correlation matrix (`Rc.mat`) and normative growth model parameters (`brain_norm.mat`) obtained from previous steps. Here is a summary of its key tasks:

------

### **1. Simulation Settings**

- Defines the number of subjects (`N = 10,000`) and time points (`Nt = 7`).
- Sets the follow-up interval between time points (24 months) with some variability.

------

### **2. Age Sampling**

- Generates ages for subjects across time points, ensuring they fall within a specified range (60 to 276 months).
- Adjusts intervals and resets samples with out-of-range ages.

------

### **3. True Z-Scores for Brain Phenotypes**

- Simulates true z-scores for brain phenotypes using the correlation matrix (`Rc`) and Cholesky decomposition.
- Adjusts z-scores to ensure they fall within a reasonable range.
- Models the individual-level trajectories of brain phenotypes over time using quadratic functions (`a` and `b` coefficients). The parameters are set differently according to the potentially different longitudinal characteristics of each brain phenotype of interest.

------

### **4. IQ, Parental Education, Autism Diagnosis, and Sex**

- Simulates IQ scores based on brain phenotype z-scores and random noise.
- Simulates parental education levels (`par_edu`) using a cumulative distribution function (CDF) approach.
- Simulates autism diagnosis scores based on brain phenotype z-scores, IQ, and random noise.
- Assigns sex (male/female) to subjects, with adjustments for autism prevalence.

------

### **5. CBCL (Child Behavior Checklist) Scores**

- Simulates externalizing, internalizing, and attention problem scores using a predefined correlation matrix (`R_cbcl`).
- Adjusts scores based on IQ, parental education, autism diagnosis, sex, etc.
- Converts scores to raw values using a beta distribution.

------

### **6. Raw Brain Phenotypes**

- Converts z-scores to raw brain phenotype values using the normative growth model parameters (`p`, `sd`, `fix` from `brain_norm.mat`).
- Adjusts values for females using male-to-female ratios (`mfr`).

------

### **7. Raw IQ Scores**

- Converts IQ z-scores to raw IQ scores (mean = 100, standard deviation = 15) with age-dependent measurement noise levels.

------

### **8. Site and Date Information**

- Assigns subjects to simulated sites based on sex, IQ, and parental education. However, this information is not used because the dataset format review requires all samples to have the same site name.
- Generates birth dates and scan dates for subjects within a specified range.

------

### **9. Output**

- Combines all simulated data into a table and writes it to a CSV file (`dpn_dataX.csv`, where `X` is the run number).
- The output includes:
  - Subject ID, site ID, age, sex, birth date, scan date, wave number.
  - Parental education, autism diagnosis, IQ, CBCL scores.
  - Raw brain phenotype values (gray matter volume, white matter volume, hippocampal volume, amygdala volume, frontal lobe thickness, and intracranial volume).

------

### **Summary**

- The script generates a comprehensive simulated dataset for 10,000 subjects across 7 time points.
- It incorporates reasonable variability in brain phenotypes, IQ, parental education, autism diagnosis, and behavior scores.
- The simulation is repeated three times (`run = 1:3`) to generate multiple datasets.
- The output is saved as CSV files (`dpn_data1.csv`, `dpn_data2.csv`, `dpn_data3.csv`) for further analysis.