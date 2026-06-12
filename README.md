# Manager Performance & Workload Analysis

## Overview
An HR data analysis project examining manager performance,
workload distribution, and key performance predictors across
500+ manager records. Conducted as a course project for
DS 102 at California State University, Sacramento.

**Central Question:** What factors influence manager
performance, workload efficiency, and concern flag status
— and what HR actions do these findings support?


## Tools & Technologies
| Tool | Purpose |
|---|---|
| **R** | Statistical analysis and data manipulation |
| **RStudio** | Development environment and visualization |

## Dataset
- **Records:** 500+ manager records
- **Sources:** managers.csv, managers_append.csv,
  manager_bonus.csv (3 merged datasets)
- **Variables:** Performance group, years employed,
  test scores, group size, city, hours worked,
  bonus scores, concern flags, CPE


## Analyses Performed

| Analysis | Method | Key Finding |
|---|---|---|
| Data Preparation | rbind, merge | Appended 10 missing records, merged bonus data |
| Descriptive Stats | mean, median, min, max | Median 4+ years experience, avg test score 242 |
| Workload Metric | CPE = customers/group_size | 19 high-demand managers, 14 outliers |
| Performance vs Efficiency | Boxplot + AVG | Bottom group highest CPE (1.92) |
| Long Hours vs Performance | Chi-square test | Significant association (p = 0.0006) |
| City Analysis | Bar plots | Toronto largest manager concentration |
| Experience vs Test Score | Scatter + Correlation | No meaningful relationship (r = 0.0098) |
| Predicting Test Scores | Linear Regression | Group size only significant predictor (p < 0.001) |
| Concern Flag Analysis | Boxplot + Bar plot | Newer managers more likely flagged |


## Key Findings
- Bottom-performing managers carry the **highest workload**
  (CPE = 1.92) — excessive demand reduces effectiveness
- Higher-performing managers significantly more likely to
  work long hours (55% vs 30% for bottom group, p = 0.0006)
- Years of experience shows **no correlation** with test
  scores (r = 0.0098) — experience does not predict performance
- **Group size** is the only statistically significant
  predictor of test scores (p < 0.001, coefficient = 5.66)
- Concern-flagged managers tend to have **fewer years of
  experience** — newer managers need more structured support


## HR Recommendations
- Rebalance workloads for bottom-performing managers
  to reduce CPE and improve effectiveness
- Implement mentorship programs for newer managers who
  are disproportionately flagged for concern
- Use group size as a key factor in team structure
  and staffing decisions
- Investigate the link between long hours and top
  performance to prevent leadership burnout


## Repository Structure
manager-performance-analysis/
├── r_script/         → Full annotated R analysis script
├── outputs/          → All RStudio plot outputs (10 charts)
├── written_report/   → Full written analysis report
└── README.md         → Project documentation


## Author
**Yodhvir Hyare**
- 🔗 LinkedIn: [linkedin.com/in/yodhvirhyare](https://www.linkedin.com/in/yodhvirhyare)
- 💻 GitHub: [github.com/yodhvir24](https://github.com/yodhvir24)

*Course: DS 102-01 | Instructor: Dr. Fernanda Maciel*
*California State University, Sacramento | Spring 2026*
*Tools: R | RStudio*
