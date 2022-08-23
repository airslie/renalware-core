# frozen_string_literal: true

require "active_support/concern"

module Renalware
  module Concerns
    # Included in controllers that list or show patients, so that, if configured to do so, 
    # we can use the PatientPolicy to control patient visibility ie a user a Hospital A cannot 
    # see patients at the same hospital (A) but not those at Hospital B. Used at BLT.
    module PatientScopable
      extend ActiveSupport::Concern
      include Pundit::Authorization

      included do
        after_action :verify_policy_scoped, if: :scope_patients_by_policy?

        # Override policy_scope so we can skip policy_scoping if it is not enabled at this site.
        def policy_scope(patients)
          scope_patients_by_policy? ? super : patients
        end
      end
    end
  end
end