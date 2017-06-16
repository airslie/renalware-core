require_dependency "renalware/patients"

module Renalware
  module Patients
    # A Liquid 'Drop' - a read-only decorator around our Patient. We pass an instnce to
    # the Liquid template and it is used for resolving and inserting patient data into the
    # liquid template stored in the database
    class PatientDrop < Liquid::Drop
      delegate :given_name, :family_name, to: :patient

      def initialize(patient)
        @patient = patient
      end

      def born_on
        I18n.l(patient.born_on)
      end

      def hospital_identifier
        patient.hospital_identifier&.to_s
      end

      private

      attr_reader :patient
    end
  end
end
