select company_id, accounting_item_remote_id
from {{ ref('int_product_lookup') }}
where (product_id is not null and (accounting_item_candidate_count != 1 or product_candidate_count != 1))
   or (product_mapping_status = 'matched' and product_id is null)
