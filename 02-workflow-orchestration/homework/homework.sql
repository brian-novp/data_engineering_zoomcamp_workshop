-- Question 4 #########
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


-- Question 5 #######
with month_table as (
    SELECT
    DATE_TRUNC('month', tpep_pickup_datetime) as pickup_month_year
    FROM public.yellow_tripdata
    )

    SELECT
    COUNT(*)
    FROM month_table
    WHERE pickup_month_year = '2021-03-01'