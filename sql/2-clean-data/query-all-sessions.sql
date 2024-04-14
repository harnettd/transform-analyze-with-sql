/* Query all_sessions to determine appropriate data types for each column. */


/* Verify that each entry of several columns are either null or a string of digits. */
select count(*)
from all_sessions
where transactions is not null
and transactions not similar to '[0-9]*';

select count(*)
from all_sessions
where pageviews is not null
and pageviews not similar to '[0-9]*';

select count(*)
from all_sessions
where sessionqualitydim is not null
and sessionqualitydim not similar to '[0-9]*';

select count(*)
from all_sessions
where productquantity is not null
and productquantity not similar to '[0-9]*';

select count(*)
from all_sessions
where ecommerceaction_type is not null
and ecommerceaction_type not similar to '[0-9]*';

select count(*)
from all_sessions
where ecommerceaction_step is not null
and ecommerceaction_step not similar to '[0-9]*';

select count(*)
from all_sessions
where totaltransactionrevenue is not null
and totaltransactionrevenue not similar to '[0-9]*';

select count(*)
from all_sessions
where productprice is not null
and productprice not similar to '[0-9]*';

select count(*)
from all_sessions
where productrevenue is not null
and productrevenue not similar to '[0-9]*';

select count(*)
from all_sessions
where transactionrevenue is not null
and transactionrevenue not similar to '[0-9]*';

select count(*)
from all_sessions
where time is not null
and time not similar to '[0-9]*';

select count(*)
from all_sessions
where timeonsite is not null
and timeonsite not similar to '[0-9]*';


/* Verify that all entries of the date column are 8-digit strings. */

select count(*)
from all_sessions
where date not similar to '[0-9]{8}';


/* Verify that all entries of several columns are null. */

select count(*)
from all_sessions
where productrefundamount is not null;

select count(*)
from all_sessions
where itemquantity is not null;

select count(*)
from all_sessions
where itemrevenue is not null;

select count(*)
from all_sessions
where searchkeyword is not null;
