module World
  module Letters::ClinicVisitLetter
    module Domain
      # @section helpers
      #
      def clinic_visit_letter_for(visit)
        visit = letters_clinic_visit(visit)
        visit.letter
      end

      # @section set-ups
      #
      def set_up_clinic_visit_letter_for(patient, visit:, user:)
        patient = letters_patient(patient)

        letter_attributes = valid_simple_letter_attributes(patient).merge(
          event: visit,
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
      def create_clinic_visit_letter(patient:, visit:, user:, issued_on:)
        patient = letters_patient(patient)

        letter_attributes = valid_simple_letter_attributes(patient).merge(
          event: visit,
          issued_on: issued_on,
          author: user,
          by: user
        )

        Renalware::Letters::DraftLetter.build.call(patient, letter_attributes)
      end

      def update_clinic_visit_letter(patient: nil, visit:, user:)
        patient = letters_patient(patient)

        existing_letter = clinic_visit_letter_for(visit)
        letter_attributes = {
          body: "updated body",
          by: user
        }

        Renalware::Letters::ReviseLetter.build.call(patient, existing_letter.id, letter_attributes)
      end

      # @section expectations
      #
      def expect_clinic_visit_letter_to_exist(visit:)
        letter = clinic_visit_letter_for(visit)

        expect(letter).to be_present
      end
    end


    module Web
      include Domain

      def create_clinic_visit_letter(patient:, visit: nil, user:, issued_on:)
        login_as user
        visit patient_clinic_visits_path(patient)
        click_on "Create Letter"

        attributes = valid_simple_letter_attributes(patient)
        fill_in "Date", with: I18n.l(attributes[:issued_on]) if issued_on.present?
        select attributes[:letterhead].name, from: "Letterhead"
        select user.full_name, from: "Author"
        fill_in "Description", with: attributes[:description]

        within ".bottom" do
          click_on "Create"
        end
      end

      def update_clinic_visit_letter(patient:, visit: nil, user:)
        login_as user
        visit patient_clinic_visits_path(patient)
        click_on "Preview Letter"
        click_on "Edit"

        select user.full_name, from: "Author"

        within ".bottom" do
          click_on "Save"
        end
      end
    end
  end
end
