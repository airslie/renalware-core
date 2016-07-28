require_dependency "renalware/pathology/request_algorithm"

module Renalware
  module Pathology
    module RequestAlgorithm
      class RequestsFactory
        def initialize(patients, params)
          @patients = patients
          @params = params
        end

        def build
          @patients.map do |patient|
            RequestFactory.new(patient, @params).build
          end
        end
      end
    end
  end
end
