CREATE VIEW view_industry_impact AS
SELECT 
  industry, 
  SUM(total_laid_off) AS total_laid_off,
  ROUND(AVG(percentage_laid_off), 2) AS avg_pct_laid_off
FROM layoffs_clean
GROUP BY industry
ORDER BY total_laid_off DESC;

SELECT * FROM view_industry_impact LIMIT 5;

CREATE VIEW view_country_impact AS
WITH country_totals AS (
  SELECT
  country,
  SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY total_laid_off DESC
),
ranked AS (
  SELECT *,
    DENSE_RANK() OVER(ORDER BY total_laid_off DESC) AS ranking
  FROM country_totals
)
SELECT
  CASE WHEN ranking <= 15 THEN country ELSE 'Other' END AS country_grouped,
  SUM(total_laid_off) as total_laid_off
FROM ranked
GROUP BY CASE WHEN ranking <= 15 THEN country ELSE 'Other' END
ORDER BY total_laid_off DESC;


SELECT * FROM view_country_impact;

CREATE VIEW view_yearly_monthly_totals AS
SELECT
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month,
  SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
GROUP BY year, month
ORDER BY year, month


SELECT
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month,
  SUM(total_laid_off) AS total_laid_off
FROM layoffs_clean
GROUP BY year, month
ORDER BY year, month

SELECT * FROM view_yearly_monthly_totals

CREATE VIEW view_growth_stages_totals AS
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

SELECT * FROM view_growth_stages_totals

CREATE VIEW view_company_rank_layoffs AS
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

SELECT * FROM view_company_rank_layoffs