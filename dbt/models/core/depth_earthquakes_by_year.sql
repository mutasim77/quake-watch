{{ config(materialized="table") }}

select 
  year,
  AVG(depth) AS avg_depth
from {{ source("staging", "significant_earthquakes")}}
where depth IS NOT NULL
group by year
order by avg_depth desc