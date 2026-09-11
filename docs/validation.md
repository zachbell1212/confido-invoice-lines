# Invoice build result

The updated live build passed: four views and all 26 tests, including the new
original-quantity preservation test. Seven source quantity nulls are retained;
quantity is neither filled nor recalculated.

Command: `dbt build --select +invoice_lines --threads 1`.
Final relation: `CONFIDO_INTERVIEWS.ZACHARY.INVOICE_LINES`.

The build artifact was generated at 2026-09-11T00:38:52.105806Z.
Source models and the quantity test match that build manifest. The packaged model,
test and macro files match those reviewed originals byte for byte. See the
[sanitized result summary](build-results.json) for statuses and file hashes.

Tests cover source/model IDs, non-null amounts, lookup grain and resolution,
missing/extra lines, unchanged amounts, original quantities and currency, and
internal-ID relationships. The assigned-schema guard passed.

The submission page requires original quantity, although the earlier email said
it was optional. The updated model satisfies both. Earlier independent reviews
preceded this direct passthrough addition; the addition has its own local export
check and passing live test. No mapping logic changed.

The earlier packaged project passed offline parsing; models now match the updated
live build. A fresh dependency install on another machine and the relocated
launcher have not been tested live. Passing tests does not establish business
semantics for inferred customer IDs or missing-currency amounts.
