SELECT
column_name,
data_type,
is_nullable,
column_default
FROM information_schema.columns
WHERE table_name = 'layoffs_clean'

SELECT MIN(date), MAX(date)
FROM layoffs_clean

-- "Which sectors and countries were hit hardest?" 
SELECT 
  industry, 
  SUM(total_laid_off),
  ROUND(AVG(percentage_laid_off), 2) AS avg_pct_laid_off
FROM layoffs_clean
GROUP BY industry
ORDER BY 2 DESC

SELECT
  country,
  SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY total_laid_off DESC

--  "When did this peak?"
SELECT
    EXTRACT(YEAR FROM date) AS year,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
GROUP BY year
ORDER BY total_laid_off DESC;

SELECT
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month,
  SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
WHERE EXTRACT(YEAR FROM date) = 2023
GROUP BY year, month
ORDER BY total_laid_off DESC

-- "Were startups hit harder than established companies?"
SELECT DISTINCT stage
FROM layoffs_clean

SELECT
  CASE
    WHEN stage IN ('Seed', 'Series A', 'Series B') THEN 'Startups'
    WHEN stage IN ('Post-IPO', 'Acquired', 'Private Equity') THEN 'Established Companies'
    ELSE 'Other'
  END AS company_stage,
  SUM(total_laid_off) AS total_laid_off,
  ROUND(AVG(percentage_laid_off), 2) AS avg_pct_laid_off
FROM layoffs_clean
GROUP BY company_stage
ORDER BY total_laid_off DESC;

-- "Which 5 companies laid off the most in each year"
WITH yearly_layoffs AS (
  SELECT
    company,
    EXTRACT(YEAR from date) AS year,
    SUM(total_laid_off) AS total_laid_off
  FROM layoffs_clean
  WHERE total_laid_off IS NOT NULL
  GROUP BY company, EXTRACT(YEAR from date)
),
ranked AS (
  SELECT *,
    DENSE_RANK() OVER(PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
  FROM yearly_layoffs
)

SELECT *
FROM ranked
WHERE ranking <= 5
ORDER BY year





