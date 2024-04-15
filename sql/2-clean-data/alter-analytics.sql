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
	