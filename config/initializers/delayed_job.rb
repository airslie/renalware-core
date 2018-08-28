# frozen_string_literal: true

Delayed::Worker.logger = Logger.new(Rails.root.join("log", "delayed_job.log"))
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 10
Delayed::Worker.max_run_time = 4.hours
Delayed::Worker.read_ahead = 10
Delayed::Worker.sleep_delay = 60
