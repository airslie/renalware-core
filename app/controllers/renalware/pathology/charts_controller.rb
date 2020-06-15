# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ChartsController < Pathology::BaseController
      # Returns HTML rendered by a view component for pulling into say a modal dialog
      def show
        authorize Patient, :show?
        render(
          locals: {
            patient: patient,
            observation_description: ObservationDescription.find(params[:id])
          },
          layout: false
        )
      end
    end
  end
end
