select company_id, accounting_item_remote_id
from {{ ref('int_product_lookup') }}
group by company_id, accounting_item_remote_id
having count(*) > 1
