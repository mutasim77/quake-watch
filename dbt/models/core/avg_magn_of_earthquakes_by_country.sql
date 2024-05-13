{{ config(materialized="table") }}

select 
  country,
  AVG(magnitude) as avg_magnitude
from {{ source("staging", "central_asia_eearthquakes") }}
where country NOT IN ('Uzbekistan-Tajikistan border', 'China-Kyrgyzstan border', 'Uzbekistan-Kyrgyzstan border')
group by country
order by avg_magnitude desc