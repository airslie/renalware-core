# frozen_string_literal: true

require "fileutils"

# Note you can print out the help for this task and others with `rake -D`
namespace :ukrdc do
  desc <<-DESC
    Creates a folder of UKRDC XML files with any changes to PV + RR patients since their last export
    Notes:
      1. Running the rake task updates the sent_to_ukrdc_at for each patient exported.
         If you don't want to do this you may need to edit this task to wrap the code in a
         transaction you can optionally roll back.
     2: If testing this inside the renalware-core gem, you will need to append app: e.g.
        app:ukrdc:export ...

    Example usage
      1. To get all RR and RPV patients with who have changed
         since the last time they were sent, or have not been sent to the UKRDC yet:

         bundle exec rake ukrdc:export

      2. To get all RR and RPV patients who have changed since a certain date:

         bundle exec rake ukrdc:export changed_since="2018-02-23"

      3. To get only certain RR and RPV patients (by their id eg ids 1 and 2) with changes since
         a certain date:

         bundle exec rake ukrdc:export changed_since=2018-02-23 patient_ids=1,2
  DESC
  task export: :environment do |_task, _args|
    logger           = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    logger.level     = Logger::INFO
    Rails.logger     = logger
    # Renalware::UKRDC::TreatmentTimeline::GenerateTreatments.call
    Renalware::UKRDC::CreateEncryptedPatientXMLFiles.new(
      changed_since: ENV["changed_since"],
      patient_ids: ENV.fetch("patient_ids", "").split(",").map(&:to_i),
      force_send: ENV["force_send"] == "true"
    ).call
  end

  desc "Regenerates the ukrdc_treatments table ready for exporting to UKRDC in another task"
  task generate_treatments: :environment do
    logger           = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    logger.level     = Logger::INFO
    Rails.logger     = logger
    Renalware::UKRDC::TreatmentTimeline::GenerateTreatments.call
  end

  task housekeeping: :environment do
    logger           = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    logger.level     = Logger::INFO
    Rails.logger     = logger
    logger.info "UKRDC housekeeping"
    Renalware::UKRDC::Housekeeping::RemoveOldExportArchiveFolders.call
  end

  task import: :environment do
    # Import patient questionnaire data from SFTP'ed UKRDC XML files
    logger           = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    logger.level     = Logger::INFO
    Rails.logger     = logger

    Renalware::UKRDC::Incoming::ImportSurveys.new(logger: logger).call
  end
end
