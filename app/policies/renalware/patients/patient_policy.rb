# frozen_string_literal: true

module Renalware
  module Patients
    class PatientPolicy < BasePolicy
      class Scope
        attr_reader :user, :scope

        def initialize(user, scope)
          @user = user
          @scope = scope
        end

        def resolve
          scope.all
        end
      end
    end
  end
end
