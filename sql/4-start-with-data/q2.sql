/* From each country that we can't verify has made a purchase, how many
 * distinct visitors were there? */


select
	a.country,
	count(a.fullvisitorid) as num_distinct_visitors
from all_sessions as a
where country is not null and country != '(not set)'
	and country in (
	
		select distinct a2.country 
		from analytics as a1
		left join all_sessions as a2 on a1.visitid = a2.visitid
		where a1.units_sold is null
			and a2.country is not null
			and a2.country not in (
			
				select distinct a4.country as country 
				from analytics as a3
				left join all_sessions as a4 on a3.visitid = a4.visitid
				where a3.units_sold is not null
					and a4.country is not null
			
			)
		
		) 
group by a.country
order by num_distinct_visitors desc;
