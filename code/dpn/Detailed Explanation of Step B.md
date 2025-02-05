The MATLAB script `B_brain_norm.m` processes normative brain growth trajectory data from the `names.csv` and `norms.csv` files to adjust and estimate the parameters for normative growth models of brain phenotypes. Here is a summary of its key steps:

------

### **1. Data Loading and Preparation**

- Reads the `names.csv` file to extract brain phenotype names and column indices.
- Reads the `norms.csv` file to obtain normative growth trajectory data.
- Separates the data into 50% (`m_norms`), 75% (`u_norms`), and 25% (`d_norms`) trajectories, scaling them appropriately according to the values in the literature for each brain phenotype of interest.

------

### **2. Data Adjustment and Visualization**

- Adjusts the normative growth trajectories for specific brain phenotypes (e.g., hippocampus, amygdala) by applying scaling and transformation factors (i.e., adjusts the age axis) and offsets according to trajectory characteristics described in the literature.
- Plots the adjusted normative growth trajectories for visualization and validation.

------

### **3. Male-to-Female Ratio Calculation**

- Computes the male-to-female ratio (`mfr`) for each brain phenotype based on the normative data.
- Plots the male-to-female ratio trajectories for each phenotype for visualization and validation.

------

### **4. Standard Deviation Estimation**

- Estimates the standard deviation and adjustment factor of the normative growth trajectories, which captures measurement noise and true inter-individual variability along the trajectories.
- Plots the trajectories with the estimated standard deviation and adjustment factor for visualization and validation.

------

### **5. Polynomial Fitting**

- Fits a 4th-degree polynomial to the normative growth trajectories for each brain phenotype.
- Uses the polynomial coefficients to model the normative growth curves.
- Plots the fitted curves for visualization and validation.

------

### **6. Save Results**

- Saves the polynomial coefficients (`p`), standard deviation (`sd`), and adjustment factor (`fix`) to a file named `brain_norm.mat`.

------

### **Summary**

- The script processes normative brain growth data, adjusts for sex differences, estimates variability, and fits polynomial models to the growth trajectories.
- The output (`brain_norm.mat`) contains the parameters needed to model normative brain growth, which will be used in subsequent steps for simulation.
- The script includes extensive visualization to validate the adjustments and fitting process.