require_dependency "renalware/patients"

module Renalware
  module SideNavHelper
    def display_pd_menu?(patient)
      true
    end

    def display_hd_menu?(patient)
      true
    end

    def find_user_bookmark_for_patient(patient)
      user = Renalware::Patients.cast_user(current_user)
      user.bookmark_for_patient(patient)
    end
  end
end
