# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class Religion < ApplicationRecord
      validates :name, presence: true

      def to_s
        name
      end
    end
  end
end
