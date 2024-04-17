Question 1: 

Previously, in Question 1 or the preceding part, I found that, while there is significant total transaction revenue from the United States, there is much less from Australia, Canada, Israel, and Switzerland. From the latter four countries in particular, how many *distinct* customers are responsible for the total transaction revenue?  

SQL Queries:

```sql
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
```

Answer: 

By running the above query, we find that the total transaction revenue is due to 75 distinct customers from the United States, but only two from Canada, and one each from Australia, Israel, and Switzerland. More customers in those countries might lead to higher revenue!


Question 2: From each country from which there is not **not** a record of a purchase, how many distinct visitors were there?

SQL Queries:

```sql
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
```

Answer: 

By running this query, I identified 73 distinct countries for which there is no record of a purchase. Ranked by number of distinct visitors, the top five such countries (Brazil, Italy, Spain, Philippines, and Russia) all had 99 or more distinct visitors. 


Question 3: Did average time on site impact whether or not a user made a purchase?

In the `analytics` table, there is a `timeonsite` column. However, I left this column as `text` as I had no way to determine the associated units of measurement. But to consider the ratio between two such times, no units are needed. Thus, I cast the column entries as `integer` and ran the following query: 

SQL Queries:

```sql
with sale_or_not as (
	select distinct
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
```

Answer:

According to the results of the aboe query, visitors who ultimately made a purchase spent roughly twice as much time on site as visitors who did not make a purchase.

Question 4: How does channelgrouping impact whether or not a user made a purchase?

In the `analytics` table, there is a `channelgrouping` column which seems to indicate how the visitor found their way to the site. Possible values include Referral, Organic Search, Direct, Social, Paid Search, Display, and Affiliates.

SQL Queries:

```sql
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
	count_channelgrouping desc;
```

Answer:

By executing the above SQL script, I found that, regardless of whether a visitor made a purchase, Organic Search and Referral comprised ~75% of the (non-null) entries in the `channelgrouping` column. For visitors who did make a purchase, Referral was the channel grouping ~50% of the time while Organic Search was the channel grouping ~25% of the time. Interestingly enough, for visitors who did not make a purchase, these values swapped places: ~50% of the time, Organic Search was the channel grouping while ~25% of the time, Referral was the channel grouping.

Question 5: 

SQL Queries:

Answer:
