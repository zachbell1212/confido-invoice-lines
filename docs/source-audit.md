# Source completeness audit

Live audit in **06 Source completeness audit.sql**, September 10, 2026. All nine
SELECTs have findings immediately below them. The live information-schema query
found 13 accessible supplied tables, all in CONFIDO_DEMO.PUBLIC.

This closes identified gaps in the earlier targeted investigation. It is a
systematic inventory and mapping-route review, not a claim that every row was
manually inspected or every undocumented business convention is known.

| Supplied table | Role and coverage |
|---|---|
| INVOICE_ITEMS | All 2,527 line IDs and amounts reconciled. Schema has item reference, quantity and price, but no independent SKU/UPC/description/location key. |
| INVOICES | Header IDs, company/customer references, currency and subsidiary reviewed. Remittance reference has no corresponding supplied target table. |
| ITEMS | All used item-to-product groups profiled; nine unmatched accounting references now examined. |
| PRODUCTS | Candidate identity, type, UPC, family and internal numbers reviewed. All seven ambiguous candidates have null ship-with relationship pointers. |
| PRODUCT_RELATIONSHIPS | Composition reviewed; child-unit and quantity-derived pack prices tested for all ambiguous lines. Composition alone cannot identify the sold variant. |
| PRODUCT_PRICES | Direct nonforecast candidate prices and child/pack-derived prices give zero coincidences for all 854 ambiguous lines, even ignoring dates. No unit/currency equivalence assumed. |
| PRODUCT_SHIPPING_CONFIGS | All 13 configurations involving ambiguous candidates lack customer/center scope. |
| CONTACTS | Scoped remote IDs, parent references, direct internal IDs and exact names investigated; lookup reduces candidates before joining. |
| GLOBAL_CUSTOMERS | Direct ID validity and scoped/shared exact-name uniqueness checked. No UUID overlap with the 1,603 missing-contact references. |
| CONFIDO_DISTRIBUTION_CENTERS | No explicit used-contact references or compatible exact contact-name matches. Customer identity alone does not identify invoice location. |
| MAP_CONTACT_SUBSIDIARIES | All lines use subsidiary 80; its bridge leads to 47 contacts and 15 distinct global references. Cannot pick a customer from subsidiary alone. |
| COMPANY_DETAILS | Sole company 40 has prevent_customer_remapping=false. This field does not independently prove inferred mapping semantics. |
| RETAILERS | 3,008 rows, seven scoped to company 40; no product/location foreign key. Invoice schema lacks its account/chain identifiers. No retailer UUID overlap with missing-contact invoice references. |

## Previously unmatched product lines

| Accounting reference description | Lines |
|---|---:|
| Early-pay discount | 5 |
| Services | 3 |
| Placement | 3 |
| EDLP | 3 |
| Merchandising spend | 2 |
| Test object #2 | 2 |
| Test object | 2 |
| Short-ship | 1 |
| Retailer spoils | 1 |

All 22 have accounting-item records. None has a same-company exact product-name
candidate. Names suggest adjustments, services and test data; they do not prove
formal categories. Preserve their amounts and unresolved product status.

## Decision and remaining uncertainty

No additional supported mappings emerged. Product coverage remains 1,651 matched,
854 ambiguous and 22 unmatched. Customer coverage remains 916 assigned, including
15 parent/name inferences with separate provenance; center assignments remain zero.
The built models are unchanged, so this audit does not invalidate the passed build.

Do not invent matches from numeric-ID coincidence, latest timestamps, approximate
names, or quantity divisibility. Further resolution needs an authoritative item
crosswalk, invoice-level product/location identifiers, or documented business
semantics. Missing currency and amount units remain an unresolved semantic issue.
