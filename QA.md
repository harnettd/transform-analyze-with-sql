# Quality Assurance

## Risk Areas

What are your risk areas? Identify and describe them.

The risk areas that I identified as problemmatic as I worked on this project are:

- Consistency
    - The data in a particular column should conform to a particular format. Perhaps there is only a finite set of values that the column entries can take. Also, synonyms for null should be replaced by null.
- Validity and Accuracy
    - The values appearing in a column should firstly, represent allowed values of the quantity in question, and secondly, the allowed value should actually be correct. For example, an age of -16 is clearly invalid whereas an age of 16 is valid. However, the age of 16, while a valid value, might actually be inacurrate. Gnerally speaking, it is perhaps easier to test for validity than accuracy.  
- Uniqueness
    - The values in certain columns must be unique and non-null. In particular, this holds for (non-composite) primray keys. 
- Completeness
    - Where possible, null values should be replaced with actual data. 


## QA Process:
Describe your QA process and include the SQL queries used to execute it.

Considering the areas of consistency, accuracy & validity, uniqueness, and completeness, I would use the following collection of scripts to look for problemmatic data. Note that I focus on all_sessions as it has the most columns. Similar considerations apply to the other tables.

### Consistency


Currently, the fullvisitorid entries are digit-strings of varying length. By padding with leading zeroes, for instance, they could all be made the same length, say, 24 digits Then, counting inconsistencies could be done with

```sql
select count(fullvisitorid) from all_sessions
where fullvisitorid not similar to '[0-9]{24}';
```

Similar considerations hold for all_sessions.time.

The entries of the channelgrouping column are generally from a small set. Inconsistencies could be counted with

```sql
select count(*) from all_sessions
where channelgrouping not in ('Referral', 'Organic Search', 'Direct', 'Social', 'Affiliates', 'Paid Search', 'Display');
```

Similar consideration hold for the type column.

For timeonsite, we need to find out the intended units of time. I suspect it's seconds, but can't sure.

For productvariant, there are many values of '(not set)' which would be better set as null. This would be simple enough to do:

```sql
update all_sessions
set productvariant = null 
where productvariant = '(not set)';
```

I probably should have done this while cleaning the data, but this column didn't play any role in the data analysis.

### Validity and Accuracy 

The entries of totaltransactionrevenue represent should likely all be non-negative-valued. A count of negative values could be generated from 

```sql
select count(*) from all_sessions
where totaltransactionrevenue < 0;
```

Similar considerations hold for transactions, pageviews, sessionqualitydim, productquantity, productprice, productrevenue, transactionrevenue, and transactionid.

Regarding the date column, the entries should all be later than some earliest possible date---perhaps the date the site launched. Using 2023-01-01 as an example launch date, a count of clearly incorrect date entries could be found with

```sql
select count(date) from all_sessions
where date < to_date('2023-01-01');
```

One place where validity was a particular problem in this project concerned foreign keys not being elements of the appropriate primary-key column from some other table. The productsku column of all_sessions is in this category. The offending foreign keys can be found with the following type of query:

```sql
select distinct productsku
from all_sessions
where productsku not in (
	select distinct sku
	from products
);
```

Perhaps it would be best to drop the corresponding rows from the all_sessions table.

### Uniqueness

 In particular, (non-composite) primary keys must satisfy these requirements. To test that a particular column's entries are indeed non-null and unique, using products.sku as an example, I would run

```sql
select count(*) from products;
select count(distinct sku) from products;
```

For a unique, non-null attrtibute, the two counts would be the same. Note that, for a composite primary key, the second query would include additional column names. In principle, the above check could be applied to all_sessions.visitid, but, as noted earlier, there is some duplication in that particular attribute. Also, whatever ultimately gets selected as the (possibly composite) primary key for analytics would also have to pass this test. 


To prevent new data being added to the database that doesn't conform to these rules concerning uniqueness and non-nullability, constraints could be added to attributes along the lines of

```sql
alter table products 
add constraint constraintname unique (sku);
```

or

```sql
alter table products
alter column set not null sku;
```

To designate an attribute as the primary key, I would use

```sql
alter table products
add primary key sku;
```

Then, uniqueness and non-nullability would be automatically enforced.


### Completeness

In the currencycode column, all entries are 'USD', except for a handful which are null. It seems likely that the null values should actually be 'USD' and could easily be changed.

Finally, I would note that there are several columns that contain almost no non-null entries including transactionid and transactionrevenue. It seems as if these columns are so incomplete as to be useless and, perhaps, could be outright dropped from the table.