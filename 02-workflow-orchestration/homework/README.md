# Question 1
## Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)? 
Answer : Check the 01-postgre-scheduled.yaml , make sure before doing backfill execution, task id purge_files is ommited. Save the flow and do backfill execution from the appropriate date by also considering the cron expression inside the Trigger Schedule. After the Flow is finished, go to Execution menu and click the execution of the corresponding flow. go to output tab and click the task_id that has the task, click outputFiles then click the file, you will se the size in MBs at the right side of the UI.

# Question 2
## What is the rendered value of the variable file when the inputs taxi is set to green, year is set to 2020, and month is set to 04 during execution? 
Answer : self explanatory.

# Question 3
## How many rows are there for the Yellow Taxi data for all CSV files in the year 2020? 
Answer : 
```sql
SELECT COUNT(*)
FROM <tablename>
WHERE EXTRACT(YEAR FROM <timestamp column>) = 2020
```

# Question 4
## How many rows are there for the Green Taxi data for all CSV files in the year 2020?
Answer : Using CTE
```sql
with yeartable as (
SELECT
EXTRACT(YEAR FROM <timestamp column>) as pickup_year
FROM <tablename>
)

SELECT
COUNT(*)
FROM yeartable
WHERE pickup_year = '2020'
```

# Question 5
## How many rows are there for the Yellow Taxi data for the March 2021 CSV file?
Answer : 
```sql
with month_table as (
SELECT
EXTRACT(YEAR FROM <timestamp column>) as pickup_month_year
FROM <tablename>
)

SELECT
COUNT(*)
FROM month_table
WHERE pickup_month_year = '2020-03-01'
```


# Question 6
## How would you configure the timezone to New York in a Schedule trigger?
Answer : read kestra schedule plugins [docs](https://kestra.io/plugins/core/trigger/io.kestra.plugin.core.trigger.schedule#properties_timezone-body) 

# Lesson Learned
1. Before moving the data, make sure to understand the behaviour both from source and destination. In this case the csv files and postgre or BigQuery. I found that some transformation are not needed if we ingest csv to system A or system B. BigQuery does not need help that much because it can infer data type correctly. I tried to transformed some columns when ingesting csvs to postgre, like changing the vendorID from int to str or ratecodeid from text to int, the result was strange, not compatible for analysis.
2. The difference of speed when querying data is phenomenal between OLTP and OLAP. PostgreSQL without any extension installed needed more than 10 seconds in average to answer  homework questions for green taxi trip data , more than a minute to answer questions about yellow taxi trip data. Most of yellow taxi trip data csvs (monthly) have 100Mb-ish size, meanwhile green trip data csvs have less than 50MB-ish. BigQuery complete the tasks much faster. 
3. Auto purging files feature in Kestra help manage storage easier. But this is cumbersome for me because I did this project inside wsl2 which use virtual harddisk (vhdx file). This means if I delete files inside wsl2, it does not auto reclaim my SSD space. I have to reclaim my SSD space manually by using diskpart and compactdisk feature in powershell.
4. Need to base the data movement from business requirements, so we can do meaningful transformation/data movement.