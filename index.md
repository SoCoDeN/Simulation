---
layout: page
title: Welcome!
---

#### Quick links:
&emsp; [Project abstract](pages/full_abstract.html) \
&emsp; [Description of measures and data dictionary](pages/measures.html) \
&emsp; [Data submission tutorial](pages/tutorial.html)

---

To submit your simulated data files, you will need to:
1. Fork [our repository](https://github.com/SoCoDeN/Simulation)
2. Create a branch with the same name as your site ID
3. Commit your data files to `data/<site_id>/`
4. Push your your data files to your remote repository
5. Create a pull request into our repository

The pull request will automatically run a script that ensures your data files are ready for submission. \
Please see our [data dictionary](pages/measures.html) for information about the measures and quality checking criteria
and see our [data submission tutorial](pages/tutorial.html) for a complete walkthrough of how to submit your data.

Data files should be named: `<site_id>_dataX.csv`, where `site_id` is your site ID and `X` is an integer.
For example, if your site ID is `nimh` and you are submitting 3 data files, your tree should look like:
```
Simulation/
    data/
        nimh/
            nimh_data1.csv
            nimh_data2.csv
            nimh_data3.csv
```

#### Are you ready to submit your data?
- [x] &ensp; All columns are present in my data file(s)
- [x] &ensp; All columns are named properly
- [x] &ensp; Data are coded according to the [data dictionary](pages/measures.html)
- [x] &ensp; All measures are within the appropriate scales and distribution
{: style='list-style-type: none'}

### [Create Pull Request](https://github.com/SoCoDeN/Simulation/pulls)

---
<p align="center">
    <img src="./images/Workflow_simulation_6.png"/>
</p>

---
<p align="right">
    <img src="./images/NIH_NIMH_Master_Logo_2Color.png" width="200"/>
</p>