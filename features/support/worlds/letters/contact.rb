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
      def assign_contact(patient:, person:, default_cc: false, description_name: "Other", **_)
        patient = letters_patient(patient)
        contact_description = find_contact_description(name: description_name)

        contact = patient.assign_contact(person: person, default_cc: default_cc, description: contact_description)
        contact.save!
      end

      # @section expectations
      #
      def expect_available_contact(patient:, person:, description_name: "Other")
        patient = letters_patient(patient)
        expect(patient).to have_available_contact(person)

        description = find_contact_description(name: description_name)
        patient.with_contact_for(person) do |contact|
          expect(contact).to be_described_as(description)
        end
      end

      def expect_default_ccs(patient:, person:)
        patient = letters_patient(patient)
        expect(patient).to have_default_cc(person)
      end

      # @section helpers
      #
      def find_contact_description(attrs)
        Renalware::Letters::ContactDescription.find_by!(attrs)
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
          fill_autocomplete "#add-patient-contact-modal", "person_auto_complete",
            with: person.family_name, select: person.to_s
          check "Default CC" if default_cc

          click_on "Save"
        end

        wait_for_ajax
      end
    end
  end
end
