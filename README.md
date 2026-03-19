# About this Customer-Segmentation Project:
This project implements an end-to-end Azure Data Lakehouse solution using the Medallion Architecture (Bronze–Silver–Gold) to perform RFM (Recency, Frequency, Monetary) analysis on the Global Superstore dataset.

The pipeline automates ingestion, transformation, and reporting, delivering prescriptive insights that drive actionable business decisions — such as identifying discount gaps for at-risk customers and optimal purchase frequency ranges for maximum profit.

- **End-to-end Project:** [*Click here*](https://www.notion.so/Project-Summary-2feb9932e17f80aca95eeccfc8e810a7)
- **Data Source:** [*Kaggle*](https://www.kaggle.com/datasets/gopikamahadevan/global-superstore)

**Tools and Services**

1. **Azure Data Factory (ADF) –** Orchestrates ingestion pipelines from Blob Storage to ADLS Gen2.
2. **Azure Data Lake Storage Gen2 (ADLS Gen2) –** Primary storage for Bronze, Silver, and Gold datasets.
3. **Azure Databricks (PySpark + SparkSQL) –** Data exploration, cleansing, enrichment, and dimensional modeling.
4. **Power BI –** Consumes curated Gold Layer data for RFM segmentation and churn analysis dashboards.
