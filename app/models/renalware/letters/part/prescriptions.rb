require "renalware/letters/part"
require "ostruct"

module Renalware
  module Letters
    class Part::Prescriptions < DumbDelegator
      include ::PresenterHelper

      def initialize(patient, _event = Event::Unknown.new)
        @patient = patient
        super(prescriptions)
      end

      def to_partial_path
        "renalware/letters/parts/prescriptions"
      end

      private

      def prescriptions
        presenter_klass = ::Renalware::Medications::PrescriptionPresenter
        ::OpenStruct.new(
          current: present(current_prescriptions, presenter_klass),
          recently_changed: present(recently_changed_current_prescriptions, presenter_klass),
          recently_stopped: present(recently_stopped_prescriptions, presenter_klass)
        )
      end

      def current_prescriptions
        @current_prescriptions ||= patient_prescriptions.current
      end

      # Prescriptions created or with dosage changed in the last 14 days.
      # Because we terminated a prescription if the dosage changes, and create a new one,
      # we just need to search for prescriptions created in the last 14 days.
      def recently_changed_current_prescriptions
        @recently_changed_prescriptions ||= begin
          current_prescriptions.created_between(from: 14.days.ago, to: ::Time.zone.now)
        end
      end

      # Find prescriptions terminated within 14 days
      def recently_stopped_prescriptions
        @recently_stopped_prescriptions ||= begin
          patient_prescriptions
            .terminated
            .terminated_between(from: 14.days.ago, to: ::Time.zone.now)
            .where.not(drug_id: current_prescriptions.map(&:drug_id))
        end
      end

      def patient_prescriptions
        @patient_prescriptions ||= begin
          @patient.prescriptions
                   .with_created_by
                   .with_medication_route
                   .with_drugs
                   .with_termination
                   .ordered
        end
      end
    end
  end
end
