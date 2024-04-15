/* Update data types of the products table. */


/* Set column data types. */
alter table if exists products
	alter column orderedquantity type integer using orderedquantity::integer,
	alter column stocklevel type integer using stocklevel::integer,
	alter column restockingleadtime type integer using restockingleadtime::integer,
	
	alter column sentimentscore type real using sentimentscore::real,
	alter column sentimentmagnitude type real using sentimentmagnitude::real;
	