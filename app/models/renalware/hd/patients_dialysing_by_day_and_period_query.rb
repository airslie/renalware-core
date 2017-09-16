require_dependency "renalware/hd"

# Find for example HD Patients who according to their HD Profile dialyse on Monday PM
# Example usage in that instance:
#   PatientsDialysingByDayAndPeriodQuery.new(1, "am").call
module Renalware
  module HD
    class PatientsDialysingByDayAndPeriodQuery
      attr_reader :day_of_week, :period_code

      def initialize(day_of_week, period_code)
        @day_of_week = day_of_week
        @period_code = period_code
      end

      def call
        return [] if schedule_definition.nil?
        Patient
          .joins(:hd_profile)
          .where(hd_profiles: { schedule_definition_id: schedule_definition.id })
      end

      private

      # Find the schedule for the day of week/period (eg Mon PM)
      # Note days is array and our where clause here find matches where day_of_week is in that array
      # so if we are looking for Tuesday (day_of_week = 2) we will match e.g. [2,4,6]
      def schedule_definition
        @schedule_definition ||= begin
          Renalware::HD::ScheduleDefinition
            .eager_load(:diurnal_period)
            .merge(Renalware::HD::DiurnalPeriodCode.for(period_code))
            .find_by("days @> ?", "{#{day_of_week}}")
        end
      end
    end
  end
end
