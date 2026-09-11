select m.invoice_line_id
from {{ ref('invoice_lines') }} m
join {{ source('confido', 'invoice_items') }} s on s.id = m.invoice_line_id
left join {{ source('confido', 'invoices') }} i on i.id = s.invoice_id
where m.currency is distinct from i.currency
