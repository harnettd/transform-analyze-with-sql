/* Update analytics table. */


/* Set column data types. */
alter table if exists analytics
	alter column visitnumber type integer using visitnumber::integer,
	alter column units_sold type integer using units_sold::integer,
	alter column pageviews type integer using pageviews::integer,
	alter column bounces type integer using bounces::integer,
	
	alter column revenue type numeric using revenue::numeric,
	alter column unit_price type numeric using unit_price::numeric,
	
	alter column date type date using to_date(date, 'YYYYMMDD');

/* Scale down unit_price by 1,000,000. */
update analytics
set unit_price = unit_price / 1000000;

/* Delete rows with negative values of unit_price. */
delete from analytics
where units_sold < 0;