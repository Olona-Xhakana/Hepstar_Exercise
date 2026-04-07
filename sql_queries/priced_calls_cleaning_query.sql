CREATE OR REPLACE VIEW `TRANSFORMATION.vw_priced_calls_clean` AS
SELECT  
  *,
  SAFE.PARSE_JSON(returned_products) AS products_array,
  REGEXP_REPLACE(priced_call_id, r'_retry$', '') AS base_priced_id
FROM `INGESTION.raw_priced_calls_vw`

WHERE status_code = 200
  AND JSON_QUERY(returned_products, '$[0]') IS NOT NULL

QUALIFY ROW_NUMBER() OVER(
    PARTITION BY request_id 
    ORDER BY priced_ts ASC
) = 1
LIMIT 1000;
