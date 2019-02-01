# frozen_string_literal: true

require_dependency "renalware/virology"

module Renalware
  module Virology
    class VaccinationPolicy < Events::EventPolicy
      def edit?
        true
      end
    end
  end
end
