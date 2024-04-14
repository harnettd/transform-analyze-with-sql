/* Create the starting tables of the ecommerce database.
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
