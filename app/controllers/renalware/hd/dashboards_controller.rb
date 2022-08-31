# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class DashboardsController < BaseController
      include Renalware::Concerns::PatientCasting

      def show
        authorize hd_patient
        render locals: {
          dashboard: DashboardPresenter.new(hd_patient, view_context, current_user)
        }
      end
    end
  end
end
