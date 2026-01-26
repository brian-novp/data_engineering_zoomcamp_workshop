-- For the trips in November 2025, how many trips had a trip_distance of less than or equal to 1 mile? 
with cte_trunc as (
select 
*,
DATE_TRUNC('month', lpep_pickup_datetime)::date as month_pickup
from public.green_taxi_data
where trip_distance <= 1)

select count(*)
from cte_trunc
where month_pickup = '2025-11-01'

-- Which was the pick up day with the longest trip distance? Only consider trips with trip_distance less than 100 miles 
with cte_trunc as (
select 
lpep_pickup_datetime
,trip_distance
from public.green_taxi_data
where trip_distance <= 100
order by trip_distance desc)

select *
from cte_trunc

-- Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?
with cte_trunc as (
select
"Zone"
,total_amount
,lpep_pickup_datetime::date as date_pickup
from public.green_taxi_data as gtd
left join public.taxi_zone as tz
on gtd."PULocationID" = tz."LocationID")

select
"Zone"
,sum(total_amount) as sum_total
,date_pickup
from cte_trunc
where date_pickup = '2025-11-18'
group by 1, 3
order by 2 desc

-- For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?
SELECT
tz_drop."Zone" as dropoff_zone
, MAX(gtd.tip_amount) as max_tip
from public.green_taxi_data as gtd
left join public.taxi_zone as tz_pickup
on gtd."PULocationID" = tz_pickup."LocationID"
left join public.taxi_zone as tz_drop
on gtd."DOLocationID" = tz_drop."LocationID"
where tz_pickup."Zone" = 'East Harlem North'
AND gtd.lpep_pickup_datetime >= '2025-11-01'
AND gtd.lpep_pickup_datetime < '2025-12-01'
group by 1
order by 2 desc
limit 5;