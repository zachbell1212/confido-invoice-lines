-- Grain: company + remote customer reference. Candidate sets are reduced before enrichment.
-- Internal global IDs are globally keyed; name candidates are company-scoped or shared.
with candidates as (
    select
        c.company_detail_id as company_id,
        c.remote_id as customer_remote_id,
        count(distinct c.id) as contact_candidate_count,
        count(distinct g.id) as direct_customer_count,
        min(g.id) as direct_customer_id,
        count(distinct pc.id) as parent_contact_count,
        count(distinct pg.id) as parent_customer_count,
        min(pg.id) as parent_customer_id,
        count(distinct ng.id) as name_customer_count,
        min(ng.id) as name_customer_id,
        count(distinct d.id) as center_candidate_count,
        min(d.id) as sole_center_id,
        min(d.global_customer_id) as center_customer_id,
        count(distinct case when c.global_customer_id is not null and g.id is null then c.id end) as invalid_direct_reference_count
    from {{ source('confido', 'contacts') }} c
    left join {{ source('confido', 'global_customers') }} g on g.id = c.global_customer_id
    left join {{ source('confido', 'contacts') }} pc
        on pc.company_detail_id = c.company_detail_id and pc.remote_id = c.parent_remote_id
    left join {{ source('confido', 'global_customers') }} pg on pg.id = pc.global_customer_id
    left join {{ source('confido', 'global_customers') }} ng
        on lower(trim(ng.name)) = lower(trim(c.name))
        and nullif(trim(c.name), '') is not null
        and (ng.company_detail_id = c.company_detail_id or ng.company_detail_id is null)
    left join {{ source('confido', 'confido_distribution_centers') }} d on d.id = c.distribution_center_id
    group by 1, 2
), resolved as (
    select *,
        case
            when contact_candidate_count <> 1 then null
            when direct_customer_count = 1 then direct_customer_id
            when direct_customer_count = 0 and parent_contact_count = 1 and parent_customer_count = 1 then parent_customer_id
            when direct_customer_count = 0 and parent_customer_count = 0 and name_customer_count = 1 then name_customer_id
        end as global_customer_id,
        case
            when contact_candidate_count <> 1 then 'ambiguous_contact'
            when direct_customer_count = 1 then 'matched_direct'
            when direct_customer_count > 1 then 'ambiguous_direct'
            when parent_contact_count = 1 and parent_customer_count = 1 then 'matched_parent'
            when parent_customer_count > 0 then 'ambiguous_parent'
            when name_customer_count = 1 then 'matched_exact_name'
            when name_customer_count > 1 then 'ambiguous_name'
            else 'unmapped_customer'
        end as customer_mapping_status
    from candidates
)
select *,
    case when contact_candidate_count = 1 and center_candidate_count = 1
        and (global_customer_id is null or center_customer_id is null or center_customer_id = global_customer_id)
        then sole_center_id end as distribution_center_id,
    case
        when contact_candidate_count <> 1 then 'ambiguous_contact'
        when center_candidate_count = 0 then 'unmapped_center'
        when center_candidate_count > 1 then 'ambiguous_center'
        when global_customer_id is not null and center_customer_id is not null and center_customer_id <> global_customer_id then 'conflicting_customer'
        else 'matched_direct'
    end as center_mapping_status
from resolved
