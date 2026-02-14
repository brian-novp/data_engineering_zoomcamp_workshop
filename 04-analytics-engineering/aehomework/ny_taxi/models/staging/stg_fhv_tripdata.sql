with source as (
    select * from {{ source('fhv', 'fhv_tripdata')}}
),

cleaned as (
    select
        -- identifiers
        cast(dispatching_base_num as string),
        cast(PUlocationID as integer) as pickup_location_id,
        cast(DOlocationID as integer) as dropoff_location_id,
        try_cast(Affiliated_base_number as string) as affiliated_base_number,

        -- timestamps
        cast(pickup_datetime as timestamp) as pickup_datetime,
        cast(dropOff_datetime as timestamp) as dropoff_datetime,
        
        --trip info
        try_cast(SR_Flag as integer) as sharedride_flag
    from source
    where dispatching_base_num is not null
)

select * from cleaned