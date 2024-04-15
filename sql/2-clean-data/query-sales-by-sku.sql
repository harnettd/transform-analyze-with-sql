/* Query sales_by_sku to determine appropriate data types for each column. */

/* Verify that total_ordered is either null or is a string of digits. */
select count(*)
from sales_by_sku
where total_ordered is not null
and total_ordered not similar to '[0-9]*'
;