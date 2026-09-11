select company_id, customer_remote_id
from {{ ref('int_customer_lookup') }}
group by 1, 2 having count(*) > 1
