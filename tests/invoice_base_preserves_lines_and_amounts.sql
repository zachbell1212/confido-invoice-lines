-- A full join detects missing/extra lines; separate uniqueness tests detect multiplication.
select coalesce(source_line.id, model.invoice_line_id) as invoice_line_id
from {{ source('confido', 'invoice_items') }} source_line
full outer join {{ ref('int_invoice_line_base') }} model
    on source_line.id = model.invoice_line_id
where source_line.id is null
   or model.invoice_line_id is null
   or source_line.total_amount is distinct from model.source_total_amount
