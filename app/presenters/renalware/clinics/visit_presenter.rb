# frozen_string_literal: true

module Renalware
  module Clinics
    class VisitPresenter < DumbDelegator
      include ::Renalware::AccountablePresentation
    end
  end
end
