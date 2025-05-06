---------------------------------------- window functions ----------------------------------------
select *, max(disp) over () as max_disp
from learn.dbo.mtcars

-- partition by: apply a function over a partition of data
select *, max(disp) over (partition by cyl) as max_disp
from learn.dbo.mtcars

---------------------------------------- rownum ----------------------------------------
-- add row number: order by is mandatory in over()
-- rownum has no duplicates, and is continous (no gaps)
select *, row_number() over (order by cyl, mpg) as rownum
from learn.dbo.mtcars

-- row_number() + "partition by". "partition by" first, "order by" next
select *, row_number() over (partition by cyl order by mpg)  as rownum
from learn.dbo.mtcars

-- rownum in exact order of observations, without any ordering by
-- not "order by 1", use "order by (select 1)"
select ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS sl_no, *
from learn.dbo.mtcars;




---------------------------------------- rank ----------------------------------------
-- rank: 1,2,3,3,5,6,7,8,8,10,11
-- rank has duplicates, and is not continous (has gaps)
-- partition by optional, order by mandatory
select *, rank() over (partition by cyl order by mpg) as mpg_rank
from learn.dbo.mtcars

-- dense_rank: 1,2,3,3,4,5,6,7,7,8,9 - continous
-- dense_rank has duplicates, and is continous (no gaps)
select *, dense_rank() over (partition by cyl order by mpg) as mpg_rank
from learn.dbo.mtcars

-- rank/dense_rank/row_number using multiple columns
select *, dense_rank() over (partition by cyl order by mpg, disp) as mpg_disp_rank
from learn.dbo.mtcars

-- some example: top 3 rows within each cyl (when ordered by drat & disp)
with temp as (
	select *, rank() over (partition by cyl  order by drat, disp) as drat_rank
	from learn.dbo.mtcars
)
select * from temp 
where drat_rank < 4



--------------------------------------  window aggregation frame=Rows --------------------------------------  
-- select *, window_function() over (parition by __ order by __ window_frame) as newcol 
-- from my_table

-- default window frame: without order by: rows between unbounded preceeding and unbounded following
select *, sum(hp) over ()				from learn.dbo.mtcars

-- default window frame: with order by: range between unbounded preceeding and current row
select *, sum(hp) over (order by carb)	from learn.dbo.mtcars

-- rows / range / groups between lower_bound and upper_bound (not between upper_bound and lower_bound)
-- lower/upper bound: unbounded preceding, n preceding, current row, n following, unbounded following
-- unbounded preceding includes current row

-- rows between 1 preceeding and 1 following
-- window is previous 1 row + current row + following 1 row

-- top row through previous row
select cyl, mpg, wt, vs, 
sum(vs) over (order by cyl, mpg, wt rows between unbounded preceding and 1 preceding) as sum_vs
from learn.dbo.mtcars

-- top row through current row
select cyl, mpg, wt,
sum(vs) over (order by cyl, mpg, wt) as sum_vs
from learn.dbo.mtcars
-- same as 
select cyl, mpg, wt, vs, 
sum(vs) over (order by cyl, mpg, wt rows unbounded preceding) as sum_vs
from learn.dbo.mtcars
-- same as 
select cyl, mpg, wt, vs, 
sum(vs) over (order by cyl, mpg, wt rows between unbounded preceding and current row) as sum_vs
from learn.dbo.mtcars

-- top row through current row through next 1 row
select cyl, mpg, wt, vs, 
sum(vs) over (order by cyl, mpg, wt rows between unbounded preceding and 1 following) as sum_vs
from learn.dbo.mtcars

-- top row through current row through bottom
select cyl, mpg, wt, vs, 
sum(vs) over (order by cyl, mpg, wt rows between unbounded preceding and unbounded following) as sum_vs
from learn.dbo.mtcars
-- same as 
select cyl, mpg, wt, vs, 
sum(vs) over () as sum_vs
from learn.dbo.mtcars

-- 3 previous rows through 1 previous row
-- avg(vs) gives wrong values
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between 3 preceding and 1 preceding) as sum_vs
from learn.dbo.mtcars

-- 3 previous rows through current row
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between 3 preceding and current row) as sum_vs
from learn.dbo.mtcars

-- 3 previous rows through current row through next 2 rows
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between 3 preceding and 2 following) as sum_vs
from learn.dbo.mtcars

-- 3 previous rows through current row through botton row
-- ordering got messed up
-- Solution order it back or use large following rows
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between 3 preceding and unbounded following) as sum_vs
from learn.dbo.mtcars
order by cyl, mpg, wt;
-- same as 
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between 3 preceding and 2147483647 following) as sum_vs
from learn.dbo.mtcars

-- current row through next 2 rows
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between current row and 2 following) as sum_vs
from learn.dbo.mtcars

-- current row through bottom
-- final ordering got messed up
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between current row and unbounded following) as sum_vs
from learn.dbo.mtcars
-- solution 1: order it back to desired order
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between current row and unbounded following) as sum_vs
from learn.dbo.mtcars
order by cyl, mpg, wt
-- solution 2: use a large number for following row count
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between current row and 2147483647 following) as sum_vs
from learn.dbo.mtcars

-- next row through next 3 rows
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between 1 following and 3 following) as sum_vs
from learn.dbo.mtcars

-- next row through bottom rows
-- bad ordering: same 2 solutions
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between 1 following and unbounded following) as sum_vs
from learn.dbo.mtcars
order by cyl, mpg, wt
-- same as 
select cyl, mpg, wt, vs,
	sum(vs) over (order by cyl, mpg, wt rows between 1 following and 2147483647 following) as sum_vs
from learn.dbo.mtcars
order by cyl, mpg, wt

--------------------------------------  window aggregation frame=Range --------------------------------------  
-- current row has month=4. So window is month=3 + month=4 + month=5
-- RANGE is only supported with UNBOUNDED and CURRENT ROW window frame delimiters.
-- n preceding or n following not allowed
-- perhaps allowed in postgres
-- select carb, vs,
-- 	sum(vs) over (order by carb range between unbounded preceding and 1 following) as sum_vs
-- from learn.dbo.mtcars

-- unbounded preceding and current row
select carb, vs,
	sum(vs) over (order by carb range between unbounded preceding and current row) as sum_vs
from learn.dbo.mtcars

-- unbounded current row and following
select carb, vs,
	sum(vs) over (order by carb range between current row and unbounded following) as sum_vs
from learn.dbo.mtcars
order by carb

-- unbounded preceding and unbounded following
select carb, vs,
	sum(vs) over (order by carb range between unbounded preceding and unbounded following) as sum_vs
from learn.dbo.mtcars
order by carb


--------------------------------------  window aggregation frame=groups --------------------------------------  
-- groups between 1 preceeding and 1 following
-- month contains 1, 2, 4 (current row), 5
-- current row has month=4. So window is month=2 + month=4 + month=5
-- groups in postgres only. groups keyword not even recognised by mySQL

-- select carb, vs,
-- 	sum(vs) over (order by carb groups between unbounded preceding and unbounded following) as sum_vs
-- from learn.dbo.mtcars
-- order by carb
















---------------------------------------- functions ----------------------------------------
-- Aggregate functions: 
-- avg(), count(), min(), max(), sum()

-- Ranking functions: 
-- rank(), dense_rank(), row_number()

-- Analytic functions: 
-- lead(), lag(), ntile(), first_value(), last_value(), nth_value()

---------------------------- lead and lag ---------------------------- 
-- lead or lead(1): 1 NULL value in the end
-- The function 'lag' must have an OVER clause.
-- use all the leading values
-- over(order by) - mandatory template
select cyl, mpg, wt, disp,
	lead(disp) over (order by cyl, mpg, wt) as lead_disp
from learn.dbo.mtcars
-- same as 
select cyl, mpg, wt, disp,
	lead(disp, 1) over (order by cyl, mpg, wt) as lead_disp
from learn.dbo.mtcars

-- lead or lead(2): 2 NULL values in the end
select cyl, mpg, wt, disp,
	lead(disp, 2) over (order by cyl, mpg, wt) as lead_disp
from learn.dbo.mtcars

-- lag or lag(1): 1 NULL value in the end
-- use all the lagging values
-- over(order by) - mandatory template
select cyl, mpg, wt, disp,
	lag(disp) over (order by cyl, mpg, wt) as lag_disp
from learn.dbo.mtcars
-- same as 
select cyl, mpg, wt, disp,
	lag(disp, 1) over (order by cyl, mpg, wt) as lag_disp
from learn.dbo.mtcars

-- lead or lead(2): 2 NULL values in the end
select cyl, mpg, wt, disp,
	lag(disp, 2) over (order by cyl, mpg, wt) as lag_disp
from learn.dbo.mtcars

---------------------------- first_value ---------------------------- 
-- over(order by) mandatory components
select cyl, mpg, wt, disp,
	first_value(disp) over (order by cyl, mpg, wt) as first_disp
from learn.dbo.mtcars

select cyl, mpg, wt, disp,
	first_value(disp) over (partition by cyl order by cyl, mpg, wt) as first_disp
from learn.dbo.mtcars

---------------------------- last_value ---------------------------- 
-- over(order by) mandatory components
-- not working? order by also paritions by?
select cyl, mpg, wt, disp,
	last_value(disp) over (partition by cyl order by cyl, mpg, wt) as last_disp
from learn.dbo.mtcars

select cyl, mpg, wt, disp,
	last_value(disp) over (partition by cyl order by cyl, mpg, wt) as last_disp
from learn.dbo.mtcars

---------------------------- nth_value ---------------------------- 
-- not in mysql?




