select 
  *
from {{ source("staging", "central_asia_eearthquakes") }}
order by date desc
limit 10
