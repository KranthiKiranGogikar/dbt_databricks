{{
    config(
        materialized='view'
    )
}}

SELECT 
    origin_airport_name
    ,window
    ,COUNT(*) AS no_same_day_origin_flights
FROM {{ ref('airline_trips_silver') }}
WATERMARK ArrTimestamp DELAY OF INTERVAL 10 seconds airline_trips
GROUP BY
    origin_airport_name
    ,window(ArrTimestamp,"1 day")    