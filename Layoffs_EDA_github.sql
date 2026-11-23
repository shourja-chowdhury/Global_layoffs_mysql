/* 
---------------------------------------------------- EDA --------------------------------------------------------
*/


-- Q: What is the overall scale, date range, and severity (100% shutdowns) of the layoffs?

SELECT 
    MIN(`date`) AS start_date,
    MAX(`date`) AS end_date,
    SUM(total_laid_off) AS total_employees_laid_off,
    MAX(total_laid_off) AS max_single_layoff,
    SUM(CASE WHEN percentage_laid_off = 1 THEN 1 ELSE 0 END) AS total_shutdowns
FROM world_layoffs.layoffs_staging2;


-- Q: Which companies had 1 that is 100 percent of the company laid off?

SELECT company, percentage_laid_off
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1;

-- Q: Which companies, industries, countries, and funding stages experienced the highest workforce reductions?

-- Top 10 Companies by Total Layoffs
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- Top 10 Industries by Total Layoffs
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC
LIMIT 10;

-- Top 10 Countries by Total Layoffs
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
LIMIT 10;

-- Layoffs by Funding Stage
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC
LIMIT 10;

-- Q: How did layoffs evolve over time, and what does the monthly rolling cumulative total reveal?

-- Annual Layoff Totals

SELECT YEAR(`date`) AS layoff_year, sum(total_laid_off) as total_laid_off
FROM layoffs_staging2 
WHERE `date` IS NOT NULL
GROUP BY layoff_year
ORDER BY layoff_year;

-- Monthly Layoffs & Rolling Cumulative Total

WITH Monthly_Totals AS
	(SELECT substring(`date`,1,7) AS `month`, 
		sum(total_laid_off)  monthly_laid_off
	FROM layoffs_staging2
	WHERE `date` is not null
	GROUP BY `month`)
SELECT `month`, monthly_laid_off,
sum(monthly_laid_off) over( ORDER BY `month` ASC) rolling_total
FROM Monthly_Totals
ORDER BY `month` ASC;
 
-- Q: What are the top 3 companies with the most layoffs by year?

WITH Company_Year AS (
    SELECT 
        company,
        YEAR(`date`) AS layoff_year,
        SUM(total_laid_off) AS total_laid_off
    FROM world_layoffs.layoffs_staging2
    WHERE `date` IS NOT NULL AND total_laid_off IS NOT NULL
    GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS (
    SELECT 
        *,
        DENSE_RANK() OVER (PARTITION BY layoff_year ORDER BY total_laid_off DESC) AS ranking
    FROM Company_Year
)
SELECT layoff_year, company, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
ORDER BY layoff_year ASC, ranking ASC;