require_dependency "renalware"

module Renalware
  module Pathology
    class RequestFormPresenter
      attr_reader :patient, :clinic, :consultant, :telephone

      def initialize(patient, clinic, consultant, options = {})
        @patient = patient
        @clinic = clinic
        @consultant = consultant
        @telephone = options[:telephone] # TODO: Add a telephone number on the users table
      end

      def self.wrap(patients, clinic, consultant, options = {})
        patients.map do |patient|
          new(patient, clinic, consultant, options)
        end
      end

      def patient_name
        @patient.full_name.upcase
      end

      def date
        I18n.l Date.current
      end

      def date_of_birth
        I18n.l @patient.born_on
      end

      def consultant
        @consultant.full_name
      end

      def clinical_detail
        @clinic.name
      end
      alias_method :contact, :clinical_detail

      def global_requests_by_lab
        @global_requests_by_lab ||=
          @patient
            .required_observation_requests(@clinic)
            .group_by { |request_description| request_description.lab.name }
      end

      def patient_requests_by_lab
        @patient_requests_by_lab ||=
          @patient
            .required_patient_pathology
            .group_by { |patient_rule| patient_rule.lab.name }
      end

      def has_global_requests?
        global_requests_by_lab.any?
      end

      def has_patient_requests?
        patient_requests_by_lab.any?
      end

      def has_tests_required?
        global_requests_by_lab.any? || patient_requests_by_lab.any?
      end
    end
  end
end
