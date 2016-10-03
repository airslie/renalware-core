module World
  module Letters::Contact
    module Domain
      # @section commands
      #
      def assign_contact(patient:, person:)
        patient = letters_patient(patient)
        contact = patient.assign_contact(person)
        contact.save!
      end

      # @section expectations
      #
      def expect_available_contact(patient:, person:)
        patient = letters_patient(patient)
        expect(patient).to be_available_contact(person)
      end
    end
  end
end
