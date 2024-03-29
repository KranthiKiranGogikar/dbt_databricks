{{
    config(
        materialized='table'
    )
}}

    SELECT 
        airline_name
        ,COUNT(*) AS no_flights
        ,SUM(IF(IsArrDelayed = TRUE,1,0)) AS tot_delayed
        ,ROUND(tot_delayed*100/no_flights,2) AS perc_delayed
        FROM {{ ref('airline_trips_silver') }}
        WHERE airline_name IS NOT NULL
        GROUP BY 1