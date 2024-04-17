/* Question 2: What is the average number of products ordered from visitors
 * in each city and country? */

select 
	a2.country,
	avg(a1.units_sold) as avg_units_sold
from analytics as a1
left join all_sessions as a2 on a1.visitid = a2.visitid 
where units_sold is not null
	and country is not null
group by a2.country
order by 
	avg_units_sold desc,
	country;

with country_city_avg as (
	select 
		a2.country,
		a2.city,
		avg(a1.units_sold) as avg_units_sold
	from analytics as a1
	left join all_sessions as a2 on a1.visitid = a2.visitid 
	where units_sold is not null
		and country is not null
	group by 
		a2.country,
		a2.city
)
select *
from country_city_avg
where city is not null
order by 
	avg_units_sold desc,
	country,
	city;
