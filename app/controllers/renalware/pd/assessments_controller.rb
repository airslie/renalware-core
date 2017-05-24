require_dependency "renalware/pd"

module Renalware
  module PD
    class AssessmentsController < BaseController

      def new
        assessment = PD::Assessment.for_patient(patient).new
        authorize assessment
        render locals: {
          patient: patient,
          assessment: assessment
        }
      end
    end
  end
end
