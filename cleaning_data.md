# Cleaning the Data

## What issues will you address by cleaning the data?

1. Set an appropriate data type for each column of each table.


## Queries:

The data for this project was provided in the form of five csv files, one for each table to be created in a postgreSQL database called `ecommerce`. Each table was named as the basename of its corresponding csv file. Column headers for each table came from the first line of the table's corresponding csv file. Initially, all columns of all tables were set to data type `text` as this prevented import errors. I created the tables with

```sql
* Create the starting tables of the ecommerce database.
 * 
 * Table names are snake case and match the basename of a
 * corresponding csv file. The data type of each column is 
 * set to text. Data will be loaded into each table from its
 * corresponding csv file. After inspecting the data, some 
 * column data types will be altered to something more 
 * appropriate than text.
 */


drop table if exists all_sessions;
create table all_sessions (
	fullVisitorId text,
	channelGrouping text,
	time text,
	country text,
	city text,
	totalTransactionRevenue text,
	transactions text,
	timeOnSite text,
	pageviews text,
	sessionQualityDim text,
	date text,
	visitId text,
	type text,
	productRefundAmount text,
	productQuantity text,
	productPrice text,
	productRevenue text,
	productSKU text,
	v2ProductName text,
	v2ProductCategory text,
	productVariant text,
	currencyCode text,
	itemQuantity text,
	itemRevenue text,
	transactionRevenue text,
	transactionId text,
	pageTitle text,
	searchKeyword text,
	pagePathLevel1 text,
	eCommerceAction_type text,
	eCommerceAction_step text,
	eCommerceAction_option text
);


drop table if exists analytics;
create table analytics (
	visitNumber text,
	visitId text,
	visitStartTime text,
	date text,
	fullvisitorId text,
	userid text,
	channelGrouping text,
	socialEngagementType text,
	units_sold text,
	pageviews text,
	timeonsite text,
	bounces text,
	revenue text,
	unit_price text
);


drop table if exists products;
create table products (
	SKU text,
	name text,
	orderedQuantity text,
	stockLevel text,
	restockingLeadTime text,
	sentimentScore text,
	sentimentMagnitude text
);


drop table if exists sales_report;
create table sales_report (
	productSKU text,
	total_ordered text,
	name text,
	stockLevel text,
	restockingLeadTime text,
	sentimentScore text,
	sentimentMagnitude text,
	ratio text
);

drop table if exists sales_by_sku;
create table sales_by_sku (
	productSKU text,
	total_ordered text
);

```

Importing data was done using pgAdmin4. Once all data was successfully imported, the number of rows imported per table was determined with

```sql
/* Count the number of rows in each table of the ecommerce database. */

select count(*) from all_sessions;
select count(*) from analytics;
select count(*) from products;
select count(*) from sales_by_sku;
select count(*) from sales_report;
``` 

Each of these results matched the number of record lines from the table's corresponding csv file which could be determined from the linux command line with

```sh
wc -l all_sessions.csv
```

for example. Finally, the `ecommerce` database was backed up from the linux command line with

```sh
pg_dump -d ecommerce -F tar -f ecommerce-text.tar
``` 

### Setting Data Types

#### The all_sessions Table

- All entries of the columns transactions, pageviews, sessionqualitydim, productquantity, ecommerceaction_type, and ecommerceaction_step are either `null` or strings of digits. This was determined with a query like

```sql
select count(*)
from all_sessions
where transactions is not null
and transactions not similar to '[0-9]*';

```

which returned a count of 0. As such, each of these columns was cast as `integer`. (Note that this sort of query is performed repeatedly in what follows. In such cases, I don't include the SQL code again.)

- All entries of the columns totaltransactionrevenue, productprice, productrevenue, and transactionrevenue are also either `null` or strings of digits. However, I assumed that these columns contain monetary values. As such, I casted them as `numeric` rather than `integer`.

- Every entry in the date column is an eight-digit string as can be verifed with the query

```sql
select count(*)
from all_sessions
where date not similar to '[0-9]{8}';
```

which returns a value of 0. Therefore, I cast the date column as `date`, assuming that the format for each entry was 'YYYYMMDD'. (Note that this type of query is used again in what follows. In such cases, I don't include the SQL code again.)

- All entries in the productrefundamount, itemquantity, itemrevenue, and searchkeyword columns are `null` as can be veried with something like the query

```sql
select count(*)
from all_sessions
where productrefundamount is not null;
```

which gives 0. Therefore, for the time being, I left these columns typed as `text`. (Note that this type of query is used repeatedly in what follows. In such cases, I don't include the SQL code again.)

- All entries of the time column are either `null` or a string of digits. Ideally, I would like to cast this column as `time`; however, I can't because it's not clear what the digits mean. There are three-, four-, and five-digit entries as well as many '0's. Without more information, I think it's best to leave this column as `text`. 

- Similarly, all entries of the timeonsite column are either `null` or a string of digits. Ideally, I would like to cast this column as `interval`; However, it's not clear what the unit of measurement is: seconds, minutes, something else? Again, without more information, I think it's best to leave this column as `text`.

For those columns not explicitly mentioned above, the data type was left as `text`.

I implemented the above with

```sql
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
```

#### The analytics Table

- All entries of the columns visitnumber, pageviews, bounces, are either `null` or strings of digits. Therefore, I set the data type of these columns as `integer`.

- It seems like visitstarttime might be an `interval`. However, the entries of this column generally have more than six digits and so don't look like times at all. Without more information, I think it is best to leave this column as `text`.

- All entries of the date column are strings of eight digits. Assuming these digits are formatted as 'YYYYMMDD', I set the date type of this column to `date`.

- All entries of the column units_sold are either `null` or strings of digits or, in one case, '-89'. Regardless, I set this columns' data type to `integer`.

- All entries in the userid column are `null`, so we leave the column's type as `text`.

- All entries of the column timeonsite are either `null` or strings of digits. I would like to cast these entries as `interval`, but I don't know what the units of time should be. As such, I left this column as `text`.

- All entries of the columns revenue and unit_price are either `null` or strings of digits. Rather than type these columns as `integer`, however, I typed them as `numeric` as they appear to contain monetary values. 

All columns not explicitly mentioned above were left as `text`. The above alterations were implemented with

```sql
/* Set column data types. */
alter table if exists analytics
	alter column visitnumber type integer using visitnumber::integer,
	alter column units_sold type integer using units_sold::integer,
	alter column pageviews type integer using pageviews::integer,
	alter column bounces type integer using bounces::integer,
	
	alter column revenue type numeric using revenue::numeric,
	alter column unit_price type numeric using unit_price::numeric,
	
	alter column date type date using to_date(date, 'YYYYMMDD');
```

#### The products Table

- All entries of the columns orderedquantity, stocklevel, restockingleadtime are either `null` or strings of digits. As such, I typed all of these columns as `integer`.

- All entries of the columns sentimentscore and sentimentscoremagnitude appear to resemble real numbers as can be deduced from the query

```sql
select count(*)
from products
where sentimentscore is not null
and sentimentscore not similar to '-?[0-9]*.[0-9]*';
```

for example, which yields zero. Tus, I typed these two columns as `real`. (This type of query is used again below. In such cases, I omit the SQL code.)

All columns not explicitly discussed above were left as `text`. The indicated alterations were implemented with

 ```sql
 /* Set column data types. */
alter table if exists products
	alter column orderedquantity type integer using orderedquantity::integer,
	alter column stocklevel type integer using stocklevel::integer,
	alter column restockingleadtime type integer using restockingleadtime::integer,
	
	alter column sentimentscore type real using sentimentscore::real,
	alter column sentimentmagnitude type real using sentimentmagnitude::real;
 ```

 #### The sales_by_sku Table

- I left the productsku column as `text`.

- All entries of the total_ordered column are either `null` or a string of digits. As such, I set the type of this column to `integer` with

```sql
alter table if exists sales_by_sku
	alter column total_ordered type integer using total_ordered::integer;
```

#### The sales_report Table

- All entries of the columns total_ordered, stocklevel, and restockingleadtime are either `null` or strings of integers. As such,  typed these columns as `integer`.

- All entries of the columns sentimentscore, sentimentmagnitude, and ratio appear to be string representations of real numbers. As such, I typed these columns as `real`.

Any column not mentioned above was left as `text`. The type changes dscribed above were implemented with

```sql
/* Set column data types. */
alter table if exists sales_report
	alter column total_ordered type integer using total_ordered::integer,
	alter column stocklevel type integer using stocklevel::integer,
	alter column restockingleadtime type integer using restockingleadtime::integer,
	
	alter column sentimentscore type real using sentimentscore::real,
	alter column sentimentmagnitude type real using sentimentmagnitude::real,
	alter column ratio type real using ratio::real;
```

