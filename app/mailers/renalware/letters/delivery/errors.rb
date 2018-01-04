require_dependency "renalware/letters"

module Renalware
  module Letters
    module Delivery
      class PatientHasNoPracticeError < StandardError; end
      class PatientHasNoPrimaryCarePhysicianError < StandardError; end
      class PrimaryCarePhysicianDoesNotBelongToPatientsPracticeError < StandardError; end
      class PracticeHasNoEmailError < StandardError; end
    end
  end
end
