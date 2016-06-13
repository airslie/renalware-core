require_dependency "renalware/patients"

module Renalware
  module Patients
    class Language < ActiveRecord::Base
      validates :name, presence: true

      def to_s
        name
      end
    end
  end
end
