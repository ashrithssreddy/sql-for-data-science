---------------------------------------- system dates ----------------------------------------
SELECT 
	CURRENT_TIMESTAMP as time_now,
	GETDATE() as date_now,
	day(GETDATE()) as day_now,
	month(GETDATE()) as month_now,
	year(GETDATE()) as year_now

SELECT 
	CURRENT_TIMESTAMP AS CURRENT_TIMESTAMP1,
	GETDATE() AS GETDATE1,
	SYSDATETIME() AS SYSDATETIME1 -- far more detailed

---------------------------------------- date format ----------------------------------------
-- mm/dd/yyyy is default. Else specifiy the format.
SELECT CAST('12/31/2019' as date) as StringToDate

---------------------------------------- date add ----------------------------------------
SELECT DATEADD(year, 1, CURRENT_TIMESTAMP) AS DateAdd;
SELECT DATEADD(month, 1, CURRENT_TIMESTAMP) AS DateAdd;
SELECT DATEADD(day, 1, CURRENT_TIMESTAMP) AS DateAdd;
SELECT DATEADD(day, 365, CURRENT_TIMESTAMP) AS DateAdd;

SELECT DATEADD(day, 365, '2017/08/25') AS DateAdd; -- adds 365 days

SELECT CURRENT_TIMESTAMP +  10 AS DateAdd; -- adds 10 days
SELECT CURRENT_TIMESTAMP -  10 AS DateSub;

---------------------------------------- diff between 2 dates ----------------------------------------
SELECT DATEDIFF(day, '2017/08/25', '2011/08/25') AS DateDiff; -- second minus first