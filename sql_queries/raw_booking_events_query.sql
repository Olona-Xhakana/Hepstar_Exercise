CREATE OR REPLACE VIEW dataset.all_booking_events AS
SELECT *
FROM `project.dataset.raw_booking_events_2026*`
-- WHERE _TABLE_SUFFIX >= FORMAT_DATE('%m-%d', DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY));