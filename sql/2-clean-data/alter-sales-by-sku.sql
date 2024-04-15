/* Update data types of the sales_by_sku table. */


alter table if exists sales_by_sku
	alter column total_ordered type integer using total_ordered::integer;
