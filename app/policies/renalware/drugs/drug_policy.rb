# frozen_string_literal: true

require_dependency "renalware/drugs"

module Renalware
  module Drugs
    class DrugPolicy < BasePolicy
      def selected_drugs?
        write_privileges?
      end
    end
  end
end
