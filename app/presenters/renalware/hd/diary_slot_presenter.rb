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

      # rubocop:disable Metrics/MethodLength
      def patient_search_options
        hospital_unit = Renalware::Hospitals::Unit.find(diary.hospital_unit_id)
        [
          OpenStruct.new(
            id: :dialysing_on_day_and_period,
            name: "Dialysing #{day_of_week_name} #{diurnal_period_code.to_s.upcase}"
          ),
          OpenStruct.new(
            id: :dialysing_on_day,
            name: "Dialysing on #{day_of_week_name}"
          ),
          OpenStruct.new(
            id: :dialysing_at_unit,
            name: "All #{hospital_unit.unit_code} HD patients"
          )
        ]
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
