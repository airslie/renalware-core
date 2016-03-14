require_dependency "renalware/patient"

module Renalware
  module Patients
    class CreatePatient
      def call(params)
        ::Renalware::Patient.create!(params[:patient].merge(nhs_number: "TO-ADD-123"))
      end
    end
  end
end
