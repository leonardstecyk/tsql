/*
when working with a 445 or 52/53 week fiscal structure and building out a calendar we have to instantiate some logic that will be used later when building the calendar
we do this by setting up an object for the years, periods, and weeks.  the qtrly logic will persist in each subset structure
you can do this with ctes, tables, or temp tables.  here i'm opting for ctes

a little more on the 445 logic.  let's suppose that fiscal weeks always end on a saturday, 
and a fiscal year ends on the last saturday of the year.
*/

DECLARE @start_date DATE = '2019-12-29'
 ,@year_num_stop INT = 2050
 ,@end_of_week_day VARCHAR(9) = 'Saturday';

-- SHOULD WE DO A SANITY CHECK FIRST BASED ON YOUR VARIABLES!!!
IF DATENAME(WEEKDAY, DATEADD(dd, -1, @start_date)) <> @end_of_week_day
    BEGIN
        PRINT 'check your variables!'
    END
ELSE PRINT 'All good'



;WITH cte_fiscal_qtrs
AS
    (
        SELECT fiscal_year_days_num, fiscal_qtr_num, fiscal_qtr_days_num, rt_qtr_days_num, fiscal_qtr_total_weeks_num
        FROM (
        VALUES    (364, 1, 91, 91, 13)
                , (364, 2, 91, 182, 13)
                , (364, 3, 91, 273, 13)
                , (364, 4, 91, 364, 13)
                , (371, 1, 91, 91, 13)
                , (371, 2, 91, 182, 13)
                , (371, 3, 91, 273, 13)
                , (371, 4, 98, 371, 14)) AS q(fiscal_year_days_num, fiscal_qtr_num, fiscal_qtr_days_num, rt_qtr_days_num, fiscal_qtr_total_weeks_num)
    )

, cte_fiscal_periods 
    AS
        (
            SELECT fiscal_year_days_num, fiscal_period_num, fiscal_period_days_num, rt_period_days_num, fiscal_qtr_num, fiscal_period_weeks_num
            FROM (
                VALUES    (364, 1, 28, 28, 1, 4)
                        , (364, 2, 28, 56, 1, 4)
                        , (364, 3, 35, 91, 1, 5)
                        , (364, 4, 28, 119, 2, 4)
                        , (364, 5, 28, 147, 2, 4)
                        , (364, 6, 35, 182, 2, 5)
                        , (364, 7, 28, 210, 3, 4)
                        , (364, 8, 28, 238, 3, 4)
                        , (364, 9, 35, 273, 3, 5)
                        , (364, 10, 28, 301, 4, 4)
                        , (364, 11, 28, 329, 4, 4)
                        , (364, 12, 35, 364, 4, 5)
                        , (371, 1, 28, 28, 1, 4)
                        , (371, 2, 28, 56, 1, 4)
                        , (371, 3, 35, 91, 1, 5)
                        , (371, 4, 28, 119, 2, 4)
                        , (371, 5, 28, 147, 2, 4)
                        , (371, 6, 35, 182, 2, 5)
                        , (371, 7, 28, 210, 3, 4)
                        , (371, 8, 28, 238, 3, 4)
                        , (371, 9, 35, 273, 3, 5)
                        , (371, 10, 28, 301, 4, 4)
                        , (371, 11, 35, 336, 4, 5)
                        , (371, 12, 35, 371, 4, 5)) AS p(fiscal_year_days_num, fiscal_period_num, fiscal_period_days_num, rt_period_days_num, fiscal_qtr_num, fiscal_period_weeks_num)
        )
            

, cte_fiscal_weeks
    AS
        (
            SELECT fiscal_year_days_num, fiscal_week, rt_fiscal_week_days, fiscal_period_num
            FROM (
                    VALUES    (364, 1, 7, 1)
                            , (364, 2, 14, 1)
                            , (364, 3, 21, 1)
                            , (364, 4, 28, 1)
                            , (364, 5, 35, 2)
                            , (364, 6, 42, 2)
                            , (364, 7, 49, 2)
                            , (364, 8, 56, 2)
                            , (364, 9, 63, 3)
                            , (364, 10, 70, 3)
                            , (364, 11, 77, 3)
                            , (364, 12, 84, 3)
                            , (364, 13, 91, 3)
                            , (364, 14, 98, 4)
                            , (364, 15, 105, 4)
                            , (364, 16, 112, 4)
                            , (364, 17, 119, 4)
                            , (364, 18, 126, 5)
                            , (364, 19, 133, 5)
                            , (364, 20, 140, 5)
                            , (364, 21, 147, 5)
                            , (364, 22, 154, 6)
                            , (364, 23, 161, 6)
                            , (364, 24, 168, 6)
                            , (364, 25, 175, 6)
                            , (364, 26, 182, 6)
                            , (364, 27, 189, 7)
                            , (364, 28, 196, 7)
                            , (364, 29, 203, 7)
                            , (364, 30, 210, 7)
                            , (364, 31, 217, 8)
                            , (364, 32, 224, 8)
                            , (364, 33, 231, 8)
                            , (364, 34, 238, 8)
                            , (364, 35, 245, 9)
                            , (364, 36, 252, 9)
                            , (364, 37, 259, 9)
                            , (364, 38, 266, 9)
                            , (364, 39, 273, 9)
                            , (364, 40, 280, 10)
                            , (364, 41, 287, 10)
                            , (364, 42, 294, 10)
                            , (364, 43, 301, 10)
                            , (364, 44, 308, 11)
                            , (364, 45, 315, 11)
                            , (364, 46, 322, 11)
                            , (364, 47, 329, 11)
                            , (364, 48, 336, 12)
                            , (364, 49, 343, 12)
                            , (364, 50, 350, 12)
                            , (364, 51, 357, 12)
                            , (364, 52, 364, 12)
                            , (371, 1, 7, 1)
                            , (371, 2, 14, 1)
                            , (371, 3, 21, 1)
                            , (371, 4, 28, 1)
                            , (371, 5, 35, 2)
                            , (371, 6, 42, 2)
                            , (371, 7, 49, 2)
                            , (371, 8, 56, 2)
                            , (371, 9, 63, 3)
                            , (371, 10, 70, 3)
                            , (371, 11, 77, 3)
                            , (371, 12, 84, 3)
                            , (371, 13, 91, 3)
                            , (371, 14, 98, 4)
                            , (371, 15, 105, 4)
                            , (371, 16, 112, 4)
                            , (371, 17, 119, 4)
                            , (371, 18, 126, 5)
                            , (371, 19, 133, 5)
                            , (371, 20, 140, 5)
                            , (371, 21, 147, 5)
                            , (371, 22, 154, 6)
                            , (371, 23, 161, 6)
                            , (371, 24, 168, 6)
                            , (371, 25, 175, 6)
                            , (371, 26, 182, 6)
                            , (371, 27, 189, 7)
                            , (371, 28, 196, 7)
                            , (371, 29, 203, 7)
                            , (371, 30, 210, 7)
                            , (371, 31, 217, 8)
                            , (371, 32, 224, 8)
                            , (371, 33, 231, 8)
                            , (371, 34, 238, 8)
                            , (371, 35, 245, 9)
                            , (371, 36, 252, 9)
                            , (371, 37, 259, 9)
                            , (371, 38, 266, 9)
                            , (371, 39, 273, 9)
                            , (371, 40, 280, 10)
                            , (371, 41, 287, 10)
                            , (371, 42, 294, 10)
                            , (371, 43, 301, 10)
                            , (371, 44, 308, 11)
                            , (371, 45, 315, 11)
                            , (371, 46, 322, 11)
                            , (371, 47, 329, 11)
                            , (371, 48, 336, 11)
                            , (371, 49, 343, 12)
                            , (371, 50, 350, 12)
                            , (371, 51, 357, 12)
                            , (371, 52, 364, 12)
                            , (371, 53, 371, 12)) AS w(fiscal_year_days_num, fiscal_week, rt_fiscal_week_days, fiscal_period_num)
            )       
, tally(n)
    AS
        (
            -- expand if you need to - this will give you 13,824 records
			-- the query execution plan will be misleading here... i promise it's efficient - plan goes sideways on (SELECT(NULL)) in the ORDER BY of the ROW_NUMBER
			SELECT ROW_NUMBER() OVER(ORDER BY (SELECT (NULL)))-1 
			FROM (VALUES(0),(0),(0),(0),(0),(0),(0),(0)) AS a(n) -- x8 rows
			CROSS JOIN (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS b(n) -- x12 rows
			CROSS JOIN (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS c(n) -- x12 rows
			CROSS JOIN (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS d(n) -- x12 rows
			-- if you need more records copy the cross join and give it an alias of e(n)  
	    )

-- this is how we get the fiscal year baselines - start and end
, cte_fiscal_years
    AS
        (
            SELECT 
            YEAR(MAX(Date)) AS fiscal_year_num
            , DATEDIFF(DD, DATEADD(DD, -6, MIN(Date)), MAX(Date)) + 1 as fiscal_year_days_num
            , DATEADD(DD, -6, MIN(Date))  AS fiscal_start_date
            , MAX(Date) AS fiscal_end_date
            FROM (
            		SELECT DATEADD(DD, n, @start_date) AS date
            		, DATENAME(WEEKDAY, DATEADD(DD, n, @start_date)) AS week_day_name
            		, YEAR(DATEADD(DD, n, @start_date)) AS year_num
            		FROM tally
                  ) dates
            WHERE week_day_name = @end_of_week_day AND year_num <= @year_num_stop
            GROUP BY year_num
        )
-- SELECT * FROM cte_fy_base ORDER BY fiscal_year
, cte_cal_structure
    AS
        (
 			SELECT yrs.fiscal_year_num
			, yrs.fiscal_start_date
			, yrs.fiscal_end_date
			, yrs.fiscal_year_days_num
			
			, qtr.fiscal_qtr_num
			, qtr.fiscal_qtr_days_num
			, DATEADD(DD, LEAD(qtr.rt_qtr_days_num - qtr.fiscal_qtr_days_num, 0, qtr.rt_qtr_days_num) OVER(ORDER BY yrs.fiscal_year_num, weeks.fiscal_week), yrs.fiscal_start_date) AS qtr_start_date
			, DATEADD(DD, qtr.rt_qtr_days_num - 1, yrs.fiscal_start_date) AS qtr_end_date
			, ROW_NUMBER() OVER(PARTITION BY yrs.fiscal_year_num, prds.fiscal_qtr_num ORDER BY yrs.fiscal_year_num, weeks.fiscal_week) AS fiscal_qtr_week_num
			, qtr.fiscal_qtr_total_weeks_num

			, prds.fiscal_period_num
			, prds.fiscal_period_days_num
			, DATEADD(DD, LEAD(prds.rt_period_days_num - prds.fiscal_period_days_num, 0, prds.rt_period_days_num) OVER(ORDER BY yrs.fiscal_year_num, weeks.fiscal_week), yrs.fiscal_start_date) AS period_start_date
			, DATEADD(DD, prds.rt_period_days_num - 1, yrs.fiscal_start_date) AS period_end_date
			, prds.fiscal_period_weeks_num
			, ROW_NUMBER() OVER(PARTITION BY yrs.fiscal_year_num, prds.fiscal_period_num ORDER BY yrs.fiscal_year_num, weeks.fiscal_week) AS fiscal_week_period_num
			
			, weeks.fiscal_week
			, DATEADD(DD, LEAD(weeks.rt_fiscal_week_days - 7, 0, weeks.rt_fiscal_week_days) OVER(ORDER BY yrs.fiscal_year_num, weeks.fiscal_week), yrs.fiscal_start_date) AS week_start_date
			, DATEADD(DD, weeks.rt_fiscal_week_days - 1, yrs.fiscal_start_date) AS week_end_date
			FROM cte_fiscal_years as yrs
				INNER JOIN cte_fiscal_qtrs as qtr
					ON yrs.fiscal_year_days_num = qtr.fiscal_year_days_num
				INNER JOIN cte_fiscal_periods as prds
					ON qtr.fiscal_year_days_num = prds.fiscal_year_days_num
					AND qtr.fiscal_qtr_num = prds.fiscal_qtr_num
				INNER JOIN cte_fiscal_weeks as weeks
					ON prds.fiscal_year_days_num = weeks.fiscal_year_days_num
					AND prds.fiscal_period_num = weeks.fiscal_period_num
        )
-- SELECT * FROM cte_cal_structure


SELECT  FORMAT(DATEADD(DD, tally.n, @start_date), 'yyyyMMdd') AS date_key
, DATEADD(DD, tally.n, @start_date) AS date

-- we'll update these later with a series of UPDATE statements in a stored procedure
, 0 AS is_calendar_holiday
, 0 AS is_company_holiday
, 0 AS is_mfg_holiday

, FORMAT(DATEADD(DD, tally.n, @start_date), 'dddd, MMMM dd, yyyy') AS date_name_long
, FORMAT(DATEADD(DD, tally.n, @start_date), 'MMM dd, yyyy') AS date_name_short
, tally.n+1 AS rolling_index

, YEAR(DATEADD(DD, n, @start_date)) AS year_num
, ROW_NUMBER() OVER(PARTITION BY YEAR(DATEADD(DD, n, @start_date)) ORDER BY tally.n+1) AS year_day_num
, CAST(ROW_NUMBER() OVER(PARTITION BY YEAR(DATEADD(DD, n, @start_date)) ORDER BY tally.n+1) AS NUMERIC(6,3)) / DATEDIFF(DAY, DATEFROMPARTS(YEAR(DATEADD(DD, tally.n, @start_date)), 1, 1), DATEFROMPARTS(YEAR(DATEADD(DD, tally.n, @start_date)) + 1,1,1)) AS year_day_rate
, DATEDIFF(DAY, DATEFROMPARTS(YEAR(DATEADD(DD, tally.n, @start_date)), 1, 1), DATEFROMPARTS(YEAR(DATEADD(DD, tally.n, @start_date)) + 1,1,1)) AS year_total_days_num

, DATEPART(QUARTER, DATEADD(DD, tally.n, @start_date)) AS qtr_num
, DATEPART(WK, DATEADD(DD,tally.n, @start_date)) - DATEPART(WK, DATEADD(QQ, DATEDIFF(QQ, 0, DATEADD(DD, tally.n, @start_date)), 0)) + 1 AS qtr_week_num
, DATEDIFF(DAY, DATEADD(Q, DATEDIFF(Q, 0, DATEADD(DD, tally.n, @start_date)), 0), DATEADD(DD, tally.n, @start_date)) + 1  AS qtr_day_num
, CAST(DATEDIFF(DAY, DATEADD(QUARTER, DATEDIFF(QUARTER, 0,DATEADD(DD, n, @start_date)), 0), DATEADD(DD, n, @start_date)) + 1 AS NUMERIC(6,3)) / DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, DATEADD(DD, tally.n, @start_date)),0), DATEADD(QQ, DATEDIFF(QQ,0, DATEADD(DD, tally.n, @start_date)) + 1,0)) AS qtr_day_rate
, DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, DATEADD(DD, tally.n, @start_date)),0), DATEADD(QQ, DATEDIFF(QQ,0, DATEADD(DD, tally.n, @start_date)) + 1,0)) AS qtr_total_days_num

, MONTH(DATEADD(DD, tally.n, @start_date)) AS month_num
, DATENAME(MM, DATEADD(DD, tally.n, @start_date)) AS month_name_long
, LEFT(DATENAME(MM, DATEADD(DD, tally.n, @start_date)), 3) AS month_name_short
, DATEPART(WK, DATEADD(DD,tally.n, @start_date)) - DATEPART(WK, DATEADD(MM, DATEDIFF(MM, 0, DATEADD(DD, tally.n, @start_date)), 0)) + 1 AS month_week_num
, DATEPART(DD, DATEADD(DD, tally.n, @start_date)) AS month_day_num
, CAST(DATEPART(DD, DATEADD(DD ,tally.n, @start_date)) AS NUMERIC(6,3)) / DATEPART(DD, EOMONTH(DATEADD(DD,tally.n, @start_date))) AS month_day_rate
, DATEPART(DD, EOMONTH(DATEADD(DD, tally.n, @start_date))) AS month_total_days_num
, EOMONTH(DATEADD(DD, tally.n, @start_date)) AS month_end_date

, DATEPART(wk, DATEADD(DD, tally.n, @start_date)) AS week_num
, DATEPART(dw, DATEADD(DD, tally.n, @start_date)) AS week_day_num
, DATENAME(WEEKDAY, DATEADD(DD, n, @start_date)) AS week_day_name_long
, LEFT(DATENAME(WEEKDAY, DATEADD(DD, n, @start_date)), 3) AS week_day_name_short

, cal.fiscal_year_num
, ROW_NUMBER() OVER(PARTITION BY cal.fiscal_year_num ORDER BY tally.n) AS fiscal_year_day_num
, CAST(ROW_NUMBER() OVER(PARTITION BY cal.fiscal_year_num ORDER BY tally.n) AS NUMERIC(6,3)) / cal.fiscal_year_days_num AS fiscal_year_day_rate
, cal.fiscal_year_days_num AS fiscal_year_total_days_num
, CASE WHEN cal.fiscal_year_days_num = 364 THEN 52 WHEN cal.fiscal_year_days_num = 371 THEN 53 END AS fiscal_year_total_weeks_num

, cal.fiscal_qtr_num
, ROW_NUMBER() OVER(PARTITION BY cal.fiscal_year_num, cal.fiscal_qtr_num ORDER BY tally.n) AS fiscal_qtr_day_num
, CAST(ROW_NUMBER() OVER(PARTITION BY cal.fiscal_year_num, cal.fiscal_qtr_num ORDER BY tally.n) AS NUMERIC(6,3)) / cal.fiscal_qtr_days_num AS fiscal_qtr_day_rate
, cal.fiscal_qtr_days_num AS fiscal_qtr_total_days_num
, cal.fiscal_qtr_week_num AS fiscal_qtr_week_num
, cal.fiscal_qtr_total_weeks_num AS fiscal_qtr_total_weeks_num

, cal.fiscal_period_num
, ROW_NUMBER() OVER(PARTITION BY cal.fiscal_year_num, cal.fiscal_period_num ORDER BY tally.n) AS fiscal_period_day_num
, CAST(ROW_NUMBER() OVER(PARTITION BY cal.fiscal_year_num, cal.fiscal_period_num ORDER BY tally.n) AS NUMERIC(6,3)) / cal.fiscal_period_days_num AS fiscal_period_day_rate
, cal.fiscal_period_days_num AS fiscal_period_total_days_num
, cal.fiscal_week_period_num AS fiscal_period_week_num
, cal.fiscal_period_weeks_num AS fiscal_period_total_weeks_num
, cal.period_end_date AS fiscal_period_end_date

, cal.fiscal_week AS fiscal_week_num
, ROW_NUMBER() OVER(PARTITION BY cal.fiscal_year_num, cal.fiscal_week ORDER BY tally.n) AS fiscal_week_day_num
, CAST(CAST(cal.fiscal_year_num AS CHAR(4)) + REPLICATE('0', 2-LEN(cal.fiscal_week)) + CAST(cal.fiscal_week AS VARCHAR(2)) AS INT) AS fiscal_yyyyww
FROM tally as tally
	INNER JOIN cte_cal_structure as cal
		ON DATEADD(DD, n, @start_date) BETWEEN cal.week_start_date and cal.week_end_date
ORDER BY date;