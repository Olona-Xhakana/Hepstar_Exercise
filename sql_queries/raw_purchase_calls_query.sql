CREATE OR REPLACE VIEW `your_project.raw.vw_purchase_calls_all` AS
SELECT
    *,
    _TABLE_SUFFIX as source_date
FROM `your_project.raw.purchase_calls_2026_01_*`