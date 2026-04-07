CREATE OR REPLACE VIEW `INGESTION.raw_booking_events_vw` AS 
SELECT * FROM `INGESTION.raw_booking_events_2026_*`;
-- I used this query to create a view that has all the booking events data from all the given csv files, this query joins "appends" all the bq table. i will  do the same for all 3 groups; BOOKINGS, PURCHASE CALLS and PRICED CALLS. I am trying to have one source of truth. 
