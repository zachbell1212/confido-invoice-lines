select r.id, r.product_id, r.child_product_id, r.quantity,
    p.name as product_name, p.type as product_type,
    c.name as child_product_name, c.type as child_product_type
from CONFIDO_DEMO.PUBLIC.PRODUCT_RELATIONSHIPS r
left join CONFIDO_DEMO.PUBLIC.PRODUCTS p on p.id = r.product_id
left join CONFIDO_DEMO.PUBLIC.PRODUCTS c on c.id = r.child_product_id
where exists (
    select 1 from CONFIDO_DEMO.PUBLIC.PRODUCTS used
    join CONFIDO_DEMO.PUBLIC.ITEMS a on a.id = used.item_id and a.company_detail_id = used.company_detail_id
    join CONFIDO_DEMO.PUBLIC.INVOICES i on i.company_detail_id = a.company_detail_id
    join CONFIDO_DEMO.PUBLIC.INVOICE_ITEMS l on l.invoice_id = i.id and l.item_remote_id = a.remote_id
    where used.id = r.product_id or used.id = r.child_product_id
)
order by r.id;

-- FINDINGS (September 10): 17 explicit product relationships returned.
-- Examples: Chocolate Sea Salt case -> unit (8); Peanut Butter Protein case -> unit (12).
-- Packaging relationships alone do not resolve which product an ambiguous line represents.
-- Do not split dollars using relationship quantities without supporting evidence.
