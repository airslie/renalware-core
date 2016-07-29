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

        def print

        end

        def global_requests_by_lab
          @global_requests.group_by { |request_description| request_description.lab.name }
        end

        def patient_requests_by_lab
          @patient_requests.group_by { |patient_rule| patient_rule.lab.name }
        end

        def has_global_requests?
          @global_requests.any?
        end

        def has_patient_requests?
          @patient_requests.any?
        end

        def has_tests_required?
          has_global_requests? || has_patient_requests?
        end
      end
    end
  end
end
