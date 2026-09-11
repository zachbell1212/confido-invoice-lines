-- Grain: one row per source invoice line. Header uniqueness is tested.
-- Preserve TOTAL_AMOUNT exactly; do not recompute from quantity or unit price.
select
    line.id as invoice_line_id,
    line.invoice_id,
    invoice.number as invoice_number,
    invoice.company_detail_id as company_id,
    invoice.subsidiary_id,
    invoice.created_at as invoice_created_at,
    invoice.paid_on_date,
    line.item_remote_id as accounting_item_remote_id,
    invoice.customer_remote_id,
    line.total_amount as source_total_amount,
    line.quantity as source_quantity,
    invoice.currency,
    case when invoice.id is null then 'missing' else 'matched' end as invoice_mapping_status
from {{ source('confido', 'invoice_items') }} as line
left join {{ source('confido', 'invoices') }} as invoice
    on line.invoice_id = invoice.id
