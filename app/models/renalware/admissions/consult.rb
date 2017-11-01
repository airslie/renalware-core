require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class Consult < ApplicationRecord
      include Accountable
      acts_as_paranoid
      validates :patient_id, presence: true
    end
  end
end
