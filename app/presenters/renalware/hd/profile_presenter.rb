module Renalware
  module HD
    class ProfilePresenter < DumbDelegator
      def initialize(profile, preference_set: nil)
        super(profile)
        @preference_set = preference_set
      end

      def hospital_unit_hint
        if @preference_set.hospital_unit.present?
          "Preference: #{@preference_set.hospital_unit.to_s}"
        end

      end

      def schedule_hint
        if @preference_set.preferred_schedule.present?
          "Preference: #{@preference_set.preferred_schedule}"
        end
      end
    end
  end
end