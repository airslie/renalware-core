require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class InpatientPresenter < SimpleDelegator
      delegate :nhs_number,
               :hospital_identifiers,
               :age,
               :sex,
               :current_modality,
               to: :patient,
               prefix: true,
               allow_nil: true

      def patient
        @patient ||= Renalware::PatientPresenter.new(__getobj__.patient)
      end

      def unit_and_ward
        [hospital_unit&.unit_code, hospital_ward&.name].compact.join("/")
      end

      def patient_name
        __getobj__.patient&.to_s
      end
    end
  end
end
