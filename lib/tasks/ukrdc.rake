require "fileutils"
require "gpgme"

# Need to bear in mind we if we find a patient with changes, we still don't take everything
# the patient has but only those bits modified since the last export or :since_date
#
namespace :ukrdc do
  desc "Creates a folder of UKRDC XML files containing any changes to PV patients since "\
       "their last export"
  task :export, [:changed_since, :patient_ids] => [:environment] do |t, args|
    Renalware::UKRDC::SendPatients.new(**args.to_h).call
  end
end
