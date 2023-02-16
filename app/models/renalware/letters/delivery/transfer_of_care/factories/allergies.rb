# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Factories::Allergies
      include Concerns::Construction
      include Concerns::Helpers

      def call
        # loop thoguh
        # create a AllergyIntoleranceStatement for each, linking to a AllergyIntolerance
        # build the list with each created AllergyIntolerance in
        # return
        # a) the List with array of MedicationStatements#id's
        # b) an array of MedicationStatements
        # c) an array of Medications
        [
          Lists::AllergiesAndAdverseReactions.call(arguments),
          Resources::AllergyIntolerance.call(arguments) # one for each allargy
        ]
      end
    end
  end
end
