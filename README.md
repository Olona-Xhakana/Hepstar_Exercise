# Hepstar_Exercise

This project implements a robust BigQuery-based pipeline to compute daily booking revenue metrics from event-driven API data.
The solution is designed to handle real-world data challenges including:
- Duplicate API retries
- Late-arriving purchase events
- Conflicting event signals (purchase vs no_purchase)
The pipeline ensures accurate attribution of revenue and conversion metrics using a quote-first attribution model.

## Deduplication Strategy (Handling Retries)
Partner systems may retry API calls, resulting in duplicate logical requests.

**Approach:**
- Used `ROW_NUMBER()` with `PARTITION BY COALESCE(request_id, call_id)`
- Ordered by `ingest_ts DESC` to keep the latest attempt

**Why:**
- `request_id` represents the logical request (idempotency key)
- `call_id` is used as fallback when request_id is missing

**Result:**
- Ensures only one record per logical request is processed
- Prevents duplication in both quote and purchase metrics

## Incremental Processing Strategy

To handle late-arriving data and retries efficiently:
- A rolling 7-day window is reprocessed daily
- Implemented using a MERGE statement into the target table
- This ensures:
  - Late purchases are correctly attributed
  - Updated records overwrite previous incorrect states
  - Pipeline remains idempotent

**Why this approach:**
- Full refresh is expensive
- Incremental with rolling window balances cost and accuracy

## Data Quality Checks

1. purchased_bookings ≤ quoted_bookings
2. attach_rate BETWEEN 0 AND 1
3. total_commission ≥ 0
4. No NULL booking_id or distributor_id
5. Duplicate booking_id per distributor per day = 0
6. Sudden spike/drop (>30%) in quoted_bookings
7. Commission per booking outliers (e.g. extremely high values)

## Monitoring & Alerts (GCP)

- BigQuery scheduled query failures (Cloud Logging alerts)
- Data freshness checks (no data within expected SLA)
- Volume anomaly detection (Cloud Monitoring)
- Cost monitoring for query spikes
  
