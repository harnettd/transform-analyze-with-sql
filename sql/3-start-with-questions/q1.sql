/* Question 1: Which cities and countries have the highest level of
 * transaction revenues on the site? */


select 
	country,
	sum(totaltransactionrevenue) as tot_trans_rev
from all_sessions
where totaltransactionrevenue is not null
group by country
order by tot_trans_rev desc;

with country_city_sum as (
	select 
		country,
		city,
		sum(totaltransactionrevenue) as tot_trans_rev
	from all_sessions
	where totaltransactionrevenue is not null
	group by
		country,
		city
)
select *
from country_city_sum
where city is not null
order by tot_trans_rev desc;
	
