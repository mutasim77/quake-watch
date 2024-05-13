with 

source as (

    select * from {{ source('staging', 'central_asia_eearthquakes') }}

),

renamed as (

    select
        date,
        time,
        latitude,
        longitude,
        depth,
        magnitude,
        country

    from source

)

select * from renamed
