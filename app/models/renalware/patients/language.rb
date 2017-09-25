require_dependency "renalware/patients"

module Renalware
  module Patients
    class Language < ApplicationRecord
      validates :name, presence: true
      validates :code, presence: true

      def to_s
        name
      end
    end
  end
end
