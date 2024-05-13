select 
  case 
    when magnitude < 4 then 'Minor (<4)'
    when magnitude < 6 then 'Moderate (4-5.9)'
    when magnitude < 7 then 'Strong (6-6.9)'
    else 'Major (>=7)'
  end as magnitude_range,
  COUNT(*) as earthquake_count
from {{ source("staging", "central_asia_eearthquakes") }}
group by magnitude_range
order by magnitude_range