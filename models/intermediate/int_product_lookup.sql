-- Grain: one row per company + external accounting-item reference.
-- MIN is used only when exactly one distinct candidate exists, never to rank ties.
with candidates as (
    select
        item.company_detail_id as company_id,
        item.remote_id as accounting_item_remote_id,
        count(distinct item.id) as accounting_item_candidate_count,
        count(distinct product.id) as product_candidate_count,
        min(item.id) as sole_accounting_item_id,
        min(product.id) as sole_product_id
    from {{ source('confido', 'items') }} as item
    left join {{ source('confido', 'products') }} as product
        on product.item_id = item.id
        and product.company_detail_id = item.company_detail_id
    group by item.company_detail_id, item.remote_id
)
select
    company_id,
    accounting_item_remote_id,
    accounting_item_candidate_count,
    product_candidate_count,
    case when accounting_item_candidate_count = 1 then sole_accounting_item_id end as accounting_item_id,
    case when accounting_item_candidate_count = 1 and product_candidate_count = 1
        then sole_product_id end as product_id,
    case
        when accounting_item_candidate_count != 1 then 'ambiguous_accounting_item'
        when product_candidate_count = 0 then 'unmapped_product'
        when product_candidate_count = 1 then 'matched'
        else 'ambiguous_product'
    end as product_mapping_status
from candidates
