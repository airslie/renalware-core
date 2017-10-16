require_dependency "renalware/hd"
require_dependency "collection_presenter"

# TODO: mixing query and presenter here..
module Renalware
  module HD
    class DiarySlotPresenter < SimpleDelegator

      # Patients who prefer to dialyse on this day e.g. Mon and in this period e.g. AM.
      # Flag those already assigned so they cannot be chosen.
      def patients_preferring_to_dialyse_today_in_this_period
        PatientsDialysingByDayAndPeriodQuery.new(day_of_week, diurnal_period_code.code).call.all
      end

      # Patients who prefer to dialyse on this day e.g. Mon
      # Flag those already assigned so they cannot be chosen.
      def patients_preferring_to_dialyse_today
        HD::PatientsDialysingByDayQuery.new(day_of_week).call.all
      end
    end
  end
end
