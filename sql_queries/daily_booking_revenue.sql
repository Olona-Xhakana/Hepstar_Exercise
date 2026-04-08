CREATE OR REPLACE TABLE ANALYTICS.daily_booking_revenue_metrics AS -- Using TABLE for the final layer as it is readily available when you want to see data

WITH quoted AS (
  SELECT
    DATE(priced_ts) AS revenue_date,
    distributor_id,
    booking_id
  FROM hepstar.TRANSFORMATION.vw_priced_calls_clean
  WHERE status_code = 200 
    AND ARRAY_LENGTH(JSON_QUERY_ARRAY(returned_products)) > 0
  GROUP BY 1, 2, 3
),

purchased AS (
  SELECT
    booking_id,
    distributor_id,
    SUM(commission) AS total_commission,
    COUNT(*) AS purchase_count
  FROM hepstar.TRANSFORMATION.vw_purchase_calls_clean
  WHERE status = 'success'
  GROUP BY 1, 2
),

no_purchase AS (
  SELECT
    booking_id,
    distributor_id,
    MAX(1) AS has_no_purchase_event
  FROM hepstar.TRANSFORMATION.vw_booking_events_clean
  WHERE event_type = 'booking_completed_no_purchase'
  GROUP BY 1, 2 
)

SELECT
  q.revenue_date,
  q.distributor_id,

  COUNT(DISTINCT q.booking_id) AS quoted_bookings,
  COUNT(DISTINCT p.booking_id) AS purchased_bookings,
  COUNT(DISTINCT IF(p.booking_id IS NULL AND np.has_no_purchase_event = 1, q.booking_id, NULL)) AS no_purchase_bookings,
  SAFE_DIVIDE(COUNT(DISTINCT p.booking_id), COUNT(DISTINCT q.booking_id)) AS attach_rate,
  CAST(SUM(IFNULL(p.total_commission, 0)) AS NUMERIC) AS total_commission,
  SAFE_DIVIDE(SUM(IFNULL(p.total_commission, 0)), COUNT(DISTINCT q.booking_id)) AS commission_per_quoted_booking,
  CURRENT_TIMESTAMP() AS record_updated_ts

FROM quoted q
LEFT JOIN purchased p 
  ON q.booking_id = p.booking_id 
  AND q.distributor_id = p.distributor_id
LEFT JOIN no_purchase np 
  ON q.booking_id = np.booking_id 
  AND q.distributor_id = np.distributor_id

GROUP BY 1, 2;
