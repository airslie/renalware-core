module World
  module Letters::Contact
    module Domain
      # @section seeding
      #
      def seed_contact(patient:, person:)
        patient = letters_patient(patient)
        contact = patient.assign_contact(person: person)
        contact.save!
      end

      # @section commands
      #
      def assign_contact(patient:, person:, default_cc: false, **_)
        patient = letters_patient(patient)
        contact = patient.assign_contact(person: person, default_cc: default_cc)
        contact.save!
      end

      # @section expectations
      #
      def expect_available_contact(patient:, person:)
        patient = letters_patient(patient)
        expect(patient).to have_available_contact(person)
      end

      def expect_default_ccs(patient:, person:)
        patient = letters_patient(patient)
        expect(patient).to have_default_cc(person)
      end
    end

    module Web
      include Domain

      # @section commands
      #
      def assign_contact(patient:, person:, user:, default_cc: false)
        login_as user

        visit patient_letters_contacts_path(patient)
        click_on "Add contact"

        within("#add-patient-contact-modal") do
          fill_autocomplete "person_auto_complete",
            with: person.family_name, select: person.to_s

          click_on "Save"
        end

        wait_for_ajax
      end
    end
  end
end
