#
# A presenter which, for a patient, displays any HD preferences (for example when or where they
# have HD) that do not match their current HD profile.
#
require_dependency "renalware/hd"

module Renalware
  module HD
    class UnmetPreferencesPresenter
      include ActionView::Helpers
      COMMON_ATTRIBUTES = %i(schedule other_schedule hospital_unit).freeze
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

      private

      attr_reader :patient
    end
  end
end
