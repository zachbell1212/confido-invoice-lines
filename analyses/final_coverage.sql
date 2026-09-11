-- Run after dbt build; use your authorized target if adapted.
select product_mapping_status, customer_mapping_status, center_mapping_status,
       count(*) as invoice_lines
from CONFIDO_INTERVIEWS.ZACHARY.INVOICE_LINES
group by 1,2,3 order by 1,2,3;

select currency,count(*) as invoice_lines,count(distinct invoice_line_id) as distinct_lines,
       sum(amount) as source_amount
from CONFIDO_INTERVIEWS.ZACHARY.INVOICE_LINES
group by 1;
