# frozen_string_literal: true

module Renalware
  module Patients
    class PerspectivesController < BaseController
      def show
        authorize patient

        render locals: {
          patient: patient,
          perspective: perspective,
          charts: charts
        }
      end

      private

      def charts
        Pathology::Charts::Chart
          .where(scope: "perspectives/#{perspective}")
          .order(:display_group, :display_order)
      end

      def perspective
        params[:id].to_s
      end
    end
  end
end
