module World
  module Letters::Contact
    module Domain
      # @section commands
      #
      def assign_contact(patient:, person:, **_)
        patient = letters_patient(patient)
        contact = patient.assign_contact(person: person)
        contact.save!
      end

      # @section expectations
      #
      def expect_available_contact(patient:, person:)
        patient = letters_patient(patient)
        expect(patient).to be_available_contact(person)
      end
    end

    module Web
      include Domain

      # @section commands
      #
      def assign_contact(patient:, person:, user:)
        login_as user

        visit patient_letters_contacts_path(patient)
        click_on "Add contact"

        fill_autocomplete "person_auto_complete",
          with: person.family_name, select: person.to_s

        within ".patient-content" do
          click_on "Save"
        end
      end
    end
  end
end
