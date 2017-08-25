require_dependency "renalware"

module Renalware
  module Clinical
    class ProfilePresenter
      attr_reader :patient, :params
      delegate :allergies, to: :patient
      delegate :diagnosis, :diagnosed_on, to: :diabetes, prefix: true

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
        history.smoking || NullObject.instance
      end

      def alcohol_history
        history.alcohol || NullObject.instance
      end

      def history
        patient.document.history || NullObject.instance
      end

      def diabetes
        patient.document.diabetes || NullObject.instance
      end

      def dry_weights
        @dry_weights ||= DryWeight.for_patient(patient).ordered
      end

      def body_compositions
        @body_compositions ||= begin
          BodyComposition
            .for_patient(patient)
            .includes([:modality_description, :assessor])
            .ordered
        end
      end
    end
  end
end
