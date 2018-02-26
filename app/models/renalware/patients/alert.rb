require_dependency "renalware/patients"

module Renalware
  module Patients
    class Alert < ApplicationRecord
      include Accountable
      acts_as_paranoid

      validates :patient, presence: true
      validates :notes, presence: true

      belongs_to :patient, touch: true
    end
  end
end
