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
        result = Renalware::Letters::DraftLetter.new(patient.letters.build).call(
          valid_simple_letter_attributes(patient).merge(
            author: user,
            main_recipient_attributes: { source_type: "Renalware::Patient", source_id: patient.id },
            by: user
          )
        )
        raise "Letter creation failed!" unless result
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
        Renalware::Letters::DraftLetter.new(patient.letters.build).call(letter_attributes)
      end

      def update_simple_letter(patient:, user:)
        travel_to 1.hour.from_now

        letter = simple_letter_for(patient)
        Renalware::Letters::DraftLetter.new(letter).call(
          updated_at: Time.zone.now,
          issued_on: (letter.issued_on + 1.day),
          author: user,
          by: user
        )
      end

      # @section expectations
      #
      def expect_simple_letter_to_exist(patient, recipient:)
        patient = letters_patient(patient)
        letter = patient.letters.first

        expect(letter).to be_present

        if recipient.is_a? ActiveRecord::Base
          expect(letter.main_recipient.source).to eq(recipient)
          expect(letter.main_recipient.address.city).to eq(recipient.current_address.city)
        else
          expect(letter.main_recipient.name).to eq(recipient[:name])
          expect(letter.main_recipient.address.city).to eq(recipient[:city])
        end
      end

      def expect_simple_letter_to_be_refused
        expect(Renalware::Letters::Letter.count).to eq(0)
      end

      def expect_simple_letter_to_have_ccs(patient, ccs:)
        patient = letters_patient(patient)
        letter = patient.letters.first

        expect(letter.cc_recipients.size).to eq(ccs.size)

        ccs_map = ccs.map do |cc|
          if cc.is_a? ActiveRecord::Base
            [cc.class.name, cc.id, cc.current_address.city]
          else
            [nil, nil, cc[:city]]
          end
        end

        cc_recipients_map = letter.cc_recipients.map do |cc|
          [cc.source_type, cc.source_id, cc.address.city]
        end

        expect(ccs_map).to match_array(cc_recipients_map)
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
        if recipient.is_a? ActiveRecord::Base
          {
            source_type: recipient.class.name,
            source_id: recipient.id
          }
        else
          {
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
          choose("letters_letter_main_recipient_attributes_source_type_renalwarepatient")
        when Renalware::Doctor
          choose("letters_letter_main_recipient_attributes_source_type_renalwaredoctor")
        else
          choose("Postal Address Below")
          fill_in "Name", with: recipient[:name]
          fill_in "Line 1", with: "1 Main st"
          fill_in "City", with: recipient[:city]
        end

        if ccs.present?
          ccs.each_with_index do |cc, index|
            find(".call-to-action").click
            within(:xpath, "(//div[@class=\"nested-fields\"])[#{index + 1}]") do
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
    end
  end
end
