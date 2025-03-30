select * 
from learn.dbo.orders

---------------------------------------- cast  ----------------------------------------
-- int to string
select str(Price) + str(ID) as my_concats
from learn.dbo.orders


---------------------------------------- concat ----------------------------------------
-- concat ints
-- use + to concat 2 ints -- ruins the length and padding
with temp as (
select str(Price) + str(ID) as my_concats
from learn.dbo.orders
)
select my_concats, len(my_concats) as len_my_concats
from temp

-- use concat to concat strings, works as expected
with temp as (
select concat(Price , ID) as my_concats
from learn.dbo.orders
)
select my_concats, len(my_concats) as len_my_concats
from temp

-- concat strings, both + and concat work as expected
with temp as (
select Country + Country as my_concats
from learn.dbo.orders
)
select my_concats, len(my_concats) as len_my_concats
from temp

with temp as (
select concat(Country, Country) as my_concats
from learn.dbo.orders
)
select my_concats, len(my_concats) as len_my_concats
from temp

-- heterogenous datatypes concat
select *, 
concat(country, capital) as col1,
concat(country, population) as col2,
concat(country, perc_country) as col3,
concat(population, perc_country) as col4
from learn.dbo.countries

-- concat accepts colnames in quotes
select *, concat("country", "country") as country_new 
from learn.dbo.orders
-- + does not accept colnames in quotes
-- select *, "country" + "country as country_new 
-- from learn.dbo.orders

-- concat_ws
-- single quotes only
select *, concat_ws(',', country, country) as country_new
from learn.dbo.orders

---------------------------------------- case ----------------------------------------
select *, lower(country) as country_new
from learn.dbo.orders
select *, upper(country) as country_new
from learn.dbo.orders

---------------------------------------- others ----------------------------------------
select *, len(country) as country_new
from learn.dbo.orders

-- Split strings
-- split a string into a column table
select * from string_split('apple,banana,carrot',',');

-- explode a column?
-- select *, string_split(Country,'a')  from learn.dbo.orders

-- replace 
select *, REPLACE(country,'a','-') as country_new
from learn.dbo.orders

---------------------------------------- regex ----------------------------------------
-- find cells starts with 'n'
-- n is case insensitive. read token as nsomething
select *
from learn.dbo.orders
where Country like 'n%' 

select *
from learn.dbo.orders
where Country not like 'n%' 



-- find cells end with 'a'
-- a is case insensitive. read token as somethinga
select *
from learn.dbo.orders
where Country like '%a'

-- find cells containing 'a' 
-- read as containing a. Starts with a, ends with a, middle has a
select *
from learn.dbo.orders
where Country like '%a%'

-- find cells containing 'in'
select *
from learn.dbo.orders
where Country like '%in%'

-- Find position of substring - first appearance
-- 0 for not found.
select *, CHARINDEX('in', Country) AS MatchPosition
from learn.dbo.orders

