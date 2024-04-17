/* Update all_sessions table. */


/* Set column data types. */
alter table if exists all_sessions

	alter column transactions type integer using transactions::integer,
	alter column pageviews type integer using pageviews::integer,
	alter column sessionqualitydim type integer using sessionqualitydim::integer,
	alter column productquantity type integer using productquantity::integer,
	alter column ecommerceaction_type type integer using ecommerceaction_type::integer,
	alter column ecommerceaction_step type integer using ecommerceaction_step::integer,
	
	alter column totaltransactionrevenue type numeric using totaltransactionrevenue::numeric,
	alter column productprice type numeric using productprice::numeric,
	alter column productrevenue type numeric using productrevenue::numeric,
	alter column transactionrevenue type numeric using transactionrevenue::numeric,
	
	alter column date type date using to_date(date, 'YYYYMMDD');

/* Drop empty columns. */
alter table if exists all_sessions
	drop column productrefundamount,
	drop column itemquantity,
	drop column itemrevenue,
	drop column searchkeyword;

/* Scale down all monetary values by 1,000,000. */
update all_sessions
set totaltransactionrevenue = totaltransactionrevenue / 1000000,
	productrevenue = productrevenue / 1000000,
	productprice = productprice / 1000000;

/* Set some equivalent null value to null. */
update all_sessions
set country = null
where country = '(not set)';

update all_sessions
set city = null
where city in ('(not set)', 'not available in demo dataset');
