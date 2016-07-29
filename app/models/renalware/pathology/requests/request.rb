require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class Request < ActiveRecord::Base
        include Accountable

        belongs_to :patient, class_name: "::Renalware::Pathology::Patient"
        belongs_to :clinic, class_name: "::Renalware::Clinics::Clinic"
        belongs_to :consultant, class_name: "::Renalware::Pathology::Consultant"
        has_and_belongs_to_many :request_descriptions,
          class_name: "::Renalware::Pathology::RequestDescription"
        has_and_belongs_to_many :patient_rules,
          class_name: "::Renalware::Pathology::Requests::PatientRule"

        def print

        end

        def has_global_requests?
          request_descriptions.any?
        end

        def has_patient_requests?
          patient_rules.any?
        end

        def has_tests_required?
          has_global_requests? || has_patient_requests?
        end
      end
    end
  end
end
