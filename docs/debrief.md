# Debrief guide

## Opening explanation

I modeled one row per invoice line and kept the original signed amount and quantity. The main
challenge was that accounting references do not always identify a single internal
entity. I reduced candidate sets before joining, retained every line, and made
mapping provenance and unresolved cases explicit. The updated live build passed all 26 tests, including exact quantity preservation.

## Suggested walkthrough, about 30 minutes

1. **Objective and grain (3 minutes):** invoice-line IDs, source amount, internal
   links where possible. Explain why invoice number is not the grain.
2. **Source relationships (5 minutes):** walk through the three intermediate models
   and final join. Show why joining candidate products directly would multiply rows.
3. **Product ambiguity (7 minutes):** 824 lines under Yogurt with five candidates,
   30 under Ice cream with two. Explain evidence checked and why prices/composition
   do not establish identity. Distinguish the 22 unmatched accounting lines.
4. **Customer and center rules (5 minutes):** 901 direct, 10 parent, five exact-name
   assignments. Explain provenance, the Kroger tie, missing contacts, and why no
   center can be selected from customer identity alone.
5. **Validation and limitations (5 minutes):** full source-line reconciliation,
   unchanged amounts/currency, internal-ID existence, and limits of passing tests.
6. **Extensions (5 minutes):** business clarification, explicit crosswalks, more
   defensive checks and monitored mapping coverage.

## Questions to be ready for

- Why retain null IDs? Missing evidence is different from a valid zero amount or
  a dropped transaction. Null plus status makes the gap measurable.
- Why not choose the first product? It invents identity and can misattribute revenue.
- Why not use price? No supported coincidences for ambiguous lines, and prices
  disagree even on already-mapped products. Effective dates and currency also matter.
- Are exact-name matches certain? No. They are scoped unique inferences, separate
  from direct IDs. A consumer can exclude them, and business policy should confirm them.
- Are all amounts USD? No. Missing currency remains missing; source values are
  preserved without claiming a conversion or proven units.
- What does the independent review add? A separate reconstruction from all 13 raw
  tables and additional rejected hypotheses. It strengthens evidence, not certainty
  about undocumented business rules.
- What remains fragile? Dangling explicit customer IDs can fall through to inference;
  current data has none. That deserves a dedicated production guard and tests.

## Questions for the team

Which system owns item-to-product crosswalks? Are parent/name customer fallbacks
accepted policy? What do missing-currency amounts represent? Are location keys
available upstream? How should accounting adjustments appear in reporting?

AI assistance was used for implementation, exploration and independent review.
Explain the code and decisions in your own words; do not imply the independent
review supplied business-owner confirmation.
