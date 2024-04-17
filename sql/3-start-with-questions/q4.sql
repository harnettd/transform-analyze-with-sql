/* Question 4: What is the top-selling product from each city/country? 
 * Can we find any pattern worthy of noting in the products sold? */

with units_sold_breakdown as (
	select
		a2.country as country,
		a2.city,
		a2.productsku as sku,
		sum(a1.units_sold) as tot_units_sold
	from analytics as a1
	left join all_sessions as a2 on a1.visitid = a2.visitid 
	where a1.units_sold is not null
		and country is not null
	group by
		a2.country,
		a2.city,
		a2.productsku
),

units_sold_ranked as (
	select
		usb.country as country,
		p.name as name, 
		usb.tot_units_sold as tot_units_sold,
		rank() over (partition by usb.country order by usb.tot_units_sold desc) as prod_rank
	from units_sold_breakdown as usb
	left join products as p on usb.sku = p.sku
)
select *
from units_sold_ranked as usr
where usr.prod_rank = 1
order by usr.country;


with units_sold_breakdown as (
	select
		a2.country as country,
		a2.city,
		a2.productsku as sku,
		sum(a1.units_sold) as tot_units_sold
	from analytics as a1
	left join all_sessions as a2 on a1.visitid = a2.visitid 
	where a1.units_sold is not null
		and country is not null
	group by
		a2.country,
		a2.city,
		a2.productsku
),

units_sold_ranked as (
	select
		usb.country as country,
		usb.city as city,
		p.name as name, 
		usb.tot_units_sold as tot_units_sold,
		rank() over (partition by usb.country, usb.city order by usb.tot_units_sold desc) as prod_rank
	from units_sold_breakdown as usb
	left join products as p on usb.sku = p.sku
	where usb.city is not null
)
select *
from units_sold_ranked as usr
where usr.prod_rank = 1
order by 
	usr.country,
	usr.city;

