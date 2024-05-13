with 

source as (

    select * from {{ source('staging', 'earthquake_data') }}

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
        country,
        city,
        continent,
        year,
        week,
        date

    from source

)

select * from renamed
