# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module SideNavHelper
    def find_user_bookmark_for_patient(patient)
      user = Renalware::Patients.cast_user(current_user)
      user.bookmark_for_patient(patient)
    end
  end
end
