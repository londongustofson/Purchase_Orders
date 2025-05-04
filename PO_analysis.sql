/*CREATE table PO_DataNew(

Programs Varchar2(50), 
Time_PO_inputted_on_sheet TIMESTAMP,
First_level_review VARCHAR2(50),
Time_first_approval TIMESTAMP, 
Second_level_review VARCHAR2(50),
Time_second_approval TIMESTAMP, 
Third_level_review VARCHAR2(50), 
Time_PO_Signed TIMESTAMP, 
PO_approval_time TIMESTAMP);*/

-- creating synonym for table name--
create synonym pos for PO_DataNew;

--1. Which program has the highest number of purchase orders?
select COUNT(*) as total_pos, programs
FROM pos
GROUP BY programs
ORDER BY total_pos DESC;

--2. Which programs have the most amount of RUSH purchase orders?
SELECT
  programs,
  SUM((LENGTH(programs) - LENGTH(REPLACE(programs, '(R)', ''))) / LENGTH('(R)')) AS total_rush_pos
FROM
  pos
GROUP BY
  programs
HAVING
  SUM((LENGTH(programs) - LENGTH(REPLACE(programs, '(R)', ''))) / LENGTH('(R)')) > 0
ORDER BY total_rush_pos DESC
FETCH FIRST 5 ROWS ONLY;

--3.What is the processing time for each program from first approval pass to the second approval pass?
SELECT 
    PROGRAMS,
    TIME_FIRST_APPROVAL,
    TIME_SECOND_APPROVAL,
    TIME_SECOND_APPROVAL - TIME_FIRST_APPROVAL AS TIME_BETWEEN_APPROVALS
FROM 
    pos
ORDER BY 
    PROGRAMS;

--4. What is the average time lenth of approval from first level to second level?
SELECT 
    PROGRAMS,
    TRUNC(AVG(CAST(TIME_SECOND_APPROVAL AS DATE) - CAST(TIME_FIRST_APPROVAL AS DATE))) AS AVG_DAYS,
    TRUNC(MOD(AVG((CAST(TIME_SECOND_APPROVAL AS DATE) - CAST(TIME_FIRST_APPROVAL AS DATE)) * 1440), 1440)) AS AVG_MINUTES
FROM 
    pos
GROUP BY 
    PROGRAMS
ORDER BY 
    PROGRAMS;

--5. Which purchase orders take the most amount of time on average to be fully processed?
SELECT 
    PROGRAMS,
    TRUNC(AVG(CAST(PO_APPROVAL_TIME AS DATE) - CAST(TIME_PO_INPUTTED_ON_SHEET AS DATE))) AS AVG_DAYS,
    TRUNC(MOD(AVG((CAST(PO_APPROVAL_TIME AS DATE) - CAST(TIME_PO_INPUTTED_ON_SHEET AS DATE)) * 1440), 1440)) AS AVG_MINUTES
FROM 
    pos
GROUP BY 
    PROGRAMS
ORDER BY 
    AVG(CAST(PO_APPROVAL_TIME AS DATE) - CAST(TIME_PO_INPUTTED_ON_SHEET AS DATE)) DESC;
    

--6. How many purchase orders were processed per month?
SELECT
  COUNT(CASE WHEN EXTRACT(MONTH FROM TIME_PO_SIGNED) = 1 THEN 1 END) AS January,
  COUNT(CASE WHEN EXTRACT(MONTH FROM TIME_PO_SIGNED) = 2 THEN 1 END) AS February,
  COUNT(CASE WHEN EXTRACT(MONTH FROM TIME_PO_SIGNED) = 3 THEN 1 END) AS March
FROM pos
WHERE EXTRACT(YEAR FROM TIME_PO_SIGNED) = 2025;

--7. How may rush purchase orders were there per month?
SELECT
    COUNT(CASE WHEN EXTRACT(MONTH FROM TIME_PO_SIGNED) = 1 AND PROGRAMS LIKE '%R%' THEN 1 END) AS January_Rush,
    COUNT(CASE WHEN EXTRACT(MONTH FROM TIME_PO_SIGNED) = 2 AND PROGRAMS LIKE '%R%' THEN 1 END) AS February_Rush,
    COUNT(CASE WHEN EXTRACT(MONTH FROM TIME_PO_SIGNED) = 3 AND PROGRAMS LIKE '%R%' THEN 1 END) AS March_Rush
FROM pos;

--8. How many rush purchase orders per month by programs were there?
SELECT
  PROGRAMS,
  COUNT(CASE WHEN EXTRACT(MONTH FROM TIME_PO_SIGNED) = 1 THEN 1 END) AS JANUARY,
  COUNT(CASE WHEN EXTRACT(MONTH FROM TIME_PO_SIGNED) = 2 THEN 1 END) AS FEBRUARY,
  COUNT(CASE WHEN EXTRACT(MONTH FROM TIME_PO_SIGNED) = 3 THEN 1 END) AS MARCH
FROM pos
WHERE UPPER(PROGRAMS) LIKE '%R%'
  AND EXTRACT(YEAR FROM TIME_PO_SIGNED) = 2025
GROUP BY PROGRAMS
ORDER BY JANUARY DESC;

--9. What is the rush percentage of purchase orders?
SELECT 
  ROUND(
    COUNT(CASE WHEN UPPER(PROGRAMS) LIKE '%R%' THEN 1 END) * 100.0 / COUNT(*),
    2
  ) AS RUSH_PO_PERCENTAGE
FROM pos;
  select * from pos;
  
UDPATE all programs name to something else like Program A, Program B...
-- FILE PATH FOR TERMINAL 
cd C:\
cd app
cd londo
cd product
cd 18.0.0
cd dbhomeXE
cd "SQL Files"