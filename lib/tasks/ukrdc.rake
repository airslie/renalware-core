# frozen_string_literal: true

require "fileutils"

# Note you can print out the help for this task and others with `rake -D`
namespace :ukrdc do
  desc <<-DESC
    Creates a folder of UKRDC XML files with any changes to PV patients since their last export
    Notes:
      1. Running the rake task updates the sent_to_ukrdc_at for each patient exported.
         If you don't want to do this you may need to edit this task to wrpt the code in a
         transaction you can optionally roll back.
     2: If testing this inside the renalware-core gem, you will need to append app: e.g.
        app:ukrdc:export ...

    Example usage
      1. To get all patients with send_to_rpv=true who have changed since the last time they
         were sent, or have not been sent to the UKRDC yet:

         bundle exec rake ukrdc:export

      2. To get all patients with send_to_rpv=true who have changed since a certain date:

         bundle exec rake ukrdc:export["2018-02-23"]
         or in zsh shell
         bundle exec rake ukrdc:export\["2018-02-23"\]

      3. To get only certain RPV patients (by their id eg ids 1 and 2) who with changes since
         a certain time (not pass patient ids in a space delimited string:

         bundle exec rake ukrdc:export["2018-02-23","1 2"]
         or in the zsh shell
         bundle exec rake ukrdc:export\["2018-02-23","1 2"\]
  DESC
  task :export, [:changed_since, :patient_ids] => [:environment] do |_task, args|
    logger           = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    logger.level     = Logger::INFO
    Rails.logger     = logger
    Renalware::UKRDC::CreateEncryptedPatientXMLFiles.new(
      changed_since: args[:changed_since],
      patient_ids: args.fetch(:patient_ids, "").split(" ").map(&:to_i)
    ).call
  end
end
