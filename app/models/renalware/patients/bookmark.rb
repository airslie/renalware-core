require_dependency "renalware/patients"

module Renalware
  module Patients
    class Bookmark < ActiveRecord::Base
      belongs_to :user, class_name: "Renalware::User", foreign_key: :user_id
      belongs_to :patient, class_name: "Renalware::Patient", foreign_key: :patient_id
    end
  end
end
