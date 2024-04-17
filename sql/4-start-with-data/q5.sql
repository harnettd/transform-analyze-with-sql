/* How is purchase cost distributed? */

with costs_arr as (
select
	a.units_sold * a.unit_price / 1000000 as cost
from analytics as a
where a.units_sold > 0
	and unit_price > 0
order by cost
),

costs_arr_tiled as (
	select 
		cost,
		ntile(8) over (order by cost asc) as bin_num
	from costs_arr
	where cost between 
		401 - 2 *7882
		and 401 + 2 * 7882
)

select
	avg(cost) as bin_lbl,
	count(bin_num)
from costs_arr_tiled
group by bin_num
;
	
	
	
	
	