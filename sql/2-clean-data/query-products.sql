/* Query products to determine appropriate data types for each column. */


/* Verify that each entry of several columns are either null or a string of digits. */

select count(*)
from products
where orderedquantity is not null
--and orderedquantity not similar to '[0-9]*'
;

select count(*)
from products
where stocklevel is not null
--and stocklevel not similar to '[0-9]*'
;

select count(*)
from products
where restockingleadtime is not null
--and restockingleadtime not similar to '[0-9]*'
;

/* Verify that each entry of each column is either null or something that
 * can be cast as real. */

select count(*)
from products
where sentimentscore is not null
and sentimentscore not similar to '-?[0-9]*.[0-9]*'
;

select count(*)
from products
where sentimentmagnitude is not null
and sentimentmagnitude similar to '[0-9]*.[0-9]*'
;



