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
    FROM <dbname>
    WHERE EXTRACT(YEAR FROM <timestamp column>) = 2020
    ```

# Question 4
## How many rows are there for the Green Taxi data for all CSV files in the year 2020?
    Answer : Using CTE
    ```sql
    with yeartable as (
    SELECT
    EXTRACT(YEAR FROM <timestamp column>) as pickup_year
    FROM <dbname>
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
    FROM <dbname>
    )

    SELECT
    COUNT(*)
    FROM month_table
    WHERE pickup_month_year = '2020-03-01'
    ```


# Question 6
## How would you configure the timezone to New York in a Schedule trigger?
    Answer : read kestra schedule plugins [docs](https://kestra.io/plugins/core/trigger/io.kestra.plugin.core.trigger.schedule#properties_timezone-body) 