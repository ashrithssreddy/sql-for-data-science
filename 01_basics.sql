---------------------------------------- Table creation ----------------------------------------
-- create a table, from raw values
drop table if exists dummy_table;
CREATE TABLE dummy_table (a int, b int, c int);
INSERT INTO dummy_table (a, b) VALUES (30, 20), (10,40);
select * from dummy_table;

-- create new table from existing
drop table if exists dummy_table_2;
select *
into dummy_table_2 from learn.dbo.mtcars;
select * from dummy_table_2;
/* create table persons_blah as select * from persons */  /* does not work */

-- create a table with constant columns, row-count of existing table
select 1, 2, 3
from learn.dbo.mtcars
	
---------------------------------------- Table updation ----------------------------------------
-- update table
update dummy_table_2
set hp = 888888
where cyl=4; 
select * from persons_2;

update dummy_table_2
set hp = 1.1*66666
select * from dummy_table_2;

alter table dummy_table_2
drop column hp;
select * from dummy_table_2

-- some garbage
DECLARE @var_a as int
SET @var_a = 4 
-- or 
SET @var_a = (select count(*) from learn.dbo.mtcars)
print @var_a
-- or
DECLARE @var_a AS int = 4
print @var_a

---------------------------------------- order of execution ----------------------------------------
-- Writing order:	select	> top	> from		> where		> group by	> having	> order by
-- Execution order: from	> where > group by	> having	> select	> order by	> limit/top
-- Detailed order:from/join > where > group by	> aggregate > having	> window-fn > select	> distinct > union/intersection/except > order by > offset > limit/top/fetch
select 
top 100
am, sum(cyl) as sum_cyl, sum(hp) as sum_hp
from learn.dbo.mtcars
where cyl=6 OR cyl=4
group by am
having sum(cyl) > 20
order by am desc

-- statistical summary
select 
STDEV(vs) as std_vs, 
var(vs) as var_vs 
from learn.dbo.mtcars

---------------------------------------- case when ----------------------------------------
select hp, cyl,
case	when cyl=4 then 1
		when cyl=6 then 2
		else 3 -- optional, returns null if above conditions are not met.
end as cyl_new
from learn.dbo.mtcars

select cyl, 
	sum(case when hp%2=0 then hp else 0 end) as even_hp_sum,
	sum(case when hp%2=1 then hp else 0 end) as odd_hp_sum
from learn.dbo.mtcars
group by cyl

---------------------------------------- bind ----------------------------------------
-- Union and Union all -- union de-duplicates, not recommended.
(select mpg, cyl, disp
from learn.dbo.mtcars
where cyl=4)

union -- deduplicates output table

(select mpg, cyl, disp
from learn.dbo.mtcars
where cyl=6)


(select mpg, cyl, disp
from learn.dbo.mtcars
where cyl=4)
union
(select mpg, cyl, disp
from learn.dbo.mtcars
where cyl=4) -- sorted by col 1, 2, 3?

(select mpg, cyl, disp
from learn.dbo.mtcars
where cyl=4)
union all -- include all the rows, including duplicates
(select mpg, cyl, disp
from learn.dbo.mtcars
where cyl=4) -- brute forece binding, no ordering?

-- union mismatching columns: ignores colnames and rbinds
(select mpg, cyl, vs
from learn.dbo.mtcars
where cyl=4)
union 
(select mpg, cyl, disp
from learn.dbo.mtcars
where cyl=4)

-- union all mismatching columns: ignores colnames and rbinds
(select mpg, cyl, vs
from learn.dbo.mtcars
where cyl=4)
union all
(select mpg, cyl, disp
from learn.dbo.mtcars
where cyl=4)
---------------------------------------- with statement ----------------------------------------
with temp_4 as (
select * from learn.dbo.mtcars
where cyl=4
),
temp_6 as (
select * from learn.dbo.mtcars
where cyl=6
)

select * from temp_4
union all
select * from temp_6

---------------------------------------- missing values ----------------------------------------
-- Return the first non-null value in a list:
SELECT COALESCE(NULL, NULL, NULL, 'W3Schools.com', NULL, 'Example.com');
SELECT COALESCE(NULL, 1, 2, 'W3Schools.com');

-- count of missing values in all columns
select *
from learn.dbo.mtcars_null

select 
	sum(case when cyl is null then 1 else 0 end) as count_cyl,
	sum(case when disp is null then 1 else 0 end) as count_disp,
	sum(case when hp is null then 1 else 0 end) as count_hp,
	sum(case when drat is NOT null then 1 else 0 end) as count_drat_not_null
from learn.dbo.mtcars_null

-- avg, min, max of missing values
drop table if exists dummy_table;
CREATE TABLE dummy_table (a int, b int, c int);
INSERT INTO dummy_table (a, b, c) VALUES (10, NULL, 1), (NULL,NULL, 2), (50, NULL, 3);

select * from dummy_table;

select 
avg(a) as avg_a, -- avg ignores missing values
avg(b) as avg_b, 
avg(c) as avg_c,
min(a) as min_a, -- min ignores missing values
min(b) as min_b, 
min(c) as min_c,
max(a) as max_a, -- max ignores missing values
max(b) as max_b, 
max(c) as max_c,
count(a) as count_a, -- count ignores missing values
count(b) as count_b, -- count of non-missing elements in b
count(c) as count_c,
count(*) as count_table
from dummy_table

-- even when the entire table is NULL, count(*) returns row count (and not non-missing row count)
drop table if exists dummy_table;
CREATE TABLE dummy_table (a int, b int, c int);
INSERT INTO dummy_table (a, b, c) VALUES (NULL, NULL, NULL), (NULL,NULL, NULL), (NULL, NULL, NULL);
select * from dummy_table;
select count(*) as count_table
from dummy_table;

---------------------------------------- others ----------------------------------------
-- distinct/dedup
select distinct *
from learn.dbo.mtcars

-- also dedup using group by, much faster

-- error handling
-- nullif
SELECT NULLIF(10, 10); -- returns NULL if a=b. If a!=b, returns a
SELECT NULLIF(10, 20);
SELECT NULLIF(20, 10);
NULLIF(NULL, NULL) -- error

SELECT 20/10;
SELECT 10/20; -- returns 0 int instead of 0.5, since 10 and 20 are integers
SELECT 1.0*10/20; -- returns 0.5
SELECT 10/20*1.0; -- returns 0

SELECT 1.0*10/0; -- error
SELECT 1.0*10/null -- null
SELECT 1.0*10/nullif(20, null) -- 0.50
SELECT 10/nullif(null, null) -- error in denominator


-- Reverse a whole column and put it back?