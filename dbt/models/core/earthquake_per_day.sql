{{ config(materialized="table") }}

select
    count(id) as n_earthquakes,
    date,
    week,
    year,
    {{ assign_alert_color("magnitude") }} as alert
from {{ source("staging", "earthquake_data") }}
group by year, week, date, alert
order by date