# README: How to Run the Code

This document provides a step-by-step guide on how to execute the MATLAB scripts to generate simulated datasets based on brain phenotype data and normative growth trajectories.

## Prerequisites

- MATLAB installed on your computer.
- Ensure that the following data files are available in your working directory:
  - `DAT_QC.csv` (from the ABCD dataset)
  - `names.csv` (from the Nature lifespan brain charts article)
  - `norms.csv` (from the Nature lifespan brain charts article)

## Step A: Estimate Correlation Matrix of Brain Phenotypes

1. **Script to Run**: `A_Rc.m`
2. **Input File**: `DAT_QC.csv`
3. **Process**:
   - The script reads the brain phenotype data from `DAT_QC.csv`.
   - It estimates the correlation matrix of the brain phenotypes.
4. **Output**:
   - The correlation matrix is automatically saved as `Rc.mat` in the current directory.

## Step B: Estimate Normative Growth Model Parameters

1. **Script to Run**: `B_brain_norm.m`
2. **Input Files**:
   - `names.csv`
   - `norms.csv`
3. **Process**:
   - The script reads the normative growth trajectory information from `names.csv` and `norms.csv`.
   - It adjusts and estimates the parameters for the normative growth models of the brain phenotypes of interest.
4. **Output**:
   - The estimated model parameters are automatically saved as `brain_norm.mat` in the current directory.

## Step C: Generate Simulated Datasets

1. **Script to Run**: `C_devSimu.m`
2. **Input Files**:
   - `Rc.mat` (generated in Step A)
   - `brain_norm.mat` (generated in Step B)
3. **Process**:
   - The script reads the correlation matrix and normative growth model parameters.
   - It combines these with other simulation parameters to generate three different simulated datasets.
4. **Output**:
   - The simulated datasets are automatically saved in the current directory with filenames starting with `dpn_data`.

## Summary

- **Step A**: Run `A_Rc.m` to generate `Rc.mat`.
- **Step B**: Run `B_brain_norm.m` to generate `brain_norm.mat`.
- **Step C**: Run `C_devSimu.m` to generate the simulated datasets (`dpn_data*`).
