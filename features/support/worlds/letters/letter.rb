module World
  module Letters::Letter
    module Domain
      # @section helpers
      #
      def simple_letter_for(patient)
        patient = letters_patient(patient)
        patient.letters.first_or_initialize
      end

      def valid_simple_letter_attributes(patient)
        {
          letterhead: Renalware::Letters::Letterhead.first,
          patient: patient,
          issued_on: Time.zone.today,
          description: "Foo bar"
        }
      end

      # @section set-ups
      #
      def set_up_simple_letter_for(patient, user:)
        patient = letters_patient(patient)
        patient.letters.create!(
          valid_simple_letter_attributes(patient).merge(
            author: user,
            recipient_attributes: { source_type: "Renalware::Patient", source_id: patient.id },
            by: user
          )
        )
      end

      # @section commands
      #
      def create_simple_letter(patient:, user:, issued_on:, recipient:)
        patient = letters_patient(patient)

        letter_attributes = valid_simple_letter_attributes(patient).merge(
          issued_on: issued_on,
          author: user,
          by: user,
          recipient_attributes: build_recipient_attributes(recipient)
        )

        patient.letters.create(letter_attributes)
      end

      def update_simple_letter(patient:, user:)
        travel_to 1.hour.from_now

        letter = simple_letter_for(patient)
        letter.update_attributes!(
          updated_at: Time.zone.now,
          issued_on: (letter.issued_on + 1.day),
          author: user,
          by: user
        )
      end

      # @section expectations
      #
      def expect_simple_letter_to_exist(patient, recipient_type:, recipient: nil)
        patient = letters_patient(patient)
        letter = patient.letters.first

        expect(letter).to be_present

        case recipient_type
        when :doctor
          expect(letter.recipient.source).to be_a(Renalware::Doctor)
        when :patient
          expect(letter.recipient.source).to be_a(Renalware::Patient)
        else
          expect(letter.recipient.name).to eq(recipient[:name])
          expect(letter.recipient.address.city).to eq(recipient[:city])
        end
      end

      def expect_simple_letter_to_be_refused
        expect(Renalware::Letters::Letter.count).to eq(0)
      end

      private

      def build_recipient_attributes(recipient)
        if recipient.is_a? ActiveRecord::Base
          recipient_attributes = {
            source_type: recipient.class.name,
            source_id: recipient.id
          }
        else
          recipient_attributes = {
            source_type: nil,
            source_id: nil,
            name: recipient[:name],
            address_attributes: {
              city: recipient[:city],
              street_1: "1 Main St"
            }
          }
        end
      end
    end


    module Web
      include Domain

      def create_simple_letter(patient:, user:, issued_on:, recipient:)
        login_as user
        visit patient_letters_letters_path(patient)
        click_on "Add simple letter"

        attributes = valid_simple_letter_attributes(patient)
        fill_in "Date", with: I18n.l(attributes[:issued_on]) if issued_on.present?
        select attributes[:letterhead].name, from: "Letterhead"
        select user.full_name, from: "Author"
        fill_in "Description", with: attributes[:description]

        case recipient
        when Renalware::Patient
          choose("letters_letter_recipient_attributes_source_type_renalwarepatient")
        when Renalware::Doctor
          choose("letters_letter_recipient_attributes_source_type_renalwaredoctor")
        else
          choose("Postal Address Below")
          fill_in "Name", with: recipient[:name]
          fill_in "Line 1", with: "1 Main st"
          fill_in "City", with: recipient[:city]
        end

        within ".bottom" do
          click_on "Create"
        end
      end

      def update_simple_letter(patient:, user:)
        login_as user
        visit patient_letters_letters_path(patient)
        click_on "Edit"

        select user.full_name, from: "Author"

        within ".bottom" do
          click_on "Save"
        end
      end
    end
  end
end
