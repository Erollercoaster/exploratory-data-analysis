SELECT
column_name,
data_type,
is_nullable,
column_default
FROM information_schema.columns
WHERE table_name = 'layoffs_clean'

SELECT *
FROM layoffs_clean
WHERE percentage_laid_off = 1;

SELECT MIN(date), MAX(date)
FROM layoffs_clean

-- "Which sectors were hit hardest?" 
SELECT 
  industry, 
  SUM(total_laid_off),
  ROUND(AVG(percentage_laid_off) * 100, 2) AS avg_pct_laid_off
FROM layoffs_clean
GROUP BY industry
ORDER BY 2 DESC

SELECT 
  country, 
  SUM(total_laid_off)
FROM layoffs_clean
GROUP BY country
ORDER BY 2 DESC

--  "when did this peak?"
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


SELECT *
FROM layoffs_clean