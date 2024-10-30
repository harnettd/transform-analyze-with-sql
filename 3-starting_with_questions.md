Answer the following questions and provide the SQL queries used to find the answer.

    
**Question 1: Which cities and countries have the highest level of transaction revenues on the site?**

SQL Queries:

To address this question, I used the `country`, `city`, and `totaltransactionrevenue` columns from the `all_sessions` table. It should be noted that there are only 81 non-null entries in `totaltransactionrevenue`. These rows were my sample set, which was small. Furthermore, while all corresponding `country` entries were non-null, a number of `city` entries were effectively null, *i.e.,* "not available in demoset". Therefore, I decided to answer this question through two queries, one that grouped by `country` and another that grouped by `country` and `city`, filtering out rows in which the city was not specified. Also, we were informed that `totaltransaction` revenue needed to be scaled down by a factor of 1,000,000. 

```sql
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
```

Answer:

By running the above queries, I find five countries with nonzero transaction revenue. The vast majority of transaction revenue, $13k, comes from the United States. Israel, Australia, and Canada have total transaction revenues on the order of hundreds of dollars. Switzerland has a total transaction revenue of ~$17. 

At the city level, there are 20 cities that have nonzero total transaction revenue. When ranked by total transaction revenue, 13 of the top 15 cities are from the United States, the top three being San Francisco, Sunnyvale, and Atlanta. The highest ranking city outside of the United States is Tel Aviv-Yao in fifth place.


**Question 2: What is the average number of products ordered from visitors in each city and country?**

To address this question, I used the `country` and `city` columns from the `all_sessions` table as well as the `units_sold` column from the `analytics` table. Focusing on rows with non-null entries for both `country` and `units_sold` gave a sample size of 502, larger than on the previous question. As in the previous question, I present two queries to answer this question: one that grouped by `city` and a second that grouped by `city` and `country`. Again the problem is that some `city` entries are effectively null, and so can't be included in an analysis focusing on `city`.

SQL Queries:

```sql
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
```


Answer:

Focusing on visits where I could confirm that units were sold, I find that the average number of products ordered per visit from Canada and the United States was over 2 each whereas Bulgaria, Mexico, Japan, and India averaged between 1 and 2 products each per visit. I find 24 distinct countries that average 1 product per visit.


**Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?**

To address this question, as in the previous question, I made use of the `country` and `city` columns from the `all_sessions` table as well as the `units_sold` column from the `analytics` table. To these, I included the `v2productcategory` column from `all_sessions`. I focused on visits for which units were sold and on records having non-null `country` and `v2productategory` values. Also, as can be seen from the sequel code below, I merged a few categories which I felt characterized the same product categories, *e.g.,* Apparel went to Home/Apparel, Drinkware went to Home/Drinkware, Housewares went to Home/Housewares, *etc....* Also, as in the two previous problems, I addressed this question first by aggregating on `country` and second by aggregating on `city`. When aggregating on `city`, some rows were excluded as their value was (effectively) `null`. 

SQL Queries:

```sql
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
	count_v2prodctcategory desc;
```


Answer:

By aggregating on `country`, I found that certain product categories are particularly popular in certain countries. In the United States, which makes the overwhelming number of purchases, I found the most popular categories to be Home/Housewares/, Home/Apparel/Men's/Men's-Outerwear/, and Home/Nest/Nest-USA/ (whatever that is!). Outside of the United States, there were (relative to countries other than the United States) a few significant observations. Focusing on product categories purchased five or more times, Egypt bought from the Home/Shop By Brand/Android/ category nine times, Japan bought from the Home/Accessories/ category seven times, Switzerland bought from the Home/Apparel/Men's/Men's-T-Shirts/ category five times, and Israel bought from Home/Shop by Brand/YouTube/ category five times. Digging deeper and aggregating by `city`, we find some pretty clear outliers in the data. In the United States, the city of Mount View buys a lot from the Home/Apparel/Men's/Men's-Outerwear/ category, the city of Sunnyvale buys a lot of products from the Home/Housewares/ category and New York buys a lot from Home/Bags/Backpacks/.


**Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?**

For this problem, I interpreted top-selling product in terms of quantity sold rather than sales revenue. As in previous problems, I first aggregated at the `country` level and then followed up by aggregating at the `city` level. When aggregating at the `city` level, several rows are omitted as their `city` values are (effectively) null.  


SQL Queries:

```sql
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
```

Answer:

My country-level results indicate that the most commonly purchased product in the United States is SPF-15 Slim & Slender Lip Balm. Outside of the United States, I find that Canada purchases a lot of Packs of 9 Decal Sets, Egypt purchases a lot of Android RFIK journals, and Japan purchases a lot of lunch bags (relative to countries other than the United States). Moving to the city aggregation level, there are some interesting observations from the United States. New York buys a lot of Alpine Style Backpacks as does Chicago. Sunnyvale buys a lot of SPF-15 Slim & Slender Lip Balm, and Moutain View buys a significant number of  Men's Airflow 1/4 Zip Black Pullovers.


**Question 5: Can we summarize the impact of revenue generated from each city/country?**

Based on the results of previous queries which showed the overwhelming majority or revenue came from the United States, I decided that it made the most sense to compare total-revenue for the United States at the city level to other countries at the country level. Also, in the following query, I included a summary row for the United states and one for all other locales (*i.e.* international) to allow for a comparison between domestic and international revenue. To make this comparison meaningful, I included total revenue from the United States even for rows having a `city` entry of null. The aggregation of these records are displayed by the query with a `city` of unknown.

SQL Queries:

```sql
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
```

Answer:

From the results of the above query, I found that the total revenue from the United States was over ten times that of all other nations combined. As noted earlier, the highest total revenue outside the United States came from Israel. Here, we find that at least nine cities in the United States had total revenues on the order of hundreds of dollars, much like Israel. 


