with 

source as (

    select * from {{ source('staging', 'significant_earthquakes') }}

),

renamed as (

    select
        id,
        magnitude,
        felt,
        depth,
        latitude,
        longitude,
        distancekm,
        location,
        city,
        country,
        continent,
        year,
        week,
        date

    from source

)

select * from renamed
