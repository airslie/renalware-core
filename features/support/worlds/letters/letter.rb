module World
  module Letters::Letter
    module Domain
      # @section helpers
      #
      def simple_letter_for(patient)
        patient = letters_patient(patient)
        patient.letters.first_or_initialize
      end

      def letter_recipients_map
        {
          "Patty" => @patty,
          "Doug" => @patty.doctor,
          "John in London" => { name: "John", city: "London" },
          "Kate in Ely" => { name: "Kate", city: "Ely" }
        }
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

        letter_attributes = valid_simple_letter_attributes(patient).merge(
          author: user,
          main_recipient_attributes: { person_role: "patient" },
          by: user
        )

        Renalware::Letters::DraftLetter.build
          .on(:draft_letter_successful) { |letter| return letter }
          .on(:draft_letter_failed) { raise "Letter creation failed!" }
          .call(patient, letter_attributes)
      end

      # @section commands
      #
      def create_simple_letter(patient:, user:, issued_on:, recipient:, ccs: nil)
        patient = letters_patient(patient)

        letter_attributes = valid_simple_letter_attributes(patient).merge(
          issued_on: issued_on,
          author: user,
          by: user,
          main_recipient_attributes: build_main_recipient_attributes(recipient),
          cc_recipients_attributes: build_cc_recipients_attributes(ccs)
        )

        Renalware::Letters::DraftLetter.build.call(patient, letter_attributes)
      end

      def update_simple_letter(patient:, user:)
        patient = letters_patient(patient)

        existing_letter = simple_letter_for(patient)
        letter_attributes = {
          body: "updated body",
          by: user
        }

        Renalware::Letters::ReviseLetter.build.call(patient, existing_letter.id, letter_attributes)
      end

      def mark_draft_as_typed(patient:, user:)
        draft_letter = simple_letter_for(patient)

        typed_letter = draft_letter.typed!(by: user)
        typed_letter.save!
      end

      # @section expectations
      #
      def expect_simple_letter_to_exist(patient, recipient:)
        patient = letters_patient(patient)

        letter = patient.letters.first
        expect(letter).to be_present

        main_recipient = Renalware::Letters::LetterPresenterFactory.new(letter).main_recipient
        if recipient.is_a? Renalware::Patient
          expect(main_recipient.person_role).to eq("patient")
          expect(main_recipient.address.city).to eq(recipient.current_address.city)
        elsif recipient.is_a? Renalware::Doctor
          expect(main_recipient.person_role).to eq("doctor")
          expect(main_recipient.address.city).to eq(recipient.current_address.city)
        else
          expect(main_recipient.address.name).to eq(recipient[:name])
          expect(main_recipient.address.city).to eq(recipient[:city])
        end
      end

      def expect_simple_letter_to_be_refused
        expect(Renalware::Letters::Letter.count).to eq(0)
      end

      def expect_simple_letter_to_have_ccs(patient, ccs:)
        patient = letters_patient(patient)
        letter = Renalware::Letters::LetterPresenterFactory.new(patient.letters.first)

        expect(letter.cc_recipients.size).to eq(ccs.size)

        ccs_map = ccs.map do |cc|
          if cc.is_a? Renalware::Patient
            ["patient", cc.current_address.city]
          elsif cc.is_a? Renalware::Doctor
            ["doctor", cc.current_address.city]
          else
            ["other", cc[:city]]
          end
        end

        cc_recipients_map = letter.cc_recipients.map do |cc|
          [cc.person_role, cc.address.city]
        end

        expect(ccs_map).to match_array(cc_recipients_map)
      end

      def expect_letter_to_be_addressed_to(letter:, address_attributes:)
        letter = Renalware::Letters::LetterPresenterFactory.new(letter)
        attributes = letter.main_recipient.address.attributes.symbolize_keys
        expect(attributes).to include(address_attributes)
      end

      private

      def build_main_recipient_attributes(recipient)
        build_recipient_attributes(recipient)
      end

      def build_cc_recipients_attributes(recipients)
        return [] if recipients.blank?

        recipients.map do |recipient|
          build_recipient_attributes(recipient)
        end
      end

      def build_recipient_attributes(recipient)
        case recipient
        when Renalware::Doctor
          { person_role: "doctor" }
        when Renalware::Patient
          { person_role: "patient" }
        else
          {
            person_role: "other",
            address_attributes: {
              name: recipient[:name],
              city: recipient[:city],
              street_1: "1 Main St"
            }
          }
        end
      end
    end


    module Web
      include Domain

      def create_simple_letter(patient:, user:, issued_on:, recipient:, ccs: nil)
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
          choose("letters_letter_draft_main_recipient_attributes_person_role_patient")
        when Renalware::Doctor
          choose("letters_letter_draft_main_recipient_attributes_person_role_doctor")
        else
          choose("Postal Address Below")
          fill_in "Name", with: recipient[:name]
          fill_in "Line 1", with: "1 Main st"
          fill_in "City", with: recipient[:city]
        end

        if ccs.present?
          ccs.each_with_index do |cc, index|
            find(".call-to-action").click
            within(".nested-fields:nth-child(#{index + 1})") do
              fill_in "Name", with: cc[:name]
              fill_in "Line 1", with: "1 Main st"
              fill_in "City", with: cc[:city]
            end
          end
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

      def mark_draft_as_typed(patient:, user:)
        login_as user
        existing_letter = simple_letter_for(patient)

        visit patient_letters_letter_path(patient, existing_letter)

        click_on "Mark as Typed"
      end
    end
  end
end
