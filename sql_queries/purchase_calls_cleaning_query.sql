CREATE OR REPLACE VIEW `TRANSFORMATION.vw_purchase_calls_clean` AS
SELECT 
    *,
    REGEXP_REPLACE(purchase_call_id, r'_retry$', '') AS base_purchase_id

FROM `INGESTION.raw_purchase_calls_vw`
WHERE status = 'success'
QUALIFY ROW_NUMBER() OVER(
    PARTITION BY REGEXP_REPLACE(purchase_call_id, r'_retry$', ''), request_id 
    ORDER BY purchase_ts ASC
) = 1
LIMIT 1000;
