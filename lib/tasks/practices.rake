require "benchmark"
require "nhs_api_client"

# TODO:
# - log summary - number added, number updated, number deleted
# - write to a separate log file
namespace :practices do
  desc "Use the NHS Organisational Data API to find updates to practices"
  task sync: :environment do
    dry_run = ENV["dry_run"] == "true"

    Renalware::System::APILog.with_log("nhs_data_api", dry_run: dry_run) do |api_log|
      Renalware::Patients::SyncPracticesViaApi.new(
        dry_run: dry_run,
        api_log: api_log
      ).call
    end
  end
end
