---------------------------------------- mutate ----------------------------------------
-- new col
select *, vs+100 as vs_new
from learn.dbo.mtcars

-- new column from existing columns
select *, disp/drat as blah
from learn.dbo.mtcars

-- update existing column?
select *, vs*100 as vs
from learn.dbo.mtcars

---------------------------------------- select ----------------------------------------
-- duplicates columns allowed
select vs, am, *
from learn.dbo.mtcars 

---------------------------------------- filter ----------------------------------------
-- filter based on multiple conditions
select *
from learn.dbo.mtcars 
where cyl > 3 and cyl < 7

-- between a and b - [a, b] both a and b included
select *
from learn.dbo.mtcars 
where cyl between 4 and 7

---------------------------------------- filter using nested subquery ----------------------------------------
-- --https://www.geeksforgeeks.org/sql-correlated-subqueries/

-- nested subquery is executed once and used by outer query
-- e.g. Select employees making salary above the average
-- select * from employees where salary > (select avg(salary) from employees)
select * from learn.dbo.mtcars 
where mpg > 
	(select avg(mpg) from learn.dbo.mtcars)

---------------------------------------- filter using correlated subquery ----------------------------------------
-- correlated subquery (different from nested subsquery)
-- subquery is executed for each row of parent table
-- select * from employees o where salary > (select avg(salary) from employees where dept=o.dept)
select cyl, avg(mpg) as avg_mpg from 
learn.dbo.mtcars
group by cyl

select * from learn.dbo.mtcars o
where mpg > 
	(select avg(mpg) from learn.dbo.mtcars where cyl=o.cyl)

-- exist -- part of correlated subquery
-- exists is evaluated for all the records of mtcars
-- for each record in mtcars, exists (select 1) is evaluated. Evaluation returns 1-row, 1-column table
-- therefore, final output contains whole table

-- The EXISTS operator tests for existence of rows in the results set of the subquery. 
-- If a subquery row value is found the condition is flagged TRUE and the search does not continue in the inner query, 
-- and if it is not found then the condition is flagged FALSE and the search continues in the inner query.
select * from learn.dbo.mtcars
where
exists (
select 1
) -- all rows returned

select * from learn.dbo.mtcars o
where
exists (
select 'x' from learn.dbo.mtcars
where cyl > 40000
) -- 0 rows returned

select * from learn.dbo.mtcars o
where
exists (
select 'x' from learn.dbo.mtcars
where cyl > 4 -- inner query 21 rows retured, for each row of outer query. So all rows of outer query returned
) -- all rows returned

select * from learn.dbo.mtcars o
where
exists (
select 'x' from learn.dbo.mtcars
where cyl=o.cyl -- inner query 11, 7, 14 rows retured (all non-zero), for each row of outer query with cyl 4,6,8. So all rows of outer query returned
) -- all rows returned

select * from learn.dbo.mtcars o
where
exists (
select 'x' from learn.dbo.mtcars
where cyl=o.cyl + 2 -- inner query 7, 14, 0 rows retured, for each row of outer query with cyl 4,6,8. So cyl = 4, 6 rows of outer query returned
)

select * from learn.dbo.mtcars
where
exists(
select 0
) -- all rows returned, obviously

select * from learn.dbo.mtcars
where
exists(
select 1/0
) -- all rows returned, even though 1/0 won't even be evaluated

select * from learn.dbo.mtcars o
where exists(
select *
from learn.dbo.mtcars i
where cyl=4
) -- all rows returned. 
-- for each row of outer query, there is an inner query returning 11 rows (non zero rows). So all rows of outer query returned.
 
select * from learn.dbo.mtcars o 
where exists(
select * from countries i
) -- all rows returned. 
-- for each row of outer query, there is an inner query returning 2 rows (non zero rows). So all rows of outer query returned.

-- Please ignore this commented-out example 
-- WRONG: prefer (exists + !=) instead of (not exists), if possible
-- exists: present in A and not B (present in 4_6 and not 4 = present in 6)
-- with mtcars_4_6 as (
-- select * from learn.dbo.mtcars
-- where cyl in (4,6)
-- ),
-- mtcars_6 as (
-- select * from learn.dbo.mtcars
-- where cyl=6
-- ),
-- mtcars_4 as (
-- select * from learn.dbo.mtcars
-- where cyl=4
-- )
-- select * from mtcars_4_6 o
-- where exists (select 'x' from mtcars_4 i
-- 				where i.cyl != o.cyl) -- all 6 returned

--exists: present in A and not B (present in 4_6 and not 6_8 = present in 4)
with mtcars_4_6 as (
select * from learn.dbo.mtcars
where cyl in (4,6)
),
mtcars_6_8 as (
select * from learn.dbo.mtcars
where cyl in (6,8)
)
select * from mtcars_4_6 o
where not exists (select 'x' from mtcars_6_8 i
				where i.cyl = o.cyl)

--exists: present in B and not A (present in 6_8 and not 4_6 = present in 8)
-- just flip outer and inner query tables
with mtcars_4_6 as (
select * from learn.dbo.mtcars
where cyl in (4,6)
),
mtcars_6_8 as (
select * from learn.dbo.mtcars
where cyl in (6,8)
)
select * from mtcars_6_8 o
where not exists (select 'x' from mtcars_4_6 i
				where i.cyl = o.cyl)

-- exists: a and b
with mtcars_4_6 as (
select * from learn.dbo.mtcars
where cyl in (4,6)
),
mtcars_6_8 as (
select * from learn.dbo.mtcars
where cyl in (6,8)
)
select * from mtcars_4_6
where exists (select 'x' from mtcars_6_8 
				where mtcars_4_6.cyl = mtcars_6_8.cyl)

-- exists: a or b, but not both
-- (a but not b) union (b but not a)
with mtcars_4_6 as (
select * from learn.dbo.mtcars
where cyl in (4,6)
),
mtcars_6_8 as (
select * from learn.dbo.mtcars
where cyl in (6,8)
)
select * from mtcars_4_6
where not exists (select 'x' from mtcars_6_8 
				where mtcars_4_6.cyl = mtcars_6_8.cyl)
UNION ALL 
select * from mtcars_6_8
where not exists (select 'x' from mtcars_4_6
				where mtcars_6_8.cyl = mtcars_4_6.cyl)

---------------------------------------- arrange ----------------------------------------
select *
from learn.dbo.mtcars
order by 2, 3

-- default ascending
select *
from learn.dbo.mtcars
order by cyl, mpg 

-- use asc and desc to specify
select *
from learn.dbo.mtcars
order by cyl asc, mpg desc


-- sort data within a group?

---------------------------------------- slice ----------------------------------------
-- Slice dplyr/row index
-- offset
-- offset -- use with order by
-- "offset 0 rows" allowed
-- TOP cannot be combined with OFFSET and FETCH.
-- A TOP can not be used in the same query or sub-query as a OFFSET.

-- create a sl_no column without any ordering (existing order)
select *, 
row_number() over (order by (select 1)) as sl_no
from learn.dbo.mtcars

-- offset
select *
from learn.dbo.mtcars
order by mpg
offset 2 rows -- negative number not allowed. Can use 3-1 instead of 2

-- can use variable instead of hard-coding
DECLARE @var_a as int
SET @var_a = 2
print @var_a
select * 
from learn.dbo.mtcars
order by row_number() over (order by (select 1)) -- order by sl_no
offset @var_a rows

-- offset and fetch
select * 
from learn.dbo.mtcars
order by row_number() over (order by (select 1)) -- order by sl_no
offset 2 rows
fetch next 6 rows only

-- fetch. 
-- fetch alone not possible, always use with offset (use offset 0 if don't want to offset)
