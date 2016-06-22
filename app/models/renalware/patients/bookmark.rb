require_dependency "renalware/patients"

module Renalware
  module Patients
    class Bookmark < ActiveRecord::Base
      belongs_to :user, class_name: "Renalware::Patients::User", foreign_key: :user_id
      belongs_to :patient, class_name: "Renalware::Patient", foreign_key: :patient_id

      validates :patient, presence: true
      validates :user, presence: true
      validates_uniqueness_of :user_id, scope: :patient_id
    end
  end
end
