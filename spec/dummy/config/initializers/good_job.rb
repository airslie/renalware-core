# frozen_string_literal: true

Rails.application.configure do
  # :async = executes jobs in separate threads within the Rails web server process
  config.good_job.execution_mode = :external

  # number of seconds between polls for jobs when execution_mode is set to :async
  config.good_job.poll_interval = 30
  config.good_job.cron = Renalware::Engine.scheduled_jobs_config.merge(
    schedule_refresh_of_materialized_views: {
      cron: "every day at 10:00pm",
      class: "Renalware::System::RefreshMaterializedViewsJob",
      description: "This job will inspect system_view_metadata and schedule a refresh of any " \
                    "materialised views that have a refresh_schedule by enqueuing a " \
                    "RefreshMaterializedViewWithMetadataJob job with a scheduled_at equal to " \
                    "the next datetime specified by the cron schedule. It avoids creating " \
                    "duplicated entries by looking for existing good_job entries, so could run " \
                    "e.g. each hour, but to play safe we are assuming here that no view will " \
                    "refresh >1 time per day, so we we run this job once in the evening. " \
                    "If we need mat views that refresh throughout the day then we can increase " \
                    "the frequency of this job so it will find and schedule those refreshes. " \
                    "Hope to replace this with pg_cron soon."
    }
  )
  config.good_job.enable_cron = true
  config.good_job.smaller_number_is_higher_priority = true
end
