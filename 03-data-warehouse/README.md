# Data
In this homework, I worked with NYC Yellow Taxi Trip Records from January 2024 to June 2024.

The data is provided as Parquet files by NYC TLC and is available at:
https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page

Only the first six months of 2024 were used for this assignment.
## Loading the data to GCS

To load the data into Google Cloud Storage, I used: [yellow_taxi_data_gcs.py](https://github.com/brian-novp/data_engineering_zoomcamp_workshop/blob/main/03-data-warehouse/yellow_taxi_data_gcs.py)

This python script performs the following steps:

    Downloads the Parquet files for January–June 2024
    Creates a GCS bucket if it does not already exist
    Uploads all six Parquet files to the bucket

Authentication is handled using a Google Cloud Service Account, and the bucket name is configured directly in the script.

# BigQuery Setup

Create an external table using the Yellow Taxi Trip Records.  
```sql
-- Creating an External Table by reading GCS Bucket
CREATE OR REPLACE EXTERNAL TABLE `your_project.your_dataset.tablename_ext`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://your-bucket-name/yellow_tripdata_2024-*.parquet']
);

```


Create a (regular/materialized) table in BQ using the Yellow Taxi Trip Records (do not partition or cluster this table). We can do this in two ways:   
```sql
-- Creating a Regular Table from an External Table
CREATE OR REPLACE TABLE `your_project.your_dataset.tablename`
AS
SELECT * FROM `your_project.your_dataset.tablename_ext`;
-- create a table from an external table from the first setup

```
```sql
-- Directly loading data from GCS into a regular BigQuery table without creating an external table using federated query
CREATE OR REPLACE TABLE `your_project.your_dataset.yellow_taxi_table`
OPTIONS (
  format = 'PARQUET'
) AS
SELECT * FROM `your_project.your_dataset.external_table_placeholder`
FROM EXTERNAL_QUERY(
  'your_project.region-us.gcs_external',
  'SELECT * FROM `gs://your-bucket-name/yellow_tripdata_2024-*.parquet`'
);
-- FROM EXTERNAL_QUERY is a federated query
```
[Federated query](https://docs.cloud.google.com/bigquery/docs/federated-queries-intro)  
[External data sources](https://docs.cloud.google.com/bigquery/docs/external-data-sources)  
[Intro to Table](https://docs.cloud.google.com/bigquery/docs/tables-intro#:~:text=Standard%20BigQuery%20tables:%20structured%20data,by%20using%20a%20SQL%20query.)  

## Question 1 Counting Records
What is count of records for the 2024 Yellow Taxi Data?

- 65,623
- 840,402
- 20,332,093
- 85,431,289

Because we already ingested only the necessary data from January 2024 to June 2024, so the query is simple :
```sql
SELECT COUNT(*)
FROM <tablename>
```
or we can see the details of a table by clicking the table and Details tab
## Question 2 Data read estimation
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables. What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
- 18.82 MB for the External Table and 47.60 MB for the Materialized Table
- 0 MB for the External Table and 155.12 MB for the Materialized Table
- 2.14 GB for the External Table and 0MB for the Materialized Table
- 0 MB for the External Table and 0MB for the Materialized Table

BigQuery leverages Parquet metadata and query planning optimizations to compute the result without scanning the underlying data files. As a result, the estimated bytes processed for external table is 0 MB.
```sql
SELECT 
COUNT(DISTINCT PULocationID)
FROM <tablename_external>
-- execute the query then see the job information, write the size and then run new query
```
In materialized table, data is stored in BigQuery, so BQ needs to scan the data required, hence the 155.12 MB
```sql
SELECT 
COUNT(DISTINCT PULocationID)
FROM <tablename>
-- and then see the job information, compare with the first query
```

## Question 3 Understanding columnar storage
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table.  
Why are the estimated number of Bytes different?

- BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.
- BigQuery duplicates data across multiple storage partitions, so selecting two columns instead of one requires scanning the table twice, doubling the estimated bytes processed.
- BigQuery automatically caches the first queried column, so adding a second column increases processing time but does not affect the estimated bytes scanned.
- When selecting multiple columns, BigQuery performs an implicit join operation between them, increasing the estimated bytes processed

```sql
-- 155.12 MB data scanned
SELECT 
COUNT(DISTINCT PULocationID)
FROM <tablename>

--2nd query 310.24 MB data scanned
SELECT 
COUNT(DISTINCT PULocationID),
COUNT(DISTINCT DOLocationID)
FROM <tablename>
```
Answer : As a columnar database, BQ only scans the mentioned columns inside the query. Adding a column means BQ needs to scan more data compared to scanning a column only.


 ## Question 4 Counting zero fare trips
How many records have a fare_amount of 0?

- 128,210
- 546,578
- 20,188,016
- 8,333
```sql
SELECT COUNT(*) AS zero_fare_trips
FROM <tablename>
WHERE fare_amount = 0;
```

## Question 5 Partitioning and clustering
What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)
- Partition by tpep_dropoff_datetime and Cluster on VendorID
- Cluster on by tpep_dropoff_datetime and Cluster on VendorID
- Cluster on tpep_dropoff_datetime Partition by VendorID
- Partition by tpep_dropoff_datetime and Partition by VendorID  

Answer : as of 2026, BQ partition limitation is increased to 10000 from the former 4000. It is better to ask the data analysts or data scientist first, in which partition style they want. In this time-related column context of tpep_dropoff_datetime : Partitioning in daily or monthly setting can cover approx 27 years of data and 830 years of data respectively, while hourly partitioning can cover 416 days (10000 partition limit). In this scenario, the analysis will be based on days, and analysts use VendorID for analysis, so the DDL query to create the table:
```sql
CREATE OR REPLACE TABLE `your_project.your_dataset.yellow_taxi_table`
PARTITION BY TIMESTAMP_TRUNC(tpep_dropoff_datetime, DAY)
CLUSTER BY VendorID
OPTIONS (
  format = 'PARQUET'
) AS
SELECT * FROM `your_project.your_dataset.external_table_placeholder`
FROM EXTERNAL_QUERY(
  'your_project.region-us.gcs_external',
  'SELECT * FROM `gs://your-bucket-name/yellow_tripdata_2024-*.parquet`'
);
```  
[Creating a partitioned table](https://docs.cloud.google.com/bigquery/docs/creating-partitioned-tables#sql_2)
## Question 6 Partition benefits
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive). Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values?


Choose the answer which most closely matches.
- 12.47 MB for non-partitioned table and 326.42 MB for the partitioned table
- 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table
- 5.87 MB for non-partitioned table and 0 MB for the partitioned table
- 310.31 MB for non-partitioned table and 285.64 MB for the partitioned table


```sql
-- Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)
-- This query scans the entire table because it is not partitioned, even though a date filter is applied. As a result, BigQuery estimates 310.24 MB of data processed.
SELECT (DISTINCT VendorID)
FROM <tablename>
WHERE DATE(tpep_dropoff_datetime) BETWEEEN '2024-03-01' AND '2024-03-16'

-- Now change the table in the from clause to the partitioned table from question 5
-- This table is partitioned by tpep_dropoff_datetime, so BigQuery only scans the partitions (the segment) within the specified date range. As a result, the estimated data processed is reduced from 310.24 MB to 26.84 MB.
SELECT (DISTINCT VendorID)
FROM <tablename_q5>
WHERE DATE(tpep_dropoff_datetime) BETWEEEN '2024-03-01' AND '2024-03-16'
```

## Question 7 External table storage
Where is the data stored in the External Table you created?
- Big Query
- Container Registry
- GCP Bucket
- Big Table  
[External Table](https://docs.cloud.google.com/bigquery/docs/external-tables)  

## Question 8 Clustering best practices
It is best practice in Big Query to always cluster your data:
- True
- False  
Answer : Clustering should be applied based on query patterns and data size. This means, ask the stakeholders first before making data warehouse (ask data analyst, data scientist, business users, etc) and explore the data ourselves.  

Small tables (< 1GB) or workloads that do not frequently filter or aggregate on specific columns, when clustered, provides little to no performance improvement and can add unnecessary complexity when creating our data warehouse.
[BigQuery Storage Explained](https://cloud.google.com/blog/topics/developers-practitioners/bigquery-explained-storage-overview)

## Question 9 Understanding table scans
No Points: Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?


Answer : BigQuery dry run estimates 0 bytes processed for this query.  

Why? A COUNT(*) in a BigQuery materialized view (or table derived from Parquet) scans 0 bytes because BigQuery uses metadata stored in the table's footer (specifically row counts in Parquet footer metadata or BigQuery's own snapshot metadata) rather than scanning the actual data. This occurs for fully aggregated materialized views or when the query is served directly from pre-computed query results. (Metadata Optimization)  

Queries that make BQ to scan data (relevant columns) which results in non-zero bytes:
- DISTINCT
- filtering conditions (WHERE) or selecting specific columns