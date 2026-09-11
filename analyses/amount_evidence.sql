select i.currency, count(*) as line_count,
    sum(l.total_amount) as total_amount,
    min(l.total_amount) as min_amount, max(l.total_amount) as max_amount,
    count_if(l.total_amount < 0) as negative_lines,
    count_if(l.total_amount != round(l.total_amount, 2)) as more_than_two_decimals,
    count_if(l.quantity is not null and l.unit_price is not null) as comparable_lines,
    count_if(abs(l.total_amount - l.quantity * l.unit_price) < 0.005) as quantity_price_agrees
from CONFIDO_DEMO.PUBLIC.INVOICE_ITEMS l
left join CONFIDO_DEMO.PUBLIC.INVOICES i on i.id = l.invoice_id
group by i.currency
order by i.currency nulls last;

-- FINDINGS (September 10): 2,527 lines across three currency groups.
-- USD: 788 lines, total 6,605,614.49, six negatives; all 780 comparable lines agree with quantity * unit price.
-- CAD: one line, total 3,471.19, agrees with quantity * unit price.
-- Currency NULL: 1,738 lines, total approximately 1,720,316.397969;
-- all have more than two decimal places, only 10 agree within 0.005.
-- Preserve source amount and sign; do not assume NULL currency is USD or recompute amounts.
-- This query does not prove monetary units. Preserve raw precision if display rounding is added.
