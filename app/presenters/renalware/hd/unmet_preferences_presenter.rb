#
# A presenter which, for a patient, displays any HD preferences (for example when or where they
# have HD) that do not match their current HD profile.
#
require_dependency "renalware/hd"

module Renalware
  module HD
    class UnmetPreferencesPresenter
      include ActionView::Helpers
      COMMON_ATTRIBUTES = %i(schedule other_schedule).freeze
      delegate(*COMMON_ATTRIBUTES, to: :hd_preference_set, prefix: :preferred, allow_nil: true)
      delegate(*COMMON_ATTRIBUTES, to: :hd_profile, prefix: :current, allow_nil: true)
      delegate(:notes, to: :hd_preference_set)
      delegate(:to_s, :to_param, :hd_profile, :hd_preference_set, to: :patient)

      def initialize(patient)
        @patient = patient
      end

      # Returns the HD::Profile setting if it differs from that in the HD::PreferenceSet
      def current(attribute)
        return if preference_satisfied?(attribute)
        public_send(:"current_#{attribute}")
      end

      # Returns the HD::PreferenceSet setting if it differs from that in the HD::Profile
      def preferred(attribute)
        return if preference_satisfied?(attribute)
        public_send(:"preferred_#{attribute}")
      end

      def preference_satisfied?(attribute)
        preferred = public_send(:"preferred_#{attribute}")
        current = public_send(:"current_#{attribute}")
        return true if preferred.blank? || preferred == current
        false
      end

      def current_hospital_unit
        formatted_hospital_unit(hd_profile.hospital_unit)
      end

      def preferred_hospital_unit
        formatted_hospital_unit(hd_preference_set.hospital_unit)
      end

      private

      def formatted_hospital_unit(unit)
        return if unit.blank?
        sanitize(unit.to_s) + tag(:br) + sanitize(unit.hospital_centre.to_s)
      end

      attr_reader :patient
    end
  end
end
