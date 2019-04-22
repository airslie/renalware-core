-- A pathology report to help identify any HL7/delayed_job issues
-- the name of the view (the filename here) is significant as we'll compile all reporting_daily_*
-- views into a daily digest email
select
  (select count(*) from delayed_jobs) as delayed_jobs_total,
  (select count(*) from delayed_jobs where attempts = 0) as delayed_jobs_unprocessed,
  (select count(*) from delayed_jobs where last_error is not null and failed_at is null ) as delayed_jobs_retrying,
  (select count(*) from delayed_jobs where last_error is not null and failed_at is not null ) as delayed_jobs_failed,
  (select max(created_at) from delayed_jobs) as delayed_jobs_latest_entry,
  (select count(*) from delayed_jobs where created_at >= now()::date) as delayed_jobs_added_today,
  (select json_object_agg(priority, count) from (select priority, count(*) from delayed_jobs group by priority ) query) as delayed_jobs_priority_counts,
  (select json_object_agg(coalesce(queue, 'unset'), count) from (select queue, count(*) from delayed_jobs group by queue ) query) as delayed_jobs_queue_counts,
  (select json_object_agg(attempts, count) from (select attempts, count(*) from delayed_jobs group by attempts ) query) as delayed_jobs_attempts_counts
