-- One row per source invoice line. Never recompute, allocate, or round the source amount.
select
    b.invoice_line_id,
    b.invoice_id,
    b.invoice_number,
    b.company_id,
    b.subsidiary_id,
    b.invoice_created_at,
    b.paid_on_date,
    b.accounting_item_remote_id,
    b.customer_remote_id,
    b.source_total_amount as amount,
    b.source_quantity as quantity,
    b.currency,
    case when b.currency is null then 'missing_currency' else 'source_currency' end as currency_status,
    b.invoice_mapping_status,
    p.accounting_item_id,
    p.product_id,
    coalesce(p.product_candidate_count, 0) as product_candidate_count,
    coalesce(p.product_mapping_status, 'unmapped_accounting_item') as product_mapping_status,
    c.global_customer_id,
    coalesce(c.customer_mapping_status, 'missing_contact') as customer_mapping_status,
    coalesce(c.contact_candidate_count, 0) as contact_candidate_count,
    coalesce(c.invalid_direct_reference_count, 0) as invalid_customer_reference_count,
    c.distribution_center_id,
    coalesce(c.center_mapping_status, 'missing_contact') as center_mapping_status
from {{ ref('int_invoice_line_base') }} b
left join {{ ref('int_product_lookup') }} p
    on p.company_id = b.company_id
    and p.accounting_item_remote_id = b.accounting_item_remote_id
left join {{ ref('int_customer_lookup') }} c
    on c.company_id = b.company_id
    and c.customer_remote_id = b.customer_remote_id
