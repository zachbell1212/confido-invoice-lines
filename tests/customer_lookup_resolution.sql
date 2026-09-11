select * from {{ ref('int_customer_lookup') }}
where (global_customer_id is not null and contact_candidate_count <> 1)
   or (customer_mapping_status = 'matched_direct' and (direct_customer_count <> 1 or global_customer_id is distinct from direct_customer_id))
   or (customer_mapping_status = 'matched_parent' and (parent_contact_count <> 1 or parent_customer_count <> 1 or global_customer_id is distinct from parent_customer_id))
   or (customer_mapping_status = 'matched_exact_name' and (name_customer_count <> 1 or global_customer_id is distinct from name_customer_id))
   or (distribution_center_id is not null and (center_candidate_count <> 1 or contact_candidate_count <> 1))
   or (distribution_center_id is not null and global_customer_id is not null and center_customer_id is not null and global_customer_id <> center_customer_id)
