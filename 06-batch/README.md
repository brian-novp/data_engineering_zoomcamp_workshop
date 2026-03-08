# Module 6 Homework

For this homework we will be using the Yellow 2025-11 data from the official website:

```bash
wget https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-11.parquet
```


## Question 1: Install Spark and PySpark

- Install Spark
- Run PySpark
- Create a local spark session
- Execute spark.version.

What's the output?

> [!NOTE]
> To install PySpark follow this [guide](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/06-batch/setup/)

Answer :
```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

print(f"Spark version: {spark.version}")
```

## Question 2: Yellow November 2025

Read the November 2025 Yellow into a Spark Dataframe.

Repartition the Dataframe to 4 partitions and save it to parquet.

What is the average size of the Parquet (ending with .parquet extension) Files that were created (in MB)? Select the answer which most closely matches.

- 6MB
- 25MB
- 75MB
- 100MB

Answer :
```python
df = spark.read.parquet("yellow_tripdata_2025-11.parquet")
df = df.repartition(4)
df.write.parquet('./yellow25/')

# and then in terminal, execute `ls -lh ./yellow25`.
```
  

## Question 3: Count records

How many taxi trips were there on the 15th of November?

Consider only trips that started on the 15th of November.

- 62,610
- 102,340
- 162,604
- 225,768

Answer:
```python
# Register as temp view so we can use SQL
df.createOrReplaceTempView("yellow_taxi")

# Using Spark SQL
count_sql = spark.sql("""
    SELECT COUNT(*) AS trip_count
    FROM yellow_taxi
    WHERE DATE(tpep_pickup_datetime) = '2025-11-15'
""").head()

```

## Question 4: Longest trip

What is the length of the longest trip in the dataset in hours?

- 22.7
- 58.2
- 90.6
- 134.5

Answer:
```python


df_dur = df.withColumn(
    "trip_duration",
    (F.unix_timestamp("tpep_dropoff_datetime")
     - F.unix_timestamp("tpep_pickup_datetime")) / 3600
)

max_duration = df_dur.agg(F.max("trip_duration")).first()
print(max_duration)
```

## Question 5: User Interface

Spark's User Interface which shows the application's dashboard runs on which local port?

- 80
- 443
- 4040
- 8080

Answer:
```python
#assuuming a SparkSession already initiated as object named `spark`
print(spark.sparkContext.uiWebUrl)
```


## Question 6: Least frequent pickup location zone

Load the zone lookup data into a temp view in Spark:

```bash
wget https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv
```

Using the zone lookup data and the Yellow November 2025 data, what is the name of the LEAST frequent pickup location Zone?

- Governor's Island/Ellis Island/Liberty Island
- Arden Heights
- Rikers Island
- Jamaica Bay

Answer :
```python
zones = spark.read.csv(
    "taxi_zone_lookup.csv",
    header=True,
    inferSchema=True
)

zones.createOrReplaceTempView("zones")

least_freq_pickup = spark.sql("""
    SELECT
        z.Zone,
        z.Borough,
        COUNT(*) AS trip_count
    FROM yellow_taxi t
    LEFT JOIN zones z ON t.PULocationID = z.LocationID
    WHERE z.Zone IS NOT NULL
    GROUP BY z.Zone, z.Borough
    ORDER BY trip_count ASC
    LIMIT 10
""")

print("10 least frequent pickup zones:")
least_freq_pickup.show(truncate=False)
```
