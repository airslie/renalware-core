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
        patient = letters_patient(@patty)

        {
          "Patty" => @patty,
          "Phylis" => @patty.primary_care_physician,
          "John in London" => { name: "John", city: "London" },
          "Kate in Ely" => { name: "Kate", city: "Ely" },
          "Sam" => find_contact(patient, "Sam")
        }
      end

      def find_contact(patient, person_given_name)
        patient.contacts.detect { |c| c.person.given_name == person_given_name }
      end

      def valid_simple_letter_attributes(patient)
        {
          letterhead: Renalware::Letters::Letterhead.first,
          patient: patient,
          issued_on: Time.zone.today,
          description: "Foo bar"
        }
      end

      # @section seeding
      #
      def seed_simple_letter_for(patient, options)
        user = options.fetch(:user)
        author = options.fetch(:author, user)

        patient = letters_patient(patient)

        letter_attributes = valid_simple_letter_attributes(patient).merge(
          main_recipient_attributes: { person_role: "patient" },
          by: user,
          author: author
        )

        Renalware::Letters::DraftLetter.build
          .on(:draft_letter_successful) { |letter| return letter }
          .on(:draft_letter_failed) { raise "Letter creation failed!" }
          .call(patient, letter_attributes)
      end

      def seed_letters(table)
        table.hashes.each do |row|
          patient = find_or_create_patient_by_name(row[:patient])
          author = find_or_create_user(given_name: row[:author], role: "clinician")
          typist = find_or_create_user(given_name: row[:typist], role: "clinician")
          letter = seed_simple_letter_for(patient, user: typist, author: author)

          move_letter_to_state(letter, row[:state])
        end
      end

      # @section commands
      #
      def draft_simple_letter(options)
        patient = options.fetch(:patient)
        user = options.fetch(:user)
        issued_on = options.fetch(:issued_on)
        recipient = options.fetch(:recipient)
        author = options.fetch(:author, user)
        ccs = options.fetch(:ccs, nil)

        patient = letters_patient(patient)

        letter_attributes = valid_simple_letter_attributes(patient).merge(
          issued_on: issued_on,
          author: author,
          by: user,
          main_recipient_attributes: build_main_recipient_attributes(recipient),
          cc_recipients_attributes: build_cc_recipients_attributes(ccs)
        )

        Renalware::Letters::DraftLetter.build.call(patient, letter_attributes)
      end

      def revise_simple_letter(patient:, user:)
        patient = letters_patient(patient)

        existing_letter = simple_letter_for(patient)
        letter_attributes = {
          body: "updated body",
          by: user
        }

        Renalware::Letters::ReviseLetter.build.call(patient, existing_letter.id, letter_attributes)
      end

      def submit_for_review(patient:, user:)
        draft_letter = simple_letter_for(patient)

        letter_pending_review = draft_letter.submit(by: user)
        letter_pending_review.save!
      end

      def reject_letter(patient:, user:)
        letter_pending_review = simple_letter_for(patient)

        draft_letter = letter_pending_review.reject(by: user)
        draft_letter.save!
      end

      def approve_letter(patient:, user:)
        letter_pending_review = simple_letter_for(patient)

        Renalware::Letters::ApproveLetter.build(letter_pending_review).call(by: user)
      end

      def mark_letter_as_printed(patient:, user:)
        approved_letter = simple_letter_for(patient)

        Renalware::Letters::CompleteLetter.build(approved_letter).call(by: user)
      end

      def view_letters(q: nil, **_)
        @query = Renalware::Letters::LetterQuery.new(q: q)
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
        elsif recipient.is_a? Renalware::Patients::PrimaryCarePhysician
          expect(main_recipient.person_role).to eq("primary_care_physician")
          expect(main_recipient.address.city).to eq(recipient.current_address.city)
        elsif recipient.is_a? Renalware::Letters::Contact
          expect(main_recipient.person_role).to eq("contact")
          expect(main_recipient.addressee).to eq(recipient)
        else
          expect(main_recipient.address.name).to eq(recipient[:name])
          expect(main_recipient.address.city).to eq(recipient[:city])
        end
      end

      def expect_letter_to_be_refused
        expect(Renalware::Letters::Letter.count).to eq(0)
      end

      def expect_simple_letter_to_have_ccs(patient, ccs:)
        patient = letters_patient(patient)
        letter = Renalware::Letters::LetterPresenterFactory.new(patient.letters.first)

        expect(letter.cc_recipients.size).to eq(ccs.size)

        ccs_map = ccs.map do |cc|
          if cc.is_a? Renalware::Patient
            ["patient", cc.current_address.city]
          elsif cc.is_a? Renalware::Patients::PrimaryCarePhysician
            ["primary_care_physician", cc.current_address.city]
          else
            ["contact", cc[:city]]
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

      def expect_letter_can_be_approved(patient:, user:)
        letter = simple_letter_for(patient)
        policy = letter.class.policy_class.new(user, letter)

        expect(policy.approve?).to be_truthy
      end

      def expect_archived_letter(patient:)
        letter = simple_letter_for(patient)

        expect(letter).to be_archived
        expect(letter.archive).to be_present
        letter.recipients.each do |recipient|
          expect(recipient.address).to be_present
        end
      end

      def expect_letter_to_not_be_modified(patient:, user:)
        letter = simple_letter_for(patient)
        policy = letter.class.policy_class.new(user, letter)

        expect(policy.update?).to be_falsy
      end

      def expect_letter_to_be_signed(patient:, user:)
        letter = simple_letter_for(patient)

        expect(letter).to be_signed
      end

      def expect_letter_to_be_completed(patient:, user:)
        letter = simple_letter_for(patient)

        expect(letter).to be_completed
      end

      def expect_letters_to_be(table)
        letters = @query.call
        expect(letters.size).to eq(table.hashes.size)

        entries = letters.map do |r|
          hash = {
            author: r.author.given_name,
            typist: r.created_by.given_name,
            patient: r.patient.full_name,
            state: r.state
          }
          hash.with_indifferent_access
        end
        table.hashes.each do |row|
          expect(entries).to include(row)
        end
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
        when Renalware::Patients::PrimaryCarePhysician
          { person_role: "primary_care_physician" }
        when Renalware::Patient
          { person_role: "patient" }
        when Renalware::Letters::Contact
          {
            person_role: "contact",
            addressee_id: recipient.id
          }
        else
          {
            person_role: "contact",
            address_attributes: {
              name: recipient[:name],
              city: recipient[:city],
              street_1: "1 Main St"
            }
          }
        end
      end

      def move_letter_to_state(letter, state)
        state_class = "Renalware::Letters::Letter::#{state.classify}".constantize
        letter.becomes!(state_class).tap do |new_letter|
          new_letter.by = new_letter.created_by
          new_letter.save!
        end
      end
    end


    module Web
      include Domain

      def draft_simple_letter(patient:, user:, issued_on:, recipient:, ccs: nil)
        login_as user
        visit patient_letters_letters_path(patient)
        click_on "Draft Letter"

        attributes = valid_simple_letter_attributes(patient)
        fill_in "Date", with: I18n.l(attributes[:issued_on]) if issued_on.present?
        select attributes[:letterhead].name, from: "Letterhead"
        select user.to_s, from: "Author"
        fill_in "Description", with: attributes[:description]

        fill_recipient(recipient)
        fill_ccs(ccs)

        within ".bottom" do
          click_on "Create"
        end
      end

      def fill_recipient(recipient)
        case recipient
        when Renalware::Patient
          choose("letter_main_recipient_attributes_person_role_patient")
        when Renalware::Patients::PrimaryCarePhysician
          choose("letter_main_recipient_attributes_person_role_primary_care_physician")
        else
          choose("Patient's Contact")
          select recipient.person.to_s, from: "letter_main_recipient_attributes_addressee_id"
        end
      end

      def fill_ccs(ccs)
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
      end

      def revise_simple_letter(patient:, user:)
        login_as user
        visit patient_letters_letters_path(patient)
        click_on "Edit"

        select user.to_s, from: "Author"

        within ".bottom" do
          click_on "Save"
        end
      end

      def submit_for_review(patient:, user:)
        login_as user
        existing_letter = simple_letter_for(patient)

        visit patient_letters_letter_path(patient, existing_letter)

        click_on "Submit for Review"
      end

      def reject_letter(patient:, user:)
        login_as user
        existing_letter = simple_letter_for(patient)

        visit patient_letters_letter_path(patient, existing_letter)

        click_on "Reject"
      end

      def approve_letter(patient:, user:)
        login_as user
        existing_letter = simple_letter_for(patient)

        visit patient_letters_letter_path(patient, existing_letter)

        click_on "Approve and archive"
      end

      def mark_letter_as_printed(patient:, user:)
        login_as user
        existing_letter = simple_letter_for(patient)

        visit patient_letters_letter_path(patient, existing_letter)

        click_on "Mark as printed"
      end

      def view_letters(q: nil, user:)
        login_as user
        visit letters_list_path(q: q)
      end

      def expect_letters_to_be(table)
        table.hashes.each do |row|
          given_name, family_name = row[:patient].split(" ").map(&:strip)
          expect(page.body).to have_content("#{family_name}, #{given_name}")
        end
      end
    end
  end
end
