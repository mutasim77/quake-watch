{{ config(materialized="table") }}

select
    id,
    date,
    country,
    longitude,
    latitude,
    magnitude,
    {{ assign_magnitude_description("magnitude") }} as description
from {{ source("staging", "earthquake_data") }}
