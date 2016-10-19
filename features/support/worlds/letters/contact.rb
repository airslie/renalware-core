module World
  module Letters::Contact
    module Domain
      # @section seeding
      #
      def seed_contact(patient:, person:)
        patient = letters_patient(patient)
        description = find_contact_description(system_code: "referring_physician")
        contact = patient.assign_contact(person: person, description: description)
        contact.save!
      end

      # @section commands
      #
      def assign_contact(patient:, person:, default_cc: false, description_name: "Sibling", **_)
        patient = letters_patient(patient)
        description_attrs = determine_description_attrs(description_name)
        contact_attrs = { person: person, default_cc: default_cc }.merge(description_attrs)
        contact = patient.assign_contact(contact_attrs)
        contact.save!
      end

      # @section expectations
      #
      def expect_available_contact(patient:, person:, description_name: "Sibling")
        patient = letters_patient(patient)
        expect(patient).to have_available_contact(person)

        description = find_contact_description(name: description_name)
        patient.with_contact_for(person) do |contact|
          expect(contact).to be_described_as(description || description_name)
        end
      end

      def expect_default_ccs(patient:, person:)
        patient = letters_patient(patient)
        expect(patient).to have_default_cc(person)
      end

      # @section helpers
      #
      def find_contact_description(attrs)
        Renalware::Letters::ContactDescription.find_by(attrs)
      end

      def find_unspecified_contact_description
        Renalware::Letters::ContactDescription[:other]
      end

      def determine_description_attrs(description_name)
        contact_description = find_contact_description(name: description_name)

        if contact_description.present?
          { description: contact_description }
        else
          unspecified_contact_description = find_unspecified_contact_description
          { description: unspecified_contact_description, other_description: description_name }
        end
      end
    end

    module Web
      include Domain

      # @section commands
      #
      def assign_contact(patient:, person:, user:, default_cc: false, description_name: "Sibling")
        login_as user

        visit patient_letters_contacts_path(patient)
        click_on "Add contact"

        within("#add-patient-contact-modal") do
          fill_autocomplete "#add-patient-contact-modal", "person_auto_complete",
            with: person.family_name, select: person.to_s
          check "Default CC" if default_cc

          if find_contact_description(name: description_name)
            select description_name, from: "Description"
          else
            select "Other", from: "Description"
            fill_in "Other description", with: description_name
          end

          click_on "Save"
        end

        wait_for_ajax
      end
    end
  end
end
