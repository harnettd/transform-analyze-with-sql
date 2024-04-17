/* Q4: How does channelgrouping impact whether or not a user  
 * made a purchase? */


with sale_or_not as (
	select
		a.channelgrouping,
		case
			when a.units_sold is not null then True
			else False
		end as is_units_sold
	from analytics as a
	where a.channelgrouping is not null
)

select
	is_units_sold,
	channelgrouping,
	count(channelgrouping) as count_channelgrouping
from sale_or_not
group by rollup (
	is_units_sold,
	channelgrouping
	)
order by
	is_units_sold,
	count_channelgrouping desc
;



