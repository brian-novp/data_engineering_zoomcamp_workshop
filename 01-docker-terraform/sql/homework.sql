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

