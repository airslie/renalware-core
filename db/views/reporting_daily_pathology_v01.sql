-- A pathology report to help identify any HL7/delayed_job issues
-- the name of the view (the filename here) is significant as we'll compile all reporting_daily_*
-- views into a daily digest email
select
  (select count(*) from delayed_jobs) as delayed_jobs_total,
  (select count(*) from delayed_jobs where attempts = 0) as delayed_jobs_unprocessed,
  (select count(*) from delayed_jobs where last_error is not null and failed_at is null ) as delayed_jobs_retrying,
  (select count(*) from delayed_jobs where last_error is not null and failed_at is null ) as delayed_jobs_failed,
  (select max(created_at) from delayed_jobs) as delayed_jobs_latest_entry,
  (select count(*) from delayed_jobs where created_at >= now()::date) as delayed_jobs_added_today,
  (select jsonb_agg(query) from (select priority, count(*) from delayed_jobs group by priority ) query) as delayed_jobs_priority_counts,
  (select count(*) from feed_messages) as feed_messages_total,
  (select count(*) from feed_messages where created_at >= now()::date) as feed_messages_added_today,
  (select max(created_at) from feed_messages) as feed_messages_added_latest_entry, -- will be slow, needs index on feed_messages.created_at
  (select count(*) from pathology_observations where created_at::date >= now()::date) as pathology_observations_added_today,
  (select max(observed_at) from pathology_observations) as pathology_observations_latest_observed_at;
