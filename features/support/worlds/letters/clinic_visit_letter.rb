# frozen_string_literal: true

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

      # @section seeding
      #
      def seed_observations_relevant_to_clinic_letter(patient:)
        patient = Renalware::Pathology.cast_patient(patient)

        code = Renalware::Letters::RelevantObservationDescription.codes.first
        description = Renalware::Pathology::ObservationDescription.find_by!(code: code)
        observations_attributes = [
          { description: description, result: 10, observed_at: 1.day.ago }
        ]

        Renalware::Pathology::ObservationRequest.create!(
          patient: patient,
          requestor_name: "KCH",
          requested_at: Time.zone.now,
          description: Renalware::Pathology::RequestDescription.first!,
          observations_attributes: observations_attributes
        )
      end

      def seed_clinic_visit_letter_for(patient, user:)
        patient = letters_patient(patient)
        visit = clinic_visit_for(patient)

        letter_attributes = build_clinic_visit_letter_attributes(
          patient,
          visit,
          Time.zone.today,
          user
        )

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

      def expect_letter_to_list_current_prescriptions(patient:)
        visit = clinic_visit_for(patient)
        letter = clinic_visit_letter_for(visit)

        letter = Renalware::Letters::LetterPresenterFactory.new(letter)
        expect(letter.part_for(:prescriptions)).to be_present
      end

      def expect_letter_to_list_clinical_observations(patient:)
        visit = clinic_visit_for(patient)
        letter = clinic_visit_letter_for(visit)

        letter = Renalware::Letters::LetterPresenterFactory.new(letter)
        expect(letter.part_for(:clinical_observations)).to be_present
      end

      def expect_letter_to_list_problems(patient:)
        visit = clinic_visit_for(patient)
        letter = clinic_visit_letter_for(visit)

        letter = Renalware::Letters::LetterPresenterFactory.new(letter)
        expect(letter.part_for(:problems)).to be_present
      end

      def expect_letter_to_list_recent_pathology_results(patient:)
        visit = clinic_visit_for(patient)
        letter = clinic_visit_letter_for(visit)

        letter = Renalware::Letters::LetterPresenterFactory.new(letter)
        expect(letter.part_for(:recent_pathology_results)).to be_present
      end
    end

    module Web
      include Domain

      def draft_clinic_visit_letter(patient:, user:, issued_on:)
        login_as user
        FactoryBot.create(:letter_description, text: "Foo bar")
        visit patient_clinic_visits_path(patient)
        find("td.actions .dropdown").click
        click_on "Draft Letter"

        attributes = valid_simple_letter_attributes(patient)
        fill_in "Date", with: I18n.l(attributes[:issued_on]) if issued_on.present?
        select attributes[:letterhead].name, from: "Letterhead"
        select user.to_s, from: "Author"
        select2 attributes[:description], css: ".letter_description"

        within ".bottom" do
          click_on "Create"
        end
      end

      def revise_clinic_visit_letter(patient:, user:)
        login_as user
        visit patient_clinic_visits_path(patient)
        find("td.actions .dropdown").click
        click_on "Preview Letter"
        click_on "Edit"

        select user.to_s, from: "Author"

        within ".bottom" do
          click_on "Save"
        end
      end

      def expect_letter_to_list_current_prescriptions(patient:)
        visit patient_clinic_visits_path(patient)
        find("td.actions .dropdown").click
        click_on "Preview Letter"

        visit_iframe_content

        patient.prescriptions.each do |prescription|
          expect(page.body).to include(prescription.drug.name)
        end
      end

      def expect_letter_to_list_clinical_observations(patient:)
        visit patient_clinic_visits_path(patient)
        find("td.actions .dropdown").click
        click_on "Preview Letter"

        visit_iframe_content

        clinic_visit = clinic_visit_for(patient)
        expect(page.body).to include(clinic_visit.height.to_s)
        expect(page.body).to include(clinic_visit.weight.to_s)
        expect(page.body).to include(clinic_visit.bp)
      end

      def expect_letter_to_list_problems(patient:)
        visit patient_clinic_visits_path(patient)
        find("td.actions .dropdown").click
        click_on "Preview Letter"

        visit_iframe_content

        patient.problems.each do |problem|
          expect(page.body).to include(problem.description)
          expect(page.body).to include(problem.notes.first.description)
        end
      end

      def expect_letter_to_list_recent_pathology_results(patient:)
        visit patient_clinic_visits_path(patient)
        click_on "Preview Letter"

        visit_iframe_content

        pathology_patient = Renalware::Pathology.cast_patient(patient)

        expect(pathology_patient.observations).to be_present

        pathology_patient.observations.each do |observation|
          expect(page.body).to include(observation.to_s)
        end
      end

      def visit_iframe_content
        visit find("iframe")[:src]
      end
    end
  end
end
