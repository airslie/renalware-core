# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class PrimaryCarePhysicianPolicy < BasePolicy
      def search?
        index?
      end
    end
  end
end
