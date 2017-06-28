require_dependency "renalware/letters"

module Renalware
  module Letters
    class Event::ClinicVisit < Event
      include ::ActionView::Helpers

      def initialize(event, clinical:)
        super(event, clinical: true)
      end

      def description
        "(Clinic Date #{::I18n.l(date.to_date, format: :long)})"
      end

      def part_classes
        super.merge!({ clinical_observations: Part::ClinicalObservations })
      end

      def to_s
        "Clinic Visit"
      end

      def to_link
        lambda { |patient, event = self|
          link_to(
            event.to_s,
            ::Renalware::Engine.routes.url_helpers.edit_patient_clinic_visit_path(patient, event)
            )
        }
      end
    end
  end
end
