CREATE OR REPLACE VIEW `INGESTION.raw_purchase_calls_vw` AS 
SELECT * FROM `INGESTION.raw_purchase_calls_2026_*`;
-- I choose to create a view instead of a table because views they do not take up storage space they are queried each time you want to see data
