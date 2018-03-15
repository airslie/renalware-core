# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class RememberedClinicVisitPreferences < RememberedPreferences
      SESSION_KEY = :clinic_visit_preferences
      ATTRIBUTES_TO_REMEMBER = %i(date).freeze
    end
  end
end
