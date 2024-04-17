/* Question 5: Can we summarize the impact of revenue generated from each city/country? */

with country_city_rev as (
select
	a.country as country,
	a.city,
	a.totaltransactionrevenue as tot_trans_rev
from all_sessions as a
where a.totaltransactionrevenue is not null
),

/* For the United States, aggregate on city. */
us_rev as (
	select
		city,
		sum(tot_trans_rev) as sum_trans_rev
	from country_city_rev
	where country = 'United States'
	group by city
),

/* For international locations, aggregate by country. */
international_rev as (
	select
		country,
		sum(tot_trans_rev) as sum_trans_rev
	from country_city_rev
	where country != 'United States'
	group by country
),

/* Union the United States and international data. */
locale_region_rev as (
	select
		city as locale,
		'United States' as region,
		sum_trans_rev
	from us_rev
	union
	select
		country as locale,
		'International' as region,
		sum_trans_rev
	from international_rev
)

/* Add summary rows corresponding to total United States
 * revenue and total international revenue. */ 
select
	'ALL' as locale,
	'International' as region,
	sum(sum_trans_rev)
from locale_region_rev
where region = 'International'
union
select
	'ALL',
	'United States',
	sum(sum_trans_rev)
from locale_region_rev
where region = 'United States'
union
select *
from locale_region_rev
order by
	region,
	locale;
