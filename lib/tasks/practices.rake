require "benchmark"
require "nhs_api_client"

# TODO:
# - log summary - number added, number updated, number deleted
# - write to a separate log file
namespace :practices do
  desc "Use the NHS Organisational Data API to find updates to practices"
  task sync: :environment do
    Renalware::Patients::SyncPracticesViaApi.new.call
  end
end
