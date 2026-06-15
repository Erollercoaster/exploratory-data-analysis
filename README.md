# Exploratory Data Analysis: Tech Layoffs Dataset

## Overview
This project analyzes a dataset of global tech layoffs to uncover trends in **when**, **where**, and **how severely** companies were affected. It follows a completed data cleaning phase (https://github.com/Erollercoaster/layoffs-data-cleaning) and focuses on exploratory data analysis (EDA) using PostgreSQL.

## Dataset
**Dataset:** [Layoffs 2022 — Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022)  

## Tools & Techniques
- PostgreSQL
- Aggregate functions (`SUM`, `AVG`)
- Date functions (`EXTRACT`)
- Window functions (`DENSE_RANK`, `PARTITION BY`)
- CTEs for multi-step aggregation
- `CASE` statements for categorization
- `information_schema` for schema inspection

---

## Initial Exploration

Before diving into specific questions, the dataset was inspected to understand its structure and boundaries:

- Checked column names, data types, and nullability via `information_schema.columns`
- Established the overall date range of the dataset: 2020-03-11/2025-06-04

---

## Key Questions & Findings

### 1. Which sectors were hit hardest?
**Finding:** By total headcount, Hardware was the most affected sector (81,428 layoffs). However, when looking at the average percentage of workforce cut, Aerospace companies were proportionally hit hardest (45.4% on average) despite contributing relatively little to the overall total — suggesting that while fewer aerospace companies underwent layoffs, those that did made severe cuts.

---

### 2. Which countries were most affected? (initial pass)
**Finding:** The United States accounted for the largest share of total layoffs at 505,536.

---

### 3. When did this peak?
**By year:** 2023 was the peak year with 264,220 total layoffs, followed by 2022 with 164,319.

**By month (within 2023):** January 2023 was the single worst month, with 89,709 layoffs.

---

### 4. Were startups hit harder than established companies?
**Finding:** Startups (Seed-Series B) lost an average of **46.65%** of their workforce per layoff event, compared to **20.67%** for established companies (Post-IPO, Acquired, Private Equity) - despite established companies accounting for far more total layoffs in raw numbers (507,469 vs 41,010).

> **Note:** Growth-stage companies (Series C-F) were grouped under "Other" to keep the startup vs. established comparison clean, as they represent a transitional category that could skew results in either direction.

---

### 5. Which 5 companies laid off the most in each year?
**Finding:** The top 5 companies by year reveal a shift from startup/gig-economy layoffs in 2020-2021 (Uber, Booking.com, Bytedance) to sustained large-scale cuts at established tech giants from 2022 onward. Several companies — Meta, Amazon, Cisco, Microsoft, and Intel — appear in the top 5 across multiple years, suggesting repeated rounds of restructuring rather than one-off events. Intel's 2025 total of 22,058 stands out as the single largest annual layoff figure in the dataset.

---

## Data Quality Notes
- `percentage_laid_off` is stored as a whole number (e.g. `46.65`) rather than a decimal - confirmed by checking raw values before aggregating, to avoid inflated results.
- Rows with `NULL` values for `total_laid_off` were excluded from sum-based calculations where relevant (Q5 and Q6).

## Repository Structure
```
exploratory-data-analysis/
├── README.md
├── scripts/
│   └── 01.sql
```

## Lessons Learned
- [e.g. "Learned the difference between EXTRACT and DATE_TRUNC and when each is appropriate."]
- [e.g. "Practiced building multi-layer CTEs by validating each aggregation step independently before stacking window functions on top."]
- [e.g. "Caught a data formatting issue (percentage stored as whole number) before it skewed analysis results."]