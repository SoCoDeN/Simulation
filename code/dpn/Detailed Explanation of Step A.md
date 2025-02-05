The MATLAB script `A_Rc.m` performs the following tasks to estimate the correlation matrix of brain phenotypes from the ABCD dataset:

1. **Data Loading**:
   - Reads the dataset `DAT_QC.csv` into a table `ABCD`.
2. **Male-to-Female Ratio Adjustment**:
   - Filters the dataset to include only the most heavily sampled age range (ages between 107 and 134 months).
   - Separates the data into male (`M`) and female (`F`) groups based on the sex column.
   - Computes the male-to-female ratio (`mfr`) for each brain phenotype by dividing the mean values of males by the mean values of females.
   - Adjusts the female data by multiplying it with the computed ratio (`mfr`) and combines it with the male data into a single matrix `MF`.
3. **Correlation Matrix Calculation**:
   - Computes the median (`m`) of the combined data `MF`.
   - Calculates the correlation matrix (`corrMF`) and its confidence intervals (`R`, `RL`, `RU`) using a significance level of 0.001.
   - Filters the confidence intervals to retain the largest correlation coefficients within the confidence interval (to compensate for potential reductions in the observed correlation coefficients due to measurement noise) and combines them into a final matrix `Rc`.
4. **Validation and Saving**:
   - Validates the correlation matrix by checking its eigenvalues.
   - Simulates data (`Z`) based on the correlation matrix `Rc` using Cholesky decomposition and verifies the simulated correlation matrix (`RZ`).
   - Saves the final correlation matrix `Rc` to a file named `Rc.mat`.

### Summary:

- The script processes brain phenotype data from the ABCD dataset, adjusts for sex differences, computes a correlation matrix, and validates it through simulation.
- The output is a correlation matrix (`Rc`) saved as `Rc.mat`, which will be used in subsequent steps.
