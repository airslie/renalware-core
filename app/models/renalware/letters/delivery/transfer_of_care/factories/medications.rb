# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Factories::Medications
      include Concerns::Construction
      include Concerns::Helpers

      def call
        # loop though curr prescriptions
        # Not that the List entris in this case is a list of MedicationStatement#id's
        # Each MedicationStatement contains dosage etc and a link to a Medication which is the
        # drug and form
        # create a MedicationStatment and Medication for each and link them
        # provide access somehow to
        # a) the List with array of MedicationStatements#id's
        # b) an array of MedicationStatements
        # c) an array of Medications
        # Monad?
        [
          Lists::Medications.call(arguments),
          Resources::Medication.call(arguments, prescription: nil),
          Resources::MedicationStatement.call(
            arguments,
            prescription: nil,
            medication_urn: "urn:uuid:123"
          )
        ]
      end
    end
  end
end
