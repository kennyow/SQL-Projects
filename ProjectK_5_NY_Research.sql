# USING TABLE BHO_MH (BHO_MH.CSV) FROM PROJECTS DATABASE

USE projects;

SELECT * FROM bho_mh;
SELECT COUNT(*) FROM bho_mh;
DESC bho_mh;

-- Deleting Column that has the same date to for all te registers
ALTER TABLE bho_mh
DROP COLUMN `Row Created Date Time`;

-- USING MAX AND MIN TO DISCOVER THE MAX  AND MIN RATE
SELECT "Rate", MAX(Rate) AS MAX_RATE, MIN(Rate) AS MIN_RATE
FROM bho_mh;

-- DISCOVER THE MEDIAN, AVERAGE AND MODE
-- Average
SELECT ROUND(AVG(Numerator),2) AS AVERAGE
FROM bho_mh;

-- Median
SELECT 
    ROUND(AVG(Numerator),2) AS MEDIAN
FROM (
    SELECT Numerator, ROW_NUMBER() OVER (ORDER BY Numerator) AS row_num, COUNT(*) OVER () AS total_rows
    FROM bho_mh
) AS subquery
WHERE row_num IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2));

-- Mode
SELECT Denominator AS MODES
FROM bho_mh
GROUP BY Denominator
ORDER BY COUNT(*) DESC
LIMIT 1;

-- SUMMING THE DATE RATE YEAR FROM 2014 FOR EACH REGION
SELECT `OMH Region`, ROUND(SUM(`Year to Date Rate`),2) AS SUM_2014
FROM bho_mh
WHERE `Year` = 2014
GROUP BY `OMH Region`
ORDER BY SUM_2014 DESC;

-- COUNTING THE QUANTITY OF ADULTS
SELECT COUNT(*) AS ADULT_COUNT
FROM bho_mh
WHERE `Age Group` = 'Adult';

-- FINDING THE MEDIA OF YEAR TO DATO FOR EVERY QUARTER
SELECT `Quarter`, ROUND(AVG(`Year to Date Rate`),2) AS MEDIA
FROM bho_mh 
GROUP BY `Quarter`
HAVING MEDIA> 25
ORDER BY MEDIA DESC;


-- Average Rate = 35,75
SELECT ROUND(AVG(Rate), 2) FROM bho_mh;

-- SHOWING THE AVERAGE FOR EACH REGION, AND IF IT'S MORE THAN THE GENERAL AVERAGE
SELECT 
    `OMH Region`,
    ROUND(AVG(Rate), 2) AS MEDIA_CITY,
    CASE
        WHEN ROUND(AVG(Rate), 2) > (SELECT ROUND(AVG(Rate), 2) FROM bho_mh) THEN 'YES'
        ELSE 'NO'
    END AS 'IS MORE?',
    CASE
        WHEN ROUND(AVG(Rate), 2) > (SELECT ROUND(AVG(Rate), 2) FROM bho_mh) THEN ROUND(ROUND(AVG(Rate), 2) - (SELECT ROUND(AVG(Rate), 2) FROM bho_mh),2)
        ELSE NULL
    END AS 'DIFFERENCE'
FROM 
    bho_mh
GROUP BY 
    `OMH Region`;

