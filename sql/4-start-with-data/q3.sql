/* Q3: Did average time on site impact whether or not a user  
 * made a purchase? */


with sale_or_not as (
	select
		a1.visitid,
		a1.fullvisitorid,
		a1.timeonsite::integer,
		case
			when a1.units_sold is not null then True
			else False
		end as is_units_sold
	from analytics as a1
	where timeonsite is not null
)
select
	is_units_sold,
	avg(timeonsite) as avg_timeonsite
from sale_or_not
group by is_units_sold;