# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Hospitals
    class CentrePolicy < BasePolicy
      #
      # This scope determines which Hospital::Centres the user can add a patient to.
      #
      class Scope
        pattr_initialize :user, :scope

        def resolve
          return if scope.nil?
          return scope.ordered if user.has_role?(:super_admin)

          scope.where(id: user.hospital_centre_id)
        end
      end
    end
  end
end
