/* Question 3: Is there any pattern in the types (product categories)
 * of products ordered from visitors in each city and country? */

with country_city_cat as (
	select
		a2.country,
 		a2.city,
		case
			when v2productcategory = 'Apparel' then 'Home/Apparel/'
			when v2productcategory = 'Drinkware' then 'Home/Drinkware/'
			when v2productcategory = 'Headgear' then 'Home/Apparel/Headgear/'
			when v2productcategory = 'Housewares' then 'Home/Housewares/'
			when v2productcategory = 'Nest-USA' then 'Home/Nest/Nest-USA/'
			when v2productcategory = '(not set)' then null
			else v2productcategory 
		end as v2productcategory 
	from analytics as a1
		left join all_sessions as a2 on a1.visitid = a2.visitid 
	where a1.units_sold is not null
		and country is not null
)
select
	country,
	v2productcategory,
	count(v2productcategory) as count_v2productcateogry
from country_city_cat
where v2productcategory is not null
group by 
	country,
	v2productcategory
order by 
	country,
	count_v2productcateogry desc
;


with country_city_cat as (
	select
		a2.country,
		a2.city,
		case
			when v2productcategory = 'Apparel' then 'Home/Apparel/'
			when v2productcategory = 'Drinkware' then 'Home/Drinkware/'
			when v2productcategory = 'Headgear' then 'Home/Apparel/Headgear/'
			when v2productcategory = 'Housewares' then 'Home/Housewares/'
			when v2productcategory = 'Nest-USA' then 'Home/Nest/Nest-USA/'
			when v2productcategory = '(not set)' then null
			else v2productcategory 
		end as v2productcategory 
	from analytics as a1
		left join all_sessions as a2 on a1.visitid = a2.visitid 
	where a1.units_sold is not null
		and country is not null
)
select
	country,
	city,
	v2productcategory,
	count(v2productcategory) as count_v2prodctcategory
from country_city_cat
where v2productcategory is not null
	and city is not null
group by
	country,
	city,
	v2productcategory
order by
	country,
	city,
	v2productcategory,
	count_v2prodctcategory desc
;