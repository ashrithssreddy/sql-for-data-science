---------------------------------------- group by ----------------------------------------
-- select 
-- from learn.dbo.mtcars

with temp as(
select hp, mpg, cyl
from learn.dbo.mtcars
)
select hp, mpg, cyl 
from temp
group by hp, mpg, cyl

-- dedup using group by
with temp as(
select hp, mpg, cyl
from learn.dbo.mtcars
)
select *, count(*) as my_count 
from temp
group by hp, mpg, cyl
-- group by * -- not allowed
having count(*) <= 1 -- removes all entries with duplicates. Does not de-duplicate, but removes any entry with a duplicate

---------------------------------------- aggregate ----------------------------------------
-- aggregate and order by
select vs, am , avg(hp) as avg_hp
from learn.dbo.mtcars 
group by vs, am 
order by 1, 3


---------------------------------------- equi: left join ----------------------------------------
with mtcars_4 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=4
),
mtcars_6 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=6
)

select a.*, b.*
from mtcars_4 a left join mtcars_6 b
on a.row_num = b.row_num

---------------------------------------- equi: right join ----------------------------------------
with mtcars_4 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=4
),
mtcars_6 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=6
)

-- select b.*, a.*
select a.*, b.*
from mtcars_4 a right join mtcars_6 b
on a.row_num = b.row_num

---------------------------------------- equi: inner join ----------------------------------------
with mtcars_4 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=4
),
mtcars_6 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=6
)

select a.*, b.*
from mtcars_4 a inner join mtcars_6 b
on a.row_num = b.row_num

---------------------------------------- equi: outer join ----------------------------------------
-- full outer (4 join 6)
with mtcars_4 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=4
),
mtcars_6 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=6
)

select a.*, b.*
from mtcars_4 a full outer join mtcars_6 b
on a.row_num = b.row_num


-- full outer (b join a)
with mtcars_4 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=4
),
mtcars_6 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=6
)

select a.*, b.*
from mtcars_6 a full outer join mtcars_4 b
on a.row_num = b.row_num


-- use full outer join as inner join
-- full outer join and apply filter a.key is not null and b.key is not null
with mtcars_4 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=4
),
mtcars_6 as (
select *, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=6
)

select a.*, b.*
from mtcars_4 a full outer join mtcars_6 b
on a.row_num = b.row_num
where a.row_num is not null and b.row_num is not null


---------------------------------------- cross join  ----------------------------------------
drop table if exists Meals;
CREATE TABLE Meals(MealName VARCHAR(100), meal_id int)
INSERT INTO Meals (MealName, meal_id)
VALUES('Omlet', 1), ('Fried Egg', 2), ('Sausage', 3);
select * from Meals;

drop table if exists Drinks;
CREATE TABLE Drinks(DrinkName VARCHAR(100), drink_id int)
INSERT INTO Drinks (DrinkName, drink_id)
VALUES('Orange Juice', 1), ('Tea', 2), ('Cofee', 3);
select * from Drinks;

SELECT * FROM Meals CROSS JOIN Drinks;

---------------------------------------- duplicates  ----------------------------------------
drop table if exists Meals;
CREATE TABLE Meals(MealName VARCHAR(100), meal_id int)
INSERT INTO Meals (MealName, meal_id)
VALUES('Omlet', 1), ('Fried Egg', 2), ('Sausage', 3);
drop table if exists Drinks;
CREATE TABLE Drinks(DrinkName VARCHAR(100), drink_id int)
INSERT INTO Drinks (DrinkName, drink_id)
VALUES('Orange Juice', 1), ('Tea', 1), ('Cofee', 3);

-- left join (creates duplicate rows in final output, ACCORDINGLY - when there are multiple matches on the right table)
SELECT * FROM 
Meals left JOIN Drinks
on meal_id = drink_id
select * from Meals;
select * from Drinks;

-- right join (creates duplicate rows in final output, ACCORDINGLY  - when there are multiple matches on the right table)
SELECT * FROM 
Meals right JOIN Drinks
on meal_id = drink_id
select * from Meals;
select * from Drinks;

-- inner join (creates duplicate rows in final output, ACCORDINGLY  - when there are multiple matches on the right table)
SELECT * FROM 
Meals inner JOIN Drinks
on meal_id = drink_id
select * from Meals;
select * from Drinks;

-- full outer join (creates duplicate rows in final output, ACCORDINGLY  - when there are multiple matches on the right table)
SELECT * FROM 
Meals full outer JOIN Drinks
on meal_id = drink_id
select * from Meals;
select * from Drinks;

-- cross join (creates duplicate rows in final output, ACCORDINGLY  - when there are multiple matches on the right table)
SELECT * FROM 
Meals cross JOIN Drinks;
select * from Meals;
select * from Drinks;

---------------------------------------- non-equi: less than  ----------------------------------------
-- Multiple matches on criteria, duplicate keys, so more than one result obtained for each match
with mtcars_4 as (
select cyl, mpg, hp, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=4
),
mtcars_6 as (
select cyl, mpg, hp, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=6
)

select a.*, b.*
from mtcars_4 a left join mtcars_6 b
on a.row_num < b.row_num;
select cyl, mpg, hp, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=4;
select cyl, mpg, hp, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=6;

---------------------------------------- non-equi: less than equal ----------------------------------------
-- Multiple matches on criteria, duplicate keys, so more than one result obtained for each match
with mtcars_4 as (
select cyl, mpg, hp, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=4
),
mtcars_6 as (
select cyl, mpg, hp, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=6
)
select a.*, b.*
from mtcars_4 a left join mtcars_6 b
on a.row_num <= b.row_num;
select cyl, mpg, hp, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=4;
select cyl, mpg, hp, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=6;

---------------------------------------- inner non-equi: less than ----------------------------------------
-- Multiple matches on criteria, duplicate keys, so more than one result obtained for each match
-- NULLs on right table removed
with mtcars_4 as (
select cyl, mpg, hp, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=4
),
mtcars_6 as (
select cyl, mpg, hp, row_number() over (order by cyl) as row_num 
from learn.dbo.mtcars
where cyl=6
)
select a.*, b.*
from mtcars_4 a inner join mtcars_6 b
on a.row_num < b.row_num
order by a.row_num
