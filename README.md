# Visual complaints as a moderator 

### Project Overview
Since deficits in executive functions as well as in vision are both risk factors for depression and anxiety, screening for them in people that do not meet the clinical threshold for these mental disorders yet, would aid in identifying risk groups. Targeting the identified people at risk would improve the prevention of the clinical onset of these mental disorders. Therefore, it would be helpful to examine whether executive functions and vision impairment are already associated with depressive and anxiety symptoms in a sample of people with preclinical levels. 

The aim of the project is, thus, to assess whether a relationship between deficits in executive functions, as well as vision, and depressive and anxiety symptoms can be established in a self-proclaimed healthy sample. Additionally, the role of visual complaints as a moderator in the relationship between executive functions and anxiety and depression levels will be investigated.  


## Methods Used

### Needs of this project
- Data Processing and Cleaning
- Data Exploration and Descriptive Statistics
- Statistical Modeling
- Inferential Statistics
- Data Visualization
- Reporting

### Technologies
- Editor: RStudio
- R Version: 4.1.0

### R Packages Used
- Data Manipulation: foreign, tidyverse, tidyselect, broom
- Data Analysis: car, psych, faraway, rcompanion, pwr
- Data Visualization: ggpubr

## Data
### Source Data
The data was taken from the study by [Huizinga et al. (2020)](https://pubmed.ncbi.nlm.nih.gov/32348342/). The study is a cross-sectional online questionnaire study to validate the Screening of Visual Complaints questionnaire in healthy Dutch participants. The sample was a convenience sample. All participants volunteered to participate and filled out the same questionnaires for the study. 

Original data [Data_total.csv](https://github.com/TheoN21/visual_complaints_moderation/blob/main/data/Data_total.csv) retrieved [from](https://dataverse.nl/dataset.xhtml?persistentId=doi:10.34894/CMJXAK)

### Data Preprocessing
- Variable selection
- Changing data types
- Assessing missing data
- Checking for outliers
  
Cleaned data [dataTN](https://github.com/TheoN21/visual_complaints_moderation/blob/main/data/dataTN.Rdata)

## Code structure
1. Raw Data is being kept [here](https://github.com/TheoN21/visual_complaints_moderation/blob/main/data/Data_total.csv) 
2. Data preprocessing script is being kept [here](https://github.com/TheoN21/visual_complaints_moderation/blob/main/0data_preprocessing.R)
3. Exploratory and descriptive analysis script is being kept [here](https://github.com/TheoN21/visual_complaints_moderation/blob/main/1exploratory_descriptive_analysis.R)
4. Statistical modeling and data analysis script is being kept [here](https://github.com/TheoN21/visual_complaints_moderation/blob/main/2statistical_modeling.R)

## Results and evaluation
Provide an overview of the results of your project, including any relevant metrics and graphs. Include explanations of any evaluation methodologies and how they were used to assess the quality of the model. You can also make it appealing by including any pictures of your analysis or visualizations.

PDF of my [report]()

## Reference
Original dataset: 
Huizinga, F.; Heutink, J.; de Haan G.A.; van der Lijn, I; van der Feen, F.E.; Vrijling, A.C.L.; Melis-Dankers, B.J.M.; de Vries, S.M.; Tucha, O.M.; Koerts, J., 2019, "Replication Data for: “The development of the Screening of Visual Complaints questionnaire for patients with neurodegenerative disorders: evaluation of psychometric features in a community sample”", https://doi.org/10.34894/CMJXAK, DataverseNL, V1 

## License 
License associated with the original dataset can be found [here](https://dataverse.org/best-practices/dataverse-community-norms)



