/*
================================================================================
Project:     Global Layoffs Data Cleaning (2020–2023)
Database:    MySQL 8.0+ (Schema: world_layoffs)
Source:      https://www.kaggle.com/datasets/swaptr/layoffs-2022
Input:       world_layoffs.layoffs (2,361 rows)
Output:      world_layoffs.layoffs_staging2 (1,995 rows)
Author:      Shourja Chowdhury
Description: Deduplicates records, standardizes industry/country/date fields,
             and removes rows missing both layoff metrics.
================================================================================
*/

/*
--------------------------- Data Cleaning --------------------------------------
*/

-- ============================================================================
-- 1. STAGING SETUP
-- Preserve raw data by working exclusively on a staging copy.
-- ============================================================================
DROP TABLE IF EXISTS world_layoffs.layoffs_staging;

CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT INTO world_layoffs.layoffs_staging 
SELECT * FROM world_layoffs.layoffs;

-- ============================================================================
-- 2. DEDUPLICATION
/* Partition across all 9 columns so that only legitimate exact duplicate rows 
   across 9 columns gets deleted - preventing false deletion.*/
-- ============================================================================
DROP TABLE IF EXISTS world_layoffs.layoffs_staging2;

CREATE TABLE layoffs_staging2 AS 
SELECT
	company, 
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions,
    ROW_NUMBER() OVER(
		PARTITION BY 
			company,
            location,
            industry,
            total_laid_off,
            percentage_laid_off,
            `date`,
            stage,
            country,
            funds_raised_millions
        ORDER BY company)
	AS row_num
    FROM layoffs_staging;
    
-- Deleting duplicate entries only while keeping only unique rows
    
DELETE FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;

-- ============================================================================
-- 3. STANDARDIZATION
-- Fix missing industries via self-join, unify labels, and cast date types.
-- ============================================================================
/* Convert blank industry strings to NULL so that that all missing data is 
   handled consistently across both the cleaning and EDA phases */

UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Populate missing industries from matching company records
UPDATE world_layoffs.layoffs_staging2 t1
JOIN world_layoffs.layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Unify Crypto industry variations
UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

-- Remove trailing periods from country names (e.g., 'United States.')
UPDATE world_layoffs.layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

-- Parse date strings and convert column from TEXT to DATE
UPDATE world_layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;

-- ================================================================================
-- 4. Removing unusable rows
-- Drop rows which has NULL in both layoff metrics; retain remaining numeric NULLs.
-- ================================================================================
DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;
  
  
-- ============================================================================
-- 5. SCHEMA CLEANUP & VALIDATION
-- Remove helper column and verify final row count.
-- ============================================================================
ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN row_num;

SELECT COUNT(*) AS final_row_count 
FROM world_layoffs.layoffs_staging2;

