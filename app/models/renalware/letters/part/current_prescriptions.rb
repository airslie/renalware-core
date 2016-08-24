require "renalware/letters/part"

module Renalware
  module Letters
    class Part::CurrentPrescriptions < DumbDelegator
      include ::PresenterHelper

      def initialize(patient, _event = Event::Unknown.new)
        @patient = patient
        presented_prescriptions = present(
          patient.prescriptions.includes(:drug, :medication_route),
          ::Renalware::Medications::PrescriptionPresenter
        )
        super(presented_prescriptions)
      end

      def to_partial_path
        "renalware/letters/parts/current_prescriptions"
      end
    end
  end
end
