require_dependency "renalware/patient"

module Renalware
  module Patients
    class IdempotentCreatePatient
      attr_reader :params

      def initialize(params)
        @params = params
      end

      def call
        :Renalware::Patient.create_with(patient_params)
                            .find_or_create_by!(local_patient_id: local_patient_id)
      end

      private

      def patient_params
        patient_params = params.fetch(:patient)
        patient_params.merge!(by: system_user) unless patient_params[:by].present?
        patient_params
      end

      def local_patient_id
        params.fetch(:patient).fetch(:local_patient_id)
      end

      def system_user
        ::Renalwar::SystemUser.find
      end
    end
  end
end
