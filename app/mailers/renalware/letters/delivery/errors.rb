require_dependency "renalware/letters"

module Renalware
  module Letters
    module Delivery
      class LetterRecipientMissingAddresseeError < StandardError; end
      class AddresseeIsNotAPrimaryCarePhysicianError < StandardError; end
      class PatientHasNoPracticeError < StandardError; end
      class PrimaryCarePhysicianDoesNotBelongToPatientsPracticeError < StandardError; end
      class PracticeHasNoEmailError < StandardError; end
    end
  end
end
