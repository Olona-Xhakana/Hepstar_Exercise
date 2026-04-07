CREATE OR REPLACE VIEW `INGESTION.raw_priced_calls_vw` AS
SELECT * FROM `INGESTION.raw_priced_calls_2026*`;
-- we can add a conditional statement to filter the data so that we dont query loads of data but since it is small there is no need now
