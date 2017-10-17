require_dependency "renalware/hd"

# Find for example HD Patients who according to their HD Profile dialyse on Monday
# Example usage in that instance:
#   PatientsDialysingByDayQuery.new(1).call
module Renalware
  module HD
    class PatientsDialysingByDayQuery
      attr_reader :day_of_week

      def initialize(day_of_week)
        @day_of_week = day_of_week
      end

      def call
        return [] if schedule_definition_ids.empty?
        Patient
          .joins(:hd_profile)
          .where(hd_profiles: { schedule_definition_id: schedule_definition_ids })
          .order(:family_name, :given_name)
      end

      private

      # Find the schedule for the day of week/period (eg Mon PM)
      # Note days is array and our where clause here find matches where day_of_week is in that array
      # so if we are looking for Tuesday (day_of_week = 2) we will match e.g. [2,4,6]
      def schedule_definition_ids
        @schedule_definition_ids ||= begin
          Renalware::HD::ScheduleDefinition.where("days @> ?", "{#{day_of_week}}").pluck(:id)
        end
      end
    end
  end
end
