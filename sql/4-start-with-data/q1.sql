/* How many distinct customers are responsible for the total transaction revenue? */

with country_visitorid as (
	select distinct
		country,
		fullvisitorid
	from all_sessions
	where totaltransactionrevenue is not null
)
select
	country,
	count(fullvisitorid) as distinct_visitors
from country_visitorid
group by country
order by distinct_visitors desc;
