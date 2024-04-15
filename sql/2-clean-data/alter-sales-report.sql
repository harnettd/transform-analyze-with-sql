/* Update data types of the sales_report table. */


/* Set column data types. */
alter table if exists sales_report
	alter column total_ordered type integer using total_ordered::integer,
	alter column stocklevel type integer using stocklevel::integer,
	alter column restockingleadtime type integer using restockingleadtime::integer,
	
	alter column sentimentscore type real using sentimentscore::real,
	alter column sentimentmagnitude type real using sentimentmagnitude::real,
	alter column ratio type real using ratio::real;
	