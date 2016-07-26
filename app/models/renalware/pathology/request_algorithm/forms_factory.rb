require_dependency "renalware/pathology/request_algorithm"

module Renalware
  module Pathology
    module RequestAlgorithm
      class FormsFactory
        def initialize(patients, options)
          @patients = patients
          @options = options
        end

        def build
          @patients.map do |patient|
            form = RequestAlgorithm::FormFactory.new(patient, @options).build

            RequestFormPresenter.new(form)
          end
        end
      end
    end
  end
end
