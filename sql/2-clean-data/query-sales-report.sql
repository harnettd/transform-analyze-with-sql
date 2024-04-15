/* Query sales_report to determine appropriate data types for each column. */


/* Verify that each entry of several columns are either null or a string of digits. */

select count(*)
from sales_report
where total_ordered is not null
and total_ordered not similar to '[0-9]*'
;

select count(*)
from sales_report
where stocklevel is not null
and stocklevel not similar to '[0-9]*'
;

select count(*)
from sales_report
where restockingleadtime is not null
and restockingleadtime not similar to '[0-9]*'
;

/* Verify that each entry of each column is either null or something that
 * can be cast as real. */

select count(*)
from sales_report
where sentimentscore is not null
and sentimentscore not similar to '-?[0-9]*.[0-9]*'
;

select count(*)
from sales_report
where sentimentmagnitude is not null
and sentimentmagnitude not similar to '[0-9]*.[0-9]*'
;

select count(*)
from sales_report
where ratio is not null
and ratio not similar to '[0-9]*.[0-9]*'
;
