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
            recipient_type: :patient,
            by: user
          )
        )
      end

      # @section commands
      #
      def create_simple_letter(patient:, user:, issued_on:, recipient_type:, recipient_info: nil)
        patient = letters_patient(patient)
        if recipient_info.present?
          recipient = Renalware::Letters::Recipient.new(name: recipient_info[:name])
          recipient.build_address(
            city: recipient_info[:city],
            street_1: "1 Main St"
          )
        end
        patient.letters.create(
          valid_simple_letter_attributes(patient).merge(
            issued_on: issued_on,
            author: user,
            recipient_type: recipient_type,
            recipient: recipient,
            by: user
          )
        )
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
        expect(patient.letters).to be_present
        letter = patient.letters.first
        expect(letter.recipient_type).to eq(recipient_type)
        if recipient_type == :other
          expect(letter.recipient.name).to eq(recipient[:name])
          expect(letter.recipient.address.city).to eq(recipient[:city])
        end
      end

      def expect_simple_letter_to_be_refused
        expect(Renalware::Letters::Letter.count).to eq(0)
      end
    end


    module Web
      include Domain

      def create_simple_letter(user:, patient:, issued_on:)
        login_as user
        visit patient_letters_letters_path(patient)
        click_on "Add simple letter"

        attributes = valid_simple_letter_attributes(patient)
        fill_in "Date", with: I18n.l(attributes[:issued_on]) if issued_on.present?
        select attributes[:letterhead].name, from: "Letterhead"
        select user.full_name, from: "Author"
        fill_in "Description", with: attributes[:description]

        within ".top" do
          click_on "Create"
        end
      end

      def update_simple_letter(patient:, user:)
        login_as user
        visit patient_letters_letters_path(patient)
        click_on "Edit"

        select user.full_name, from: "Author"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
