-- A simple table with one row per day and the counts of the various statuses
select utl.created_at ::date as date,
   COUNT(*) as total,
   COUNT(CASE WHEN utl.status = 3 THEN 1 END) as queued,
   COUNT(CASE WHEN utl.status = 99 THEN 1 END) as "sent",
   COUNT(CASE WHEN utl.status = 2 THEN 1 END) as unsent_no_change,
   COUNT(CASE WHEN utl.status = 1 THEN 1 END) as error
from ukrdc_transmission_logs utl
group by date
order by date;
