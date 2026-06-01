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

SELECT industry, SUM(total_laid_off)
FROM layoffs_clean
GROUP BY industry
ORDER BY 2 DESC


