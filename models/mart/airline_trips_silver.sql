{{
    config(
        materialized='table'
        )
}}

WITH 

origin_airport_codes as (

    SELECT
        iata_code
        ,municipality origin_city
        ,name as origin_airport_name
        ,elevation_ft::INT origin_elevation_ft
        ,split(coordinates,',') as origin_coordinates_array
    FROM {{ source('lineagedemo','airport_codes') }}

),

dest_airport_codes as (

    SELECT
        iata_code
        ,municipality dest_city
        ,name as dest_airport_name
        ,elevation_ft::INT dest_elevation_ft
        ,split(coordinates,',') as dest_coordinates_array
    FROM {{ source('lineagedemo','airport_codes') }}

),

airline_names as (

    SELECT iata, name as airline_name FROM {{ source('lineagedemo','airline_codes') }}
),

bronze_stream as (

    SELECT 
        *
    FROM {{ source('lineagedemo','airline_trips_bronze') }} 
),

final as (

SELECT 
  {{ dbt_utils.generate_surrogate_key([
                'ArrTimestamp'
            ])
        }} as delay_id
  ,ActualElapsedTime
  ,ArrDelay::INT
  ,CRSArrTime 
  ,CRSDepTime 
  ,CRSElapsedTime 
  ,Cancelled::INT
,DayOfWeek
  ,DayOfMonth
  ,Month
  ,Year
  ,DepDelay::INT
  ,DepTime 
  ,Dest 
  ,Distance 
  ,Diverted::INT
  ,FlightNum 
  ,IsArrDelayed 
  ,IsDepDelayed
  ,Origin 
  ,UniqueCarrier
  ,airline_names.airline_name
  ,origin_city
  ,origin_airport_name
  ,origin_elevation_ft
  ,origin_coordinates_array
  ,dest_city
  ,dest_airport_name
  ,dest_elevation_ft
  ,dest_coordinates_array
  ,file_modification_time
  ,ArrTimestamp :: timestamp
FROM bronze_stream
INNER JOIN origin_airport_codes
  ON bronze_stream.Origin = origin_airport_codes.iata_code
INNER JOIN dest_airport_codes
  ON bronze_stream.Dest = dest_airport_codes.iata_code  
INNER JOIN airline_names 
  ON bronze_stream.UniqueCarrier = airline_names.iata
)

SELECT * FROM STREAM(final)