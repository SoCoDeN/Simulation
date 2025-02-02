# LongSim_2023_oslojuelich
USAGE

Download the whole directory by clicking Code -> Download ZIP in GitHub or by running `git clone https://github.com/plachti/LongSim_2023_oslojuelich` on the command line. Open the RStudio project `LongSim_2023_oslojuelich.Rproj` in RStudio. This will set the working directory to the top of this folder. Run the scripts Simulations_LongSim_dataset1.R, Simulations_LongSim_dataset2.R, Simulations_LongSim_dataset3.R to generate the simulated data or just run the script create_data.R.
A folder with the name "OSA_simulations" will be created.
In this directory the output, a .csv file per script will be created and saved, containing the simulated dataset. 

The following guidelines were used to create the datasets:
"Number of subjects: 10000
Number of waves/time-points per subject: 7 (about every two years)
Age: 7-20 years. Starting with an age window between 7 and 8 years and continuing every two years to
20 years: Wave 1 – 7-8 years-of-age; Wave 2 – 9-10 years-of-age; Wave 3 – 11-12 years-of-age; Wave 4
– 13-14 years-of-age; Wave 5 – 15-16 years-of-age; Wave 6 – 17-18 years-of-age; Wave 7 – 19-20 yearsof-
age.

Sex: 0: male (approximately 50%), 1: female (approximately 50%)

Cognitive measures: IQ (mean = 100, standard deviation = 15)

Behavioral measures: internalizing and externalizing symptoms and attention problems scale based on
child behavior checklist (CBCL)

Autism diagnosis: 0: no, 1: yes.

Brain volume measures: intracranial volume, total gray matter volume, total white matter volume,
hippocampal volume, amygdala volume, and cortical thickness of frontal lobe. The units should be in
mm3 for volume and mm for thickness. Each group determines the starting point and trajectory of each
brain measure.

Parental Education: 0: less than 12th grade (5.3%), 1: High School or GED (35.4%), 2: Bachelor’s
Degree (25.3%), 3: Master’s or higher degree (34%). These rates are based on US population and can be
adjusted.

Attrition/Missing data: missing timepoints 20%. With release of the key the full data should also
include the missing data. Thus the algorithm for generating missing data should be applied after simulated
dataset is generated. Finally, release of the key should also include the assumption related to the missing
data (i.e. missing at random, missing completely at random, missing not at random).

Effect size, noise: each group decided what effect size and amount of noise they would like to include."

Description of the generated datasets:
Dataset 1

Phenotype
Individuals with autism had on average lower IQ compared to non-diagnosed kids. 
Boys score higher on externalizing scale than girls. Individuals diagnosed with autism scored higher on CBCL externalizing, internalizing and attention problems scales. Autism boys had higher internalizing, externalizing and attention problems than girls diagnosed with autism.
All three behavioral scores were highly positively correlated with each other. 

Brain
ICV is increasing non-linearly with age and is correlated with parental education and sex. Hippocampal volume is increasing with age non-linearly, while boys have a later increase and higher volumes. Both sexes have a dip in puberty, so that the trajectory has two heights. Hippocampal volume is positively correlated with parental education, IQ, and ICV. In autism, hippocampal volume is much higher with steep increases and decreases. 
Amygdala volume is highly correlated with hippocampal volume and follows similar trajectory across age. 
White matter showed a hyperbolic trajectory, while boys had a later height than girls, who reached it earlier. White matter was positively correlated with ICV. 
Grey matter showed a decrease in trajectory across age. Girls had an earlier decrease and slightly steeper than boys. Grey matter was positively correlated with ICV. 
Frontal lobe thickness decreased steeply before puberty and less steeply afterwards. Frontal lobe thickness correlated negatively with IQ. 

Dataset 2

Phenotype 
Same as in dataset1 but with slightly variation of IQ and CBCL behavior across waves. Dataset 2 has more parents with lower education and higher education than dataset 1. 
CBCL attention problems were positively correlated with age and the other CBCL scores (externalizing and internalizing). 

Brain
ICV was almost linearly increasing with higher age, positively correlating with parental education and negatively with sex (boys have bigger ICV). 
Hippocampal volume increases with age until puberty and decreases afterwards, hyperbolic trajectory. Boys have their peak in hippocampal volume slightly later than girls. Hippocampal volume is positively correlated with parental education, IQ, ICV, and negatively with CBCL internalizing behavior. In autism, higher hippocampal volumes were generated, following similar trajectory as in healthy kids. In boys with autism, hippocampal volume is positively correlated with CBCL internalizing behavior. 
Amygdala volume was positively correlated with hippocampal volume, with a similar but flatter trajectory curve. Amygdala volume was negatively correlated with CBCL externalizing scores and slightly positively with internalizing scores. 

White matter increased with age until late puberty, reached a plateau and decreased slightly in early adulthood, with girls reaching earlier the plateau. White matter was positively correlated with ICV. 
Grey matter decreased after puberty, in girls earlier than in boys. Grey matter was positively correlated with ICV. 
Frontal lobe thickness decreased steeply before puberty and less steeply afterwards. Frontal lobe thickness correlated negatively with IQ (less highly as in dataset1). In autism, frontal lobe thickness is higher in childhood, while decreasing steeper with age than in non-diagnosed participants. Frontal lobe thickness is less negatively correlated with IQ. 


Dataset 3 

Phenotype 
Same as in dataset 2 but with slightly different variation of IQ and CBCL behavior across waves. Dataset 3 has more parents with lower education and higher education than dataset 1. 
CBCL attention problems were positively correlated with age and the other CBCL scores (externalizing and internalizing). 

Brain
Relationships of ICV, hippocampus and amygdala were modelled linearly. 
ICV was positively correlated with parental education and negatively with sex. 
In boys hippocampal volume was bigger compared to girls, in both they increased with age. Hippocampal volume correlated higher with parental education in boys. Hippocampal volume was positively correlated with IQ and ICV. Hippocampal volume was higher in autism. 
Amygdala volume increased with age, reaching a ‘plateau’ still slightly increasing with age, correlated with hippocampus volume.  
White matter followed the same trajectory as in dataset 2, but was positively correlated with ICV and IQ.
Grey matter was modelled the same as in dataset 2, but correlated highly positive with white matter volume and ICV. 
Frontal lobe thickness was modelled the same as in dataset 2. 

