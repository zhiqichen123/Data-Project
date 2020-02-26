# Q1
select country from countries_of_the_world
where gdp > (select avg(gdp) from countries_of_the_world);

# Q2
select region, count(country) from countries_of_the_world
where gdp > (select avg(gdp) from countries_of_the_world)
group by region;

# Q3
-- method 1
with tb1 as
(select region, count(country) as col1
from countries_of_the_world 
group by region),
tb2 as 
(select region, count(country) as col2
from countries_of_the_world
where GDP > 6000
group by region)
select count(*) from tb1
inner join tb2
on tb1.region = tb2.region
where tb2.col2/tb1.col1 > 0.65;

-- method 2
select count(*) from
(select region, count(country) as col1, count(case when GDP > 6000 then 1 end) as col2
from countries_of_the_world
group by region) as tb1
where tb1.col2/tb1.col1 > 0.65;

-- method 3
select count(*) from 
(select region, count(country) as col1
from countries_of_the_world
where gdp > 6000
group by region) tb1
inner join
(select region, count(country) as col2
from countries_of_the_world
group by region) tb2
on tb1.region = tb2.region
where tb1.col1/tb2.col2 > 0.65;

# Q4
select country from countries_of_the_world
where gdp <= 0.6 * (select avg(gdp) from countries_of_the_world);

# Q5
-- method 1
select country from countries_of_the_world
where gdp >= 0.4 * (select avg(gdp) from countries_of_the_world) and gdp <= 0.6 * (select avg(gdp) from countries_of_the_world);

-- method 2
select country from countries_of_the_world
where gdp between 0.4 * (select avg(gdp) from countries_of_the_world)
and 0.6 * (select avg(gdp) from countries_of_the_world);

-- method 3
select country from countries_of_the_world
where gdp between (select 0.4 * avg(gdp) from countries_of_the_world)
and (select 0.6 * avg(gdp) from countries_of_the_world);

# Q6
select first_letter from
(select first_letter, count(*) from
(select left(country, 1) as first_letter from countries_of_the_world) tb1
group by 1
order by 2 desc
limit 1) tb2;

# Q7
-- Problem 1
-- method 1
with top_50_coast as
(select country from countries_of_the_world
order by (coastline/area) desc
limit 50),
bottom_30_gdp as
(select country from countries_of_the_world
order by gdp
limit 30)
select top_50_coast.country from top_50_coast
inner join bottom_30_gdp
on top_50_coast.country = bottom_30_gdp.country;

-- method 2
select top_50_coast.country from
(select country from countries_of_the_world
order by (coastline/area) desc
limit 50) as top_50_coast
inner join
(select country from countries_of_the_world
order by gdp
limit 30) bottom_30_gdp
on top_50_coast.country = bottom_30_gdp.country;

-- Problem 2
with top_50_coast as
(select country from countries_of_the_world
order by (coastline/area) desc
limit 50),
top_30_gdp as
(select country from countries_of_the_world
order by gdp desc
limit 30)
select top_50_coast.country from top_50_coast
inner join top_30_gdp
on top_50_coast.country = top_30_gdp.country;

# Q8
-- method 1
with top_20 as
(select avg(agriculture) as a, avg(industry) as i, avg(service) as s from
(select * from countries_of_the_world
order by gdp desc
limit 20) as tb1),
bottom_20 as
(select avg(agriculture) as a, avg(industry) as i, avg(service) as s from
(select * from countries_of_the_world
order by gdp
limit 20) as tb2)
select round(top_20.a-bottom_20.a, 3) as d1, round(top_20.i-bottom_20.i, 3) as d2, round(top_20.s-bottom_20.s, 3) as d3
from top_20, bottom_20;

-- method 2
select avg(agriculture) as a, avg(industry) as i, avg(service) as s from
(select * from countries_of_the_world
order by gdp desc
limit 20) as tb1
union all
select avg(agriculture), avg(industry), avg(service) from
(select * from countries_of_the_world
order by gdp
limit 20) as tb2;

# Q9
-- method 1
with ttb1 as
(select avg(literacy) as avg_lit from
(select *, rank() over(order by gdp desc) gdp_rank from countries_of_the_world) tb1
where gdp_rank <= 0.2 * (select count(*) from countries_of_the_world)),
ttb2 as
(select avg(literacy) as avg_lit from
(select *,rank() over(order by gdp) gdp_rank from countries_of_the_world) tb2
where gdp_rank <= 0.2 * (select count(*) from countries_of_the_world))
select round(ttb1.avg_lit-ttb2.avg_lit, 3) as difference
from ttb1, ttb2;

-- method 2
select round(x.l-y.l, 3) as difference from
(select avg(literacy) as l from
(select *, rank() over(order by gdp desc) as col from countries_of_the_world) tb1
where col <= 0.2 * (select count(*) from countries_of_the_world)) as x,
(select avg(literacy) as l from
(select *, rank() over(order by gdp) as col from countries_of_the_world) tb1
where col <= 0.2 * (select count(*) from countries_of_the_world)) as y;

-- method 3
select "Rich" as Category, avg(literacy) as Avg_Literacy from
(select literacy, percent_rank() over (order by gdp desc) as percentile_rank from countries_of_the_world) as a
where percentile_rank < 0.2
union all
select "Poor", avg(literacy) from
(select literacy, percent_rank() over (order by gdp desc) as percentile_rank from countries_of_the_world) as b
where percentile_rank > 0.8;

-- method 4
select round(x.l-y.l, 3) as difference from
(select avg(literacy) as l from
(select literacy, percent_rank() over (order by gdp desc) as percentile_rank from countries_of_the_world) as a
where percentile_rank <= 0.2) as x
inner join
(select avg(literacy) as l from
(select literacy, percent_rank() over (order by gdp desc) as percentile_rank from countries_of_the_world) as b
where percentile_rank >= 0.8) as y;

# Q10
-- Problem 1
with tb1 as 
(select count(*) as col1
from countries_of_the_world  
where coastline/area <= (select 0.5 * avg(coastline/area) from countries_of_the_world)),
tb2 as
(select count(*) as col2
from countries_of_the_world 
where coastline/area <= (select 0.5 * avg(coastline/area) from countries_of_the_world) and region like "%africa%")
select tb2.col2/tb1.col1 from tb1, tb2;

-- Problem 2
-- method 1
select count(*) from countries_of_the_world  
where coastline/area <= (select 0.5 * avg(coastline/area) from countries_of_the_world) and left(country, 1) = 'c';

-- method 2
select count(*) from countries_of_the_world  
where coastline/area <= (select 0.5 * avg(coastline/area) from countries_of_the_world) and country regexp '^C';
