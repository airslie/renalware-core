require "attr_extras"

namespace :ukrdc do
  desc "Creates a folder of UKRDC XML files containing any changes to PV patients since "\
       "their last export"
  task :export,
       [:patient_ids, :earliest_activity_date, :latest_activity_date] => [:environment] do |t, args|

    # The dates are the window
    class ExportPatients
      def initialize(patient_ids: nil,
                     earliest_activity_date: nil,
                     latest_activity_date: nil)
        p patient_ids
        @patient_ids = Array(patient_ids)
        @earliest_activity_date = earliest_activity_date
        @latest_activity_date = latest_activity_date || Time.zone.today
      end

      def call
        p patient_ids
        puts "Generating XML files for #{patient_ids.any? ? patient_ids : 'all'} patients"
      end

      private

      attr_reader :patient_ids, :earliest_activity_date, :latest_activity_date

      def pv_patients
        Renalware::Patient.pluck(:id)
      end
    end
    p args
    ExportPatients.new(args).call
  end
end
