# frozen_string_literal: true

require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class RecipientDashboardsController < BaseController
      include Renalware::Concerns::PatientCasting

      def show
        authorize transplants_patient
        render locals: { dashboard: RecipientDashboardPresenter.new(transplants_patient) }
      end
    end
  end
end
