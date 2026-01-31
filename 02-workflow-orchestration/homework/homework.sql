Question 4. How many rows are there for the Green Taxi data for all CSV files in the year 2020? 
with yeartable as (
SELECT
EXTRACT(YEAR FROM lpep_pickup_datetime) as pickup_year
FROM public.green_tripdata
)

SELECT
COUNT(*)
FROM yeartable
WHERE pickup_year = '2020'

-- second query 
SELECT COUNT(*)
FROM public.green_tripdata
WHERE EXTRACT(YEAR FROM lpep_pickup_datetime) = 2020

--both produces same result : 

-- 1,734,051