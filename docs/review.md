# Review scope and disposition

The author reviewed SQL, tests, original assignment and live build evidence, and
ran synthetic customer-lookup cases. A separate local Fable reviewer reviewed a
code snapshot and ran its own counterexamples. Its result was pass with concerns.
It then received a full 13-table export, independently checked hashes/counts/schema,
reconstructed mappings and tested additional hypotheses. No additional supported
mappings or current-data model defects were identified.

A reproduced future-data concern remains: a dangling explicit customer ID may fall
through to a weaker parent/name inference. The output exposes invalid-reference
counts, but its matched status does not alone reject that situation. Live checks
found zero dangling contact global IDs and zero null/duplicate IDs in contacts,
global customers and centers. Production extension should block or separately
label this fallback and strengthen tests. This take-home does not claim arbitrary
corrupt-input robustness.

The reviewer confirmed the source price mismatch with an additional counterexample:
88 already-mapped Strawberry Multipack lines have unit price 25.25 although their
linked product's configured price is 29.00. Effective-price, generated-token and
weekly-pattern hypotheses provided no supported entity identities.

The raw-data review ran locally, not in Snowflake. Exported tables were read
sequentially with stable counts and verified hashes, not at one guaranteed atomic
instant. Business semantics, particularly parent/name attribution and unknown
currency/units, remain qualified assumptions. Reviewer statements of absolute
completeness or synthetic-data intent were not adopted as proof.
