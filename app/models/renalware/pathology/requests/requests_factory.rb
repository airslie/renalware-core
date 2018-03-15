# frozen_string_literal: true

require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
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
