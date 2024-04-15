/* Query all_sessions to determine appropriate data types for each column. */


/* Verify that each entry of several columns are either null or a string of digits. */

select count(*)
from analytics
where visitnumber is not null
and visitnumber not similar to '[0-9]*'
;

select count(*)
from analytics
where visitid is not null
and visitid not similar to '[0-9]*'
;

select count(*)
from analytics
where visitstarttime is not null
and visitstarttime not similar to '[0-9]*'
;

select count(*)
from analytics
where units_sold is not null
and units_sold not similar to '[0-9]*'
;

select units_sold
from analytics
where units_sold is not null
and units_sold not similar to '[0-9]*'
;

select count(*)
from analytics
where pageviews is not null
and pageviews not similar to '[0-9]*'
;

select count(*)
from analytics
where timeonsite is not null
and timeonsite not similar to '[0-9]*'
;

select count(*)
from analytics
where bounces is not null
and bounces not similar to '[0-9]*'
;

select count(*)
from analytics
where revenue is not null
and revenue not similar to '[0-9]*'
;

select count(*)
from analytics
where unit_price is not null
and unit_price not similar to '[0-9]*'
;

/* Verify that all entries of the date column are 8-digit strings. */

select count(*)
from analytics
where date not similar to '[0-9]{8}';


/* Verify that all entries are null. */

select count(*)
from analytics
where userid is not null;



