CREATE OR REPLACE VIEW `TRANSFORMATION.vw_booking_events_clean` AS
SELECT *,
    IFNULL(priced_call_id, 'UNKNOWN') AS priced_call_id_clean,
    MAX( CASE 
        WHEN event_type = 'booking_completed_no_purchase' THEN 'no_purchase'
        WHEN event_type IN ('booking_completed_purchase', 'purchase') THEN 'purchase'
        ELSE 'purchase'
    END) OVER(PARTITION BY booking_id) AS booking_status
    
 FROM `hepstar.INGESTION.raw_booking_events_vw` LIMIT 1000
