/* Update the sales_by_sku table. */


/* Update column data types. */
alter table if exists sales_by_sku
	alter column total_ordered type integer using total_ordered::integer;

/* Delete rows where foreign key is invalid. */
delete from sales_by_sku
where productsku not in (
	select distinct sku 
	from products
);

/* After the above deletions, sales_by_sku is redundant. */
drop table if exists sales_by_sku;