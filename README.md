Place sample or synthetic data here. Avoid uploading sensitive data.
## Results (Power BI)
**Report:** [Download the PBIX](powerbi/RecruitingAnalytics.pbix)

![Recruiting Analytics Dashboard](assets/dashboard.png)

## How to run
1) Run: `sql/01_create_staging.sql`
2) Import CSVs into `stg_candidates`, `stg_interviews`, `stg_offers`
3) Run: `sql/02_create_dimensions.sql`
4) Run: `sql/03_create_facts.sql`
5) Run: `sql/04_kpi_views.sql`
