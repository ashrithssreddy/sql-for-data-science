---------------------------------------- postgres  ----------------------------------------
-- create table
drop table if exists learn_dbo.temp_table;
CREATE TABLE learn_dbo.temp_table
(col_a int, col_b int,	col_c int,	col_d int);
INSERT INTO learn_dbo.temp_table(col_a, col_b, col_c, col_d) VALUES 
(1,2,3,4), (null,12,13,14); 

-- dimensions
select count(*) from __;

-- missing values check: by each column
select
	sum(case when _ is null then 1 else 0 end) as missing_,
from ___;

-- data cardinality check: count unique values by column
select
	count(distinct ) as unique_,
	count(distinct ) as unique_,
from ___;


