---
layout: page
title: Data Dictionary
description: This is an in depth tutorial for how to submit the data.
---

Your data files must contain _all_ columns. 
The column names, measure coding, data ranges, and distributions (where specified) _must_ adhere to the below criteria before we merge your pull request into our main branch.

**Number of subjects**: 10,000

**Notes:**
- When Required == True in the dictionary below, each row _must_ have an entry in this column. \
That is, there can be no missing data.
- Each group should decide the effect size and amount of noise they would like to include 

**Quality control criteria for entire data file**
- All columns are present and named appropriately 
- Less than 20% missingness

---

#### Individual data file measures:

**Subject ID**
- Column name: `subject_id`
- Data type: String
- Measure type: Demographic
- Required: True
- Time varying: False
- Quality control criteria:
    - All rows contain non-NA values

**Site ID**
- Column name: `site_id`
- Data type: String
- Measure type: Demographic
- Required: True
- Time varying: False
- Quality control criteria: \
    - All rows contain non-NA values
- Notes: \
Site ID should be made up and team/researchers who created the data should not be idenifiable 

**Age**
- Column name: `age`
- Data type: Integer
- Measure type: Demographic
- Units: Months
- Required: False
- Time varying: True
- Quality control criteria: \
    - Less that 20% missingness
    - All entries are between 60 and 264 months
    - `brain_behavior_measurement_date` - `dob` = `age`
- Notes: \
Age in months at the time of the interview/test/sampling/imaging.
Age is rounded to chronological month. 
If the research participant is 15-days-old at time of interview, the appropriate value would be 0 months. 
If the participant is 16-days-old, the value would be 1 month. 

**Sex**
- Column name: `sex`
- Data type: Integer
- Measure type: Demographic
- Required: True 
- Time varying: False
- Levels:
    - 0: Male
    - 1: Female
- Quality control criteria:
    - All rows contain non-NA values
    - All entries are either 0 or 1
- Notes: \
Sex of subject assigned at birth

**Date of birth**
- Column name: `dob`
- Data type: Datetime
- Measure type: Demographic
- Required: True
- Time varying: False
- Quality control criteria:
    - All rows contain non-NA values
    - All entries are in ISO8601 format, which is YYYY-MM-DD

**Measurement date**
- Column name: `brain_behavior_measurement_date`
- Data type: Datetime
- Measure type: Demographic
- Required: False
- Time varying: True
- Quality control criteria:
    - All rows contain non-NA values
    - All entries are in ISO8601 format, which is YYYY-MM-DD

**Waves / Number of time-points**
- Column name: `wave_number`
- Data type: Integer
- Measure type: Demographic
- Required: True
- Time varying: True
- Levels:
    - [1, 2, 3, 4, 5, 6, 7]
- Quality control criteria:
    - All rows contain non-NA values
    - All entries adhere to the appropriate levels
- Notes: Number of time-points per subject: 7 (about every two years)

**Parental education**
- Column name: `parental_education`
- Data type: Integer
- Measure type: Demographic
- Required: False
- Time varying: True
- Levels:
    - 0: Less than 12th grade (about 5.3% of sample)
    - 1: High school or GED (about 35.4% of sample)
    - 2: Bachelor's degree (about 25.3% of sample)
    - 3: Master's or higher degree (about 34% of sample)
- Quality control criteria:
    - Less that 20% missingness
    - All entries adhere to the appropriate levels

**Autism Diagnosis**
- Column name: `autism_diagnosis`
- Data type: Integer
- Measure type: Clinical
- Required: False
- Time varying: False
- Levels:
    - 0: No
    - 1: Yes
- Quality control criteria:
    - Less that 20% missingness
    - All entries adhere to the appropriate levels

**Full scale IQ**
- Column name: `iq`
- Data type: Integer
- Measure type: Cognitive
- Required: False
- Time varying: True
- Quality control criteria:
    - Less that 20% missingness
    - All entries are positive integers less than 200
- Notes: \
IQ score, general population mean 100, sd 15

**Child Behavior Checklist externalizing raw score**
- Column name: `cbcl_externalizing_raw_score`
- Data type: Integer
- Measure type: Behavior
- Required: False
- Time varying: True
- Quality control criteria:
    - Less that 20% missingness
    - All entries are between 0 and 70
- Notes: \
Sum of scores for externalizing section of CBCL

**Child Behavior Checklist internalizing raw score**
- Column name: `cbcl_internalizing_raw_score`
- Data type: Integer
- Measure type: Behavior
- Required: False
- Time varying: True
- Quality control criteria:
    - Less that 20% missingness
    - All entries are between 0 and 64
- Notes: \
Sum of scores for internalizing section of CBCL

**Child Behavior Checklist attention problems raw score**
- Column name: `cbcl_attentionproblem_raw_score`
- Data type: Integer
- Measure type: Behavior
- Required: False
- Time varying: True
- Quality control criteria:
    - Less that 20% missingness
    - All entries are between 0 and 20
- Notes: \
Sum of scores for attention problem section of CBCL

**Grey matter volume**
- Column name: `gm_volume`
- Data type: Integer
- Measure type: Brain
- Required: False
- Time varying: True
- Quality control criteria:
    - Less that 20% missingness
    - All entries are positive and less than 1,000,000 mm^3

**White matter volume**
- Column name: `wm_volume`
- Data type: Integer
- Measure type: Brain
- Required: False
- Time varying: True
- Quality control criteria:
    - Less that 20% missingness
    - All entries are positive and less than 1,000,000 mm^3
    
**Hippocampal volume**
- Column name: `hippo_volume`
- Data type: Integer
- Measure type: Brain
- Required: False
- Time varying: True
- Quality control criteria:
    - Less that 20% missingness
    - All entries are positive and less than 20,000 mm^3
    
**Amygdala volume**
- Column name: `amygdala_volume`
- Data type: Integer
- Measure type: Brain
- Required: False
- Time varying: True
- Quality control criteria:
    - Less that 20% missingness
    - All entries are positive and less than 10,000 mm^3
    
**Cortical thickness of frontal lobe**
- Column name: `frontal_lobe_gm_thickness`
- Data type: Integer
- Measure type: Brain
- Required: False
- Time varying: True
- Quality control criteria:
    - Less that 20% missingness
    - All entries are positive and less than 5 mm
    
**Intracranial volume**
- Column name: `icv`
- Data type: Integer
- Measure type: Brain
- Required: False
- Time varying: True
- Quality control criteria:
    - Less that 20% missingness
    - All entries are positive and less than 5,000,000 mm^3

[Back](../index.html)

---
<p align="right">
    <img src="../images/NIH_NIMH_Master_Logo_2Color.png" width="200"/>
</p>