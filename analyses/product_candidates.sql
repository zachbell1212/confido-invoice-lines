with used_items as (
    select i.company_detail_id, l.item_remote_id, count(*) as invoice_line_count
    from CONFIDO_DEMO.PUBLIC.INVOICE_ITEMS l
    join CONFIDO_DEMO.PUBLIC.INVOICES i on i.id = l.invoice_id
    group by 1, 2
)
select u.company_detail_id, u.item_remote_id, u.invoice_line_count,
    a.id as accounting_item_id, a.name as accounting_item_name,
    p.id as product_id, p.name as product_name, p.type as product_type,
    p.upc, p.cleaned_upc, p.product_family_id, p.internal_item_number,
    p.ship_with_product_relationship_id,
    count(p.id) over (partition by u.company_detail_id, a.id) as product_candidate_count
from used_items u
left join CONFIDO_DEMO.PUBLIC.ITEMS a
    on a.remote_id = u.item_remote_id and a.company_detail_id = u.company_detail_id
left join CONFIDO_DEMO.PUBLIC.PRODUCTS p
    on p.item_id = a.id and p.company_detail_id = u.company_detail_id
order by u.invoice_line_count desc, a.id, p.id;

-- FINDINGS (September 10): 23 candidate rows returned.
-- Yogurt: 824 invoice lines, five differently named CaseV2 product candidates.
-- The item name alone cannot select a unique product; preserve invoice grain.
