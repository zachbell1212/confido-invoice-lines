-- Full outer comparison catches missing/extra IDs; model uniqueness catches fanout.
select coalesce(s.id, m.invoice_line_id) as invoice_line_id
from {{ source('confido', 'invoice_items') }} s
full outer join {{ ref('invoice_lines') }} m on m.invoice_line_id = s.id
where s.id is null or m.invoice_line_id is null
   or s.total_amount is distinct from m.amount
