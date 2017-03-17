require_dependency "renalware"

module Renalware
  module Clinical
    class ProfilePresenter
      attr_reader :patient, :params
      delegate :allergies, to: :patient

      def initialize(patient:, params:)
        @params = params
        @patient = Clinical.cast_patient(patient)
      end

      def swabs
        @swabs ||= Renalware::Events::Swab.for_patient(patient)
                                          .ordered
                                          .page(params[:page])
                                          .per(params.fetch(:per_page, 10))
      end

      def smoking_history
        patient.document.history&.smoking
      end

      def alcohol_history
        patient.document.history&.alcohol
      end
    end
  end
end
