---
layout: page
title: Project abstract
description: Full project abstract with references
---

### 1. Introduction

Neuroimaging has contributed considerably to our understanding of brain development and its relationship to cognition and behavior [1,2,3,4,5,6]. With increasing availability of longitudinal studies [7,8,9,10], we can apply statistical models to longitudinal datasets to study the temporal trajectories of development and illness progression [11,12,13]. However, despite advancements in neuroimaging, replicability in research remains a key issue and there is no gold standard to evaluate neuroanatomical correlates of cognition and behavior and their interplay. Simulated datasets are one way that we can test hypotheses and assess whether our current models can capture the complex brain-behavior relationship. 

Studies in neuroscience usually suffer from a relatively low statistical power, leading to inflated effect size and low replicability [14]. Underpowered studies are susceptible to finding spurious relationships while missing weaker true associations. In addition, researchers have a great amount of flexibility in data collection, analyses, and reporting, which can contribute to high variability in results. This variability has also contributed to a replication crisis and potentially high degree of false-positive findings [15,16,17]. In a recent study by Marek et. al, 2022 they reiterate the lack of replicability in brain-wide association studies (BWAS) and the need for thousands of subjects for replication of cross-sectional studies where small brain-phenotype associations are expected. It is important to note that a replicated finding, while increasing the probability, does not necessarily imply a true result. There are several conditions required for statistical theory to ensure the selection of the true model with highest frequency under repeated testing with independent observations. First, there must exist a true model generating the observations that is in the search space. Second, the signal in the observations must be detectable. Finally, a reliable method, whose assumptions are met, must be used to perform inferences [18]. 

Replicability of brain-behavior studies will improve with pre-registration, better study design (e.g. longitudinal studies), better phenotyping, technological advancement which can lead to better quality data and signal to noise ratio, increased sample size afforded by large scale studies, data sharing and open science [19,20]. However, one of the challenges in the field of neuroimaging is that in most cases we lack knowledge about the underlying truth and whether our methods can detect these changes. Based on these issues, we propose a project which consists of three components. Stage I is having eight independent groups create simulated longitudinal datasets in line with how they think brain development takes place, including the interaction between brain, behavior, and cognition. Each group will work independently and blinded to the approaches and assumptions made by the other group. The generated simulated datasets will be made freely available to the research community. The syntax to generate the datasets will not be shared within the first year, to provide researchers the opportunity to test different models. Stage 2 will be the release of the syntax used to create the datasets, as well as the complete datasets (including any data that was excluded due to e.g., simulation of missing or truncation of distributions to better reflect some measures). The final stage 3 will be to compare how well actual large-scale data compares to simulated data and how well the estimated model parameters match the true model parameters. This latter, Stage 3 is a long-term goal as more and more longitudinal data become available.

We focus on the critical period of childhood and adolescence, a time of rapid change in physical, emotional, and intellectual growth. MRI has enabled us to non-invasively study growth in children and adolescents and has increased our understanding of brain development. A recent study by Bethlehem et al. [21] modeled nonlinear growth trajectories of brain over the lifespan using MRI in more than one hundred thousand human participants. These lifespan curves showed an increase in cortical gray matter volume from mid-gestation onward, peaking at 5.9 years followed, while total subcortical gray matter volume peaked in adolescence at age 14.4. White matter volume also increased rapidly from mid-gestation to early childhood, peaking at 28.7 years. Other global morphometric measures also showed different trajectories, cortical thickness peaked at 1.7 years while total surface area peaked at around 11 years. However, due the limited availability of longitudinal imaging in their dataset, their models were generated from single cross-sectional time points. 

In addition to studying typical brain development and its relationship to behavior and cognition, reference models are also important for understanding disorders that arise from atypical development. Many studies have focused on finding markers of youth psychopathology by studying association between brain structure and specific diagnosis. For example, mood and internalizing disorder have been associated with reduced cortical thickness and smaller hippocampal volume. While the findings for anxiety have been more mixed, with associated increases in prefrontal cortical thickness and decrease in hippocampal volume [22]. Studies of externalizing disorders have also typically found reduced gray matter volume. A meta-analysis of youth with attention deficit hyperactivity disorder (ADHD) found reduced volume across cortical and subcortical regions [23]. However, there remain some inconsistencies in the findings [24,25]. These studies have traditionally used cross sectional designs, which do not allow for investigating true developmental changes. Longitudinal data enables modeling of temporal changes and studying the interplay between brain and behavior. For example, are the symptoms associated with ADHD due to delay in development? Can some of the symptoms of autism spectrum be described by accelerated growth? Do the brain changes precede behavioral changes or do behavioral experiences cause brain changes, or is it a bidirectional process? Longitudinal designs will help us to better understand the temporal aspect of these dynamic processes. 

Here we present simulated longitudinal data created by eight international groups with expertise in brain development. Each group has simulated longitudinal data independently, based on their understanding of development and its relationship to brain, behavior, and cognition. We focus on global metrics derived from anatomical MRI such as total gray matter volume and cortical thickness as these measures have a good test-retest reliability [26,27], as well as several subcortical regions. We are releasing the full simulated data to the community to offer the opportunity for different groups to test different longitudinal models. The goal of this paper is to describe the important information related to the simulated datasets. 

### 2. Method

Here we present simulated longitudinal data created by eight international groups with expertise in brain development. Each group has simulated longitudinal data independently, based on their understanding of development and its relationship to brain, behavior, and cognition. We focus on global metrics derived from anatomical MRI such as total gray matter volume and cortical thickness as these measures have a good test-retest reliability, as well as several subcortical regions. We are releasing the full simulated data to the community to offer the opportunity for different groups to test different longitudinal models. The goal of this paper is to describe the important information related to the simulated datasets. 

Each group simulated three sets of longitudinal data for brain measures such as volume and cortical thickness as well as cognitive and behavioral measures based on their understanding and models of development. These datasets have been released to the community where different modeling approaches (e.g., linear mixed effects model, cross-lagged panel model) can be used to estimate brain-behavior relationship. 

The following guidelines to create the datasets are as follows:
* **Number of subjects**: 10,000
* **Number of waves/time-points per subject:** 7 (about every two years)
* **Age:** 7-20 years
    * Wave 1 – 7-8 years-of-age
    * Wave 2 – 9-10 years-of-age
    * Wave 3 – 11-12 years-of-age
    * Wave 4 – 13-14 years-of-age
    * Wave 5 – 15-16 years-of-age
    * Wave 6 – 17-18 years-of-age
    * Wave 7 – 19-20 years-of-age 
* **Sex:** 0: male (approximately 50%), 1: female (approximately 50%)
* **Cognitive measures:** IQ (mean = 100, standard deviation = 15)
* **Behavioral measures:** internalizing and externalizing symptoms and attention problems scale based on child behavior checklist (CBCL)
* **Autism diagnosis:** 0: no, 1: yes
* **Brain volume measures:** intracranial volume, total gray matter volume, total white matter volume, hippocampal volume, amygdala volume, and cortical thickness of frontal lobe. The units should be in mm3. Each group determines the starting point and trajectory of each brain measure 
* **Parental Education:** 0: less than 12th grade (5.3%), 1: High School or GED (35.4%), 2: Bachelor’s Degree (25.3%), 3: Master’s or higher degree (34%)

**Attrition/Missing data:** Missing timepoints 20% \
**Effect size, noise:** Each group should decide what effect size and amount of noise they would like to include 

[Back](../index.html)

---
### References

[1] Giedd, J. N, Blumenthal, J, Jeffries, N. O, Castellanos, F. X, Liu, H, Zijdenbos, A, Paus, T, Evans, A. C, & Rapoport, J. L. (1999) Brain development during childhood and adolescence: a longitudinal mri study. Nature neuroscience 2, 861–863.

[2] Casey, B, Tottenham, N, Liston, C, & Durston, S. (2005) Imaging the developing brain: what have we learned about cognitive development? Trends in cognitive sciences 9, 104–110. 

[3] Shaw, P, Greenstein, D, Lerch, J, Clasen, L, Lenroot, R, Gogtay, N, Evans, A, Rapoport, J, & Giedd, J. (2006) Intellectual ability and cortical development in children and adolescents. Nature 440, 676–679. 

[4] Luders, E, Toga, A. W, Lepore, N, & Gaser, C. (2009) The underlying anatomical correlates of long-term meditation: larger hippocampal and frontal volumes of gray matter. Neuroimage 45, 672–678. 

[5] Raznahan, A, Shaw, P, Lalonde, F, Stockman, M, Wallace, G. L, Greenstein, D, Clasen, L, Gogtay, N, & Giedd, J. N. (2011) How does your cortex grow? Journal of Neuroscience 31, 7174–7177. 

[6] Pelphrey, K. A, Shultz, S, Hudac, C. M, & Vander Wyk, B. C. (2011) Research review: constraining heterogeneity: the social brain and its development in autism spectrum disorder. Journal of Child Psychology and Psychiatry 52, 631–644. 

[7] Van Essen, D. C, Ugurbil, K, Auerbach, E, Barch, D, Behrens, T. E, Bucholz, R, Chang, A, Chen, L, Corbetta, M, Curtiss, S. W, et al. (2012) The human connectome project: a data acquisition perspective. Neuroimage 62, 2222–2231. 

[8] Sudlow, C, Gallacher, J, Allen, N, Beral, V, Burton, P, Danesh, J, Downey, P, Elliott, P, Green, J, Landray, M, et al. (2015) Uk biobank: an open access resource for identifying the causes of a wide range of complex diseases of middle and old age. PLoS medicine 12, e1001779. 

[9] Volkow, N. D, Koob, G. F, Croyle, R. T, Bianchi, D. W, Gordon, J. A, Koroshetz, W. J, P ́erez-Stable, E. J, Riley, W. T, Bloch, M. H, Conway, K, et al. (2018) The conception of the abcd study: From substance use to a broad nih collaboration. Developmental cognitive neuroscience 32, 4–7. 

[10] Karcher, N. R & Barch, D. M. (2021) The abcd study: understanding the development of risk for mental and physical health outcomes. Neuropsychopharmacology 46, 131–142. 

[11] Giedd, J. N & Rapoport, J. L. (2010) Structural mri of pediatric brain development: what have we learned and where are we going? Neuron 67, 728–734. 

[12] Sadeghi, N, Prastawa, M, Fletcher, P. T, Wolff, J, Gilmore, J. H, & Gerig, G. (2013) Regional characterization of longitudinal dt-mri to study white matter maturation of the early developing brain. Neuroimage 68, 236–247. 

[13] Gilmore, J. H, Knickmeyer, R. C, & Gao, W. (2018) Imaging structural and functional brain development in early childhood. Nature Reviews Neuroscience 19, 123–137. 

[14] Button, K. S, Ioannidis, J, Mokrysz, C, Nosek, B. A, Flint, J, Robinson, E. S, & Munaf`o, M. R. (2013) Power failure: why small sample size undermines the reliability of neuroscience. Nature reviews neuroscience 14, 365–376. 

[15] Simmons, J. P, Nelson, L. D, & Simonsohn, U. (2016) False-positive psychology: undisclosed flexibility in data collection and analysis allows presenting anything as significant. 

[16] Poldrack, R. A, Baker, C. I, Durnez, J, Gorgolewski, K. J, Matthews, P. M, Munaf`o, M. R, Nichols, T. E, Poline, J.-B, Vul, E, & Yarkoni, T. (2017) Scanning the horizon: towards transparent and reproducible neuroimaging research. Nature reviews neuroscience 18, 115– 126. 

[17] Szucs, D & Ioannidis, J. P. (2020) Sample size evolution in neuroimaging research: An eval- uation of highly-cited studies (1990–2012) and of latest practices (2017–2018) in high-impact journals. NeuroImage 221, 117164. 

[18] Devezer, B, Nardin, L. G, Baumgaertner, B, & Buzbas, E. O. (2019) Scientific discovery in a model-centric framework: Reproducibility, innovation, and epistemic diversity. PloS one 14, e0216125.

[19] White, T., Blok, E. and Calhoun, V.D., 2022. Data sharing and privacy issues in neuroimaging research: Opportunities, obstacles, challenges, and monsters under the bed. Human Brain Mapping, 43(1), pp.278-291.

[20] Nichols, T.E., Das, S., Eickhoff, S.B., Evans, A.C., Glatard, T., Hanke, M., Kriegeskorte, N., Milham, M.P., Poldrack, R.A., Poline, J.B. and Proal, E., 2017. Best practices in data analysis and sharing in neuroimaging using MRI. Nature neuroscience, 20(3), pp.299-303.

[21] Bethlehem, R. A, Seidlitz, J, White, S. R, Vogel, J. W, Anderson, K. M, Adamson, C, Adler, S, Alexopoulos, G. S, Anagnostou, E, Areces-Gonzalez, A, et al. (2022) Brain charts for the human lifespan. Nature 604, 525–533. 

[22] Gold, A. L, Steuber, E. R, White, L. K, Pacheco, J, Sachs, J. F, Pagliaccio, D, Berman, E, Leibenluft, E, & Pine, D. S. (2017) Cortical thickness and subcortical gray matter volume in pediatric anxiety disorders. Neuropsychopharmacology 42, 2423–2433. 

[23] Hoogman, M, Bralten, J, Hibar, D. P, Mennes, M, Zwiers, M. P, Schweren, L. S, van Hulzen, K. J, Medland, S. E, Shumskaya, E, Jahanshad, N, et al. (2017) Subcortical brain volume differences in participants with attention deficit hyperactivity disorder in children and adults: a cross-sectional mega-analysis. The Lancet Psychiatry 4, 310–319. 

[24] Valera, E. M, Faraone, S. V, Murray, K. E, & Seidman, L. J. (2007) Meta-analysis of structural imaging findings in attention-deficit/hyperactivity disorder. Biological psychiatry 61, 1361– 1369. 

[25] Koolschijn, P. C. M, van Haren, N. E, Lensvelt-Mulders, G. J, Hulshoff Pol, H. E, & Kahn, R. S. (2009) Brain volume abnormalities in major depressive disorder: A meta-analysis of magnetic resonance imaging studies. Human brain mapping 30, 3719–3735. 

[26] Wonderlick, J, Ziegler, D. A, Hosseini-Varnamkhasti, P, Locascio, J, Bakkour, A, Van Der Kouwe, A, Triantafyllou, C, Corkin, S, & Dickerson, B. C. (2009) Reliability of mri-derived cortical and subcortical morphometric measures: effects of pulse sequence, voxel geometry, and parallel imaging. Neuroimage 44, 1324–1333. 

[27] Madan, C. R & Kensinger, E. A. (2017) Test–retest reliability of brain morphology estimates. Brain informatics 4, 107–121. 

---
<p align="right">
    <img src="../images/NIH_NIMH_Master_Logo_2Color.png" alt="Workflow" width="200"/>
</p>