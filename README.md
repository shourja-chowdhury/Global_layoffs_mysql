# Global Layoffs Data Analysis (2020–2023) | SQL Project

<img width="1000" height="472" alt="image" src="https://github.com/user-attachments/assets/72ee49ec-75cf-4d69-9fa8-5a4ad9319e90" />


## Project Overview

This project explores global corporate layoffs from March 2020 to March 2023 using **MySQL**. It focuses on transforming raw, inconsistent data into a clean analytical dataset and performing Exploratory Data Analysis (EDA) to identify trends, patterns, and insights across companies, industries, countries, and funding stages.

The project is divided into two major phases:

1. **Data Cleaning:** Removing duplicate records, standardizing inconsistent values, handling missing data, and preparing dates for analysis.
2. **Exploratory Data Analysis (EDA):** Investigating layoff trends, identifying the most affected companies and industries, and analyzing temporal and geographical patterns using SQL.

## Objectives

- Clean and transform raw layoff data using MySQL.
- Identify duplicate records and handle missing or inconsistent values.
- Analyze the scale and distribution of global layoffs.
- Identify the companies, industries, and countries most affected.
- Examine annual and monthly layoff trends.
- Calculate rolling cumulative layoffs using SQL window functions.
- Identify the companies with the highest layoffs in each year.

## Dataset

- **Dataset:** Global Layoffs (2020–2023)
- **Source:** [Kaggle – Layoffs Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
- **Original Records:** 2,361 rows
- **Time Period:** March 2020 – March 2023
- **Database:** MySQL
- **Source File:** `layoffs.csv`

### Dataset Attributes

| Column | Description |
|---|---|
| `company` | Name of the company |
| `location` | Location of the company |
| `industry` | Industry in which the company operates |
| `total_laid_off` | Number of employees laid off |
| `percentage_laid_off` | Percentage of the workforce laid off |
| `date` | Date of the layoff event |
| `stage` | Funding or company stage |
| `country` | Country where the company operates |
| `funds_raised_millions` | Total funds raised in millions |

<!--
## Repository Structure

```text
global-layoffs-sql-analysis/
│
├── data/
│   └── layoffs.csv
│
├── sql/
│   ├── 01_data_cleaning.sql
│   └── 02_exploratory_data_analysis.sql
│
└── README.md
```
-->
## Phase 1: Data Cleaning

**SQL Script:** `01_data_cleaning.sql`

The data-cleaning process was performed using staging tables to preserve the integrity of the original dataset.

### Key Operations

1. **Staging Table Creation:** Created staging tables to perform transformations without modifying the original source table.

2. **Duplicate Removal:** Used `ROW_NUMBER()` with `PARTITION BY` across all nine columns to identify and remove exact duplicate records while preserving legitimate multiple layoff events.

3. **Data Standardization:**
   - Converted blank industry values into `NULL`.
   - Populated missing industry values using self-joins on matching company records.
   - Standardized inconsistent industry labels, including `Crypto Currency` and `CryptoCurrency`, into `Crypto`.
   - Removed trailing punctuation and whitespace from country names.
   - Converted date values from text into the MySQL `DATE` data type using `STR_TO_DATE()`.

4. **NULL Handling:** Removed records where both `total_laid_off` and `percentage_laid_off` were `NULL`, while retaining other missing numerical values to avoid distorting analytical results.

5. **Schema Cleanup:** Removed temporary helper columns and validated the final cleaned dataset.

### Data Cleaning Results

| Metric | Raw Dataset | Cleaned Dataset |
|---|---:|---:|
| Total Records | 2,361 | 1,995 |
| Exact Duplicates | 5 | 0 |
| Records Missing Both Layoff Metrics | 361 | 0 |
| Date Data Type | TEXT | DATE |
| Inconsistent Labels | Present | Standardized |

The cleaning process reduced the dataset from 2,361 to **1,995 records**, producing a structured dataset ready for analysis.

## Phase 2: Exploratory Data Analysis (EDA)

**SQL Script:** `02_exploratory_data_analysis.sql`

The cleaned dataset was analyzed using aggregate functions, Common Table Expressions (CTEs), subqueries, and window functions.

### Key Analytical Questions

- What is the overall scale and date range of global layoffs?
- Which companies had 1 that is 100 percent of the company laid off?
- Which companies recorded the highest total layoffs?
- Which industries experienced the greatest workforce reductions?
- Which countries accounted for the largest share of layoffs?
- How did layoffs vary across different funding stages?
- How did layoffs evolve annually and monthly?
- What does the monthly rolling cumulative total reveal?
- Which companies had the highest layoffs in each year?

### SQL Techniques Used

| SQL Concept | Application |
|---|---|
| Aggregate Functions | Calculating total and maximum layoffs |
| GROUP BY | Analyzing layoffs by company, industry, country, and stage |
| ORDER BY | Ranking categories by layoff volume |
| Common Table Expressions (CTEs) | Structuring multi-step analytical queries |
| Window Functions | Calculating rolling cumulative totals |
| ROW_NUMBER() | Identifying duplicate records |
| DENSE_RANK() | Ranking companies within each year |
| CASE WHEN | Identifying complete company shutdowns |
| DATE Functions | Extracting years and analyzing monthly trends |
| Self-Joins | Populating missing industry values |

## Key Findings & Insights

### 1. Overall Scale and Severity

- **383,659 employees** were laid off across 1,995 cleaned records, including 383,159 across dated records and 500 in one undated record.
- The recorded layoff period spans **March 11, 2020, to March 6, 2023**.
- The largest single layoff event was recorded by **Google**, with 12,000 employees laid off on January 20, 2023.
- **116 companies** recorded complete workforce shutdowns, with 100% of their workforce laid off.

### 2. Annual Layoff Trends

| Year | Total Employees Laid Off | Observation |
|---|---:|---|
| 2020 | 80,998 | Initial pandemic-driven layoffs |
| 2021 | 15,823 | Lowest annual layoff volume |
| 2022 | 160,661 | Significant increase in layoffs |
| 2023 (Jan–Mar) | 125,677 | Sharp acceleration in early 2023 |

**Key Insight:** Layoffs followed two major waves. The first occurred during the initial COVID-19 pandemic shock in 2020, while the second emerged during 2022 and accelerated into early 2023.

### 3. Monthly Layoff Trends

- January 2023 recorded the highest monthly layoffs, with **84,714 employees** affected.
- November 2022 followed with 53,451 layoffs.
- February 2023 recorded 36,493 layoffs.

The monthly analysis and rolling cumulative total highlight the changing intensity of workforce reductions over time.

### 4. Most Affected Companies

The companies with the highest recorded total layoffs included:

| Company | Total Layoffs |
|---|---:|
| Amazon | 18,150 |
| Google | 12,000 |
| Meta | 11,000 |
| Salesforce | 10,090 |
| Microsoft | 10,000 |
| Philips | 10,000 |

**Key Insight:** Large technology companies and multinational corporations accounted for a substantial share of the recorded workforce reductions.

### 5. Most Affected Industries

| Industry | Total Layoffs |
|---|---:|
| Consumer | 45,182 |
| Retail | 43,613 |
| Other | 36,289 |
| Transportation | 33,748 |
| Finance | 28,344 |

**Key Insight:** Consumer, retail, transportation, and finance sectors experienced substantial workforce reductions during the analyzed period.

### 6. Geographical Distribution

| Country | Total Layoffs |
|---|---:|
| United States | 256,559 |
| India | 35,993 |
| Netherlands | 17,220 |
| Sweden | 11,264 |
| Brazil | 10,391 |

**Key Insight:** The United States accounted for approximately **66.9%** of all recorded layoffs, making it the most affected country in the dataset.

### 7. Layoffs by Funding Stage

- Post-IPO companies accounted for **53.2% of total layoffs**, representing 204,132 employees.
- This indicates that late-stage and publicly listed companies experienced a substantial share of workforce reductions.

### 8. Annual Leaders

The analysis also identified the three companies with the highest layoffs in each year using `DENSE_RANK()`.

Notable observations:

- **2020:** Mobility and travel companies dominated, including Uber, Booking.com, and Groupon.
- **2021:** Layoffs were concentrated in selected technology and construction companies, including ByteDance, Katerra, and Zillow.
- **2022:** Meta, Amazon, and Cisco were among the leading companies.
- **2023:** Google, Microsoft, and Ericsson recorded substantial layoffs.

## Conclusion

The analysis reveals two distinct waves of global corporate layoffs between 2020 and early 2023.

The **2020 wave** was largely associated with the initial pandemic shock, particularly affecting travel, hospitality, and transportation-related businesses. Following a relatively quieter period in 2021, layoffs increased significantly in 2022 and accelerated during early 2023.

The findings highlight the concentration of workforce reductions among large technology companies, consumer-facing industries, and post-IPO organizations, with the United States accounting for the largest geographical share.

Overall, this project demonstrates how SQL can be used to transform raw datasets into structured, meaningful insights through systematic data cleaning and exploratory analysis.

## How to Run the Project

### Prerequisites

- MySQL 8.0 or later
- MySQL Workbench or another compatible SQL client
- The `layoffs.csv` dataset

### Execution Steps

1. Clone this repository:

   ```bash
   git clone https://github.com/shourja-chowdhury/Global_layoffs_mysql.git

   ```

2. Navigate to the project directory:

   ```bash
   cd Global_layoffs_mysql
   ```

3. Create a database in MySQL:

   ```sql
   CREATE DATABASE world_layoffs;
   ```

4. Import `layoffs.csv` into a table named `layoffs` within the `world_layoffs` database.

5. Execute the data-cleaning script:

   ```text
   sql/Layoffs_data_cleaning_github.sql
   ```

6. Execute the exploratory data analysis script:

   ```text
   sql/Layoffs_EDA_github.sql
   ```

7. Review the query results to explore the findings and trends.

**Note:** The SQL scripts use MySQL-specific syntax and expect the source table to be available as `world_layoffs.layoffs`.

## Skills Demonstrated

- SQL Data Cleaning
- Exploratory Data Analysis (EDA)
- MySQL
- Data Standardization
- Data Quality Management
- Aggregate Functions
- Common Table Expressions (CTEs)
- Window Functions
- Ranking and Analytical Queries
- Time-Series Analysis
- Business Intelligence and Insight Generation

## Author

**Shourja Chowdhury**

Data Analysis | SQL | MySQL | Data Cleaning | Exploratory Data Analysis

---

*This project was developed as part of my data analytics portfolio to demonstrate practical SQL skills and the ability to extract meaningful insights from real-world datasets.*
