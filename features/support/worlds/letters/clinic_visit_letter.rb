module World
  module Letters::ClinicVisitLetter
    module Domain
      # @section helpers
      #
      def clinic_visit_letter_for(visit)
        Renalware::Letters::Letter.for_event(visit)
      end

      def seed_letter(patient, attributes)
        Renalware::Letters::DraftLetter.build
          .on(:draft_letter_successful) { |letter| return letter }
          .on(:draft_letter_failed) { raise "Letter creation failed!" }
          .call(patient, attributes)
      end

      def draft_letter(patient, attributes)
        Renalware::Letters::DraftLetter.build
          .call(patient, attributes)
      end

      def revise_letter(patient, letter, attributes)
        Renalware::Letters::ReviseLetter.build
          .call(patient, letter.id, attributes)
      end

      def build_clinic_visit_letter_attributes(patient, visit, issued_on, user)
        valid_simple_letter_attributes(patient).merge(
          event: visit,
          issued_on: issued_on,
          author: user,
          by: user
        )
      end

      # @section set-ups
      #
      def seed_clinic_visit_letter_for(patient, user:)
        patient = letters_patient(patient)
        visit = clinic_visit_for(patient)

        letter_attributes = build_clinic_visit_letter_attributes(patient, visit, Date.today, user)

        seed_letter(patient, letter_attributes)
      end

      # @section commands
      #
      def draft_clinic_visit_letter(patient:, user:, issued_on:)
        visit = clinic_visit_for(patient)
        patient = letters_patient(patient)

        letter_attributes = build_clinic_visit_letter_attributes(patient, visit, issued_on, user)

        draft_letter(patient, letter_attributes)
      end

      def revise_clinic_visit_letter(patient: nil, user:)
        patient = letters_patient(patient)
        visit = clinic_visit_for(patient)
        letter = clinic_visit_letter_for(visit)

        revise_letter(patient, letter, body: "updated body", by: user)
      end

      # @section expectations
      #
      def expect_clinic_visit_letter_to_exist(patient:)
        visit = clinic_visit_for(patient)
        letter = clinic_visit_letter_for(visit)

        expect(letter).to be_present
      end

      def expect_letter_to_list_current_medications(patient: patient)
        visit = clinic_visit_for(patient)
        letter = clinic_visit_letter_for(visit)

        letter = Renalware::Letters::LetterPresenterFactory.new(letter)
        expect(letter.current_medications).to be_present
      end
    end

    module Web
      include Domain

      def draft_clinic_visit_letter(patient:, user:, issued_on:)
        login_as user
        visit patient_clinic_visits_path(patient)
        click_on "Draft Letter"

        attributes = valid_simple_letter_attributes(patient)
        fill_in "Date", with: I18n.l(attributes[:issued_on]) if issued_on.present?
        select attributes[:letterhead].name, from: "Letterhead"
        select user.full_name, from: "Author"
        fill_in "Description", with: attributes[:description]

        within ".bottom" do
          click_on "Create"
        end
      end

      def revise_clinic_visit_letter(patient:, user:)
        login_as user
        visit patient_clinic_visits_path(patient)
        click_on "Preview Letter"
        click_on "Edit"

        select user.full_name, from: "Author"

        within ".bottom" do
          click_on "Save"
        end
      end

      def expect_letter_to_list_current_medications(patient: patient)
        visit patient_clinic_visits_path(patient)
        click_on "Preview Letter"

        patient.medications.each do |medication|
          expect(page.body).to include(medication.drug.name)
        end
      end
    end
  end
end
