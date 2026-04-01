Hepstar take-home sample data (7 days) - v2
-----------------------------------------
Daily ingestion 'dumps' by ingest date (UTC).
File naming: <table>_YYYY-MM-DD.csv

Guaranteed per-day volumes (rows in each daily CSV):

priced_per_day:
  2026-01-10: 12
  2026-01-11: 19
  2026-01-12: 10
  2026-01-13: 18
  2026-01-14: 13
  2026-01-15: 14
  2026-01-16: 18

purchase_per_day:
  2026-01-10: 2
  2026-01-11: 2
  2026-01-12: 2
  2026-01-13: 1
  2026-01-14: 2
  2026-01-15: 2
  2026-01-16: 2

events_per_day:
  2026-01-10: 1
  2026-01-11: 1
  2026-01-12: 2
  2026-01-13: 1
  2026-01-14: 2
  2026-01-15: 2
  2026-01-16: 2

Notes:
- Duplicates/retries exist (same request_id across multiple rows), but purchase/events are capped at 2 rows/day.
- Late arrivals exist: some rows have event_ts/purchase_ts earlier than their file date, but ingest_ts determines which daily dump they appear in.
- Some priced calls are invalid for quoting (status_code != 200 OR returned_products = []).
- There is an explicit edge case where both purchase and booking_completed_no_purchase exist for the same booking; purchase should win.
