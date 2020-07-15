# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class VisitPresenter < DumbDelegator
      include ::Renalware::AccountablePresentation
    end
  end
end
