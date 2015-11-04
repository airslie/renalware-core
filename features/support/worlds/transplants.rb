module World
  module Transplants

    def registration_status_description_named(name)
      Renalware::Transplants::RegistrationStatusDescription.find_or_create_by(
        name: name
      )
    end

    def status_for_registration_and_name(registration, name)
      description = registration_status_description_named(name)
      registration.statuses.find_by description: description
    end


    module Domain
      def create_recipient_workup(user: nil, patient:)
        Renalware::Transplants::RecipientWorkup.create!(
          patient: patient
        )
      end

      def create_donor_workup(user: nil, patient:)
        Renalware::Transplants::DonorWorkup.create!(
          patient: patient,
          document: {
            relationship: {
              donor_recip_relationship: "son_or_daughter"
            }
          }
        )
      end

      def update_workup(workup:, user: nil, updated_at:)
        workup.update_attributes!(
          document: {
            historicals: {
              tb: "no"
            }
          },
          updated_at: updated_at
        )
      end

      def update_donor_workup(workup:, user: nil, updated_at:)
        workup.update_attributes!(
          document: {
            relationship: {
              donor_recip_relationship: "son_or_daughter"
            },
            comorbidities: {
              angina: {
                status: "no"
              }
            }
          },
          updated_at: updated_at
        )
      end

      def set_transplant_registration_status(registration:, user: nil, status:, started_on:)
        description = registration_status_description_named(status)
        @status = registration.add_status!(description: description, started_on: started_on)
      end

      def recipient_workup_exists(patient)
        Renalware::Transplants::RecipientWorkup.for_patient(patient).any?
      end

      def donor_workup_exists(donor)
        Renalware::Transplants::DonorWorkup.for_patient(donor).any?
      end

      def transplant_registration_exists(patient:, status_name:, started_on:)
        registration = Renalware::Transplants::Registration.for_patient(patient).first
        expect(registration).to_not be_nil
        status = registration.current_status
        expect(registration.current_status).to_not be_nil
        expect(registration.current_status.description.name).to eq(status_name)
        expect(registration.current_status.started_on).to eq(Date.parse(started_on))
      end

      def workup_was_updated(patient)
        workup = Renalware::Transplants::RecipientWorkup.for_patient(patient).first
        workup.updated_at != workup.created_at
      end

      def donor_workup_was_updated(patient)
        workup = Renalware::Transplants::DonorWorkup.for_patient(patient).first
        workup.updated_at != workup.created_at
      end

      def create_transplant_registration(user: nil, patient:, status:, started_on:)
        description = registration_status_description_named(status)
        @registration = Renalware::Transplants::Registration.create(
          patient: patient,
          statuses_attributes: {
            "0": {
              started_on: started_on,
              description_id: description.id
            }
          }
        )
      end

      def update_transplant_registration(registration:, user: nil, updated_at:)
        registration.update_attributes!(
          document: {
          },
          updated_at: updated_at
        )
        registration.reload
        registration.updated_at != registration.created_at
      end

      def transplant_registration_was_refused
        expect(@registration).to_not be_valid
      end

      def transplant_registration_has_errors
        expect(@registration.errors).to_not be_empty
      end

      def transplant_registration_status_was_refused
        expect(@status).to_not be_valid
      end

      def transplant_registration_status_has_errors
        expect(@status.errors).to_not be_empty
      end

      def transplant_registration_status_history_matches(registration:, hashes:)
        statuses = registration.reload.statuses.map do |s|
          { status: s.description.name,
            start_date: I18n.l(s.started_on),
            termination_date: (s.terminated_on ? I18n.l(s.terminated_on) : "")
          }.with_indifferent_access
        end
        expect(statuses.size).to eq(hashes.size)
        hashes.each do |row|
          expect(statuses).to include(row)
        end
      end

      def transplant_registration_current_status_is(registration:, name:, started_on:)
        status = registration.current_status
        expect(status.to_s).to eq(name)
        expect(I18n.l(status.started_on)).to eq(started_on)
      end

      def transplant_registration_status_history_includes(registration:, hashes:)
        statuses = registration.reload.statuses.map do |s|
          { status: s.description.name,
            start_date: I18n.l(s.started_on),
            termination_date: (s.terminated_on ? I18n.l(s.terminated_on) : "")
          }.with_indifferent_access
        end
        hashes.each do |row|
          expect(statuses).to include(row)
        end
      end

      def update_transplant_registration_status(registration:, user:, status:, started_on:)
        s = status_for_registration_and_name(registration, status)
        registration.update_status!(s, started_on: started_on)
      end

      def delete_transplant_registration_status(registration:, user:, status:)
        s = status_for_registration_and_name(registration, status)
        registration.delete_status!(s)
      end

    end

    module Web
      def create_recipient_workup(user:, patient:)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Recipient Workup"

        fill_in "Karnofsky Score", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def create_donor_workup(user:, patient:)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Donor Workup"

        select "Mother or father", from: "Relationship to Recipient"
        fill_in "Oral GTT", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def create_transplant_registration(user:, patient:, status:, started_on:)
        login_as user
        visit patient_transplants_dashboard_path(patient)
        click_on "Enter registration details"

        select "Kidney only", from: "Transplant Type"
        within_fieldset "Status" do
          fill_in "Started on", with: started_on
          select "Active", from: "Description"
        end

        within ".top" do
          click_on "Save"
        end
      end

      def update_workup(workup:, user:, updated_at: nil)
        login_as user
        visit patient_clinical_summary_path(workup.patient)
        click_on "Transplant Recipient Workup"
        click_on "Edit"

        fill_in "Cervical smear result", with: "193"

        within ".top" do
          click_on "Save"
        end
      end

      def update_donor_workup(workup:, user:, updated_at: nil)
        login_as user
        visit patient_clinical_summary_path(workup.patient)
        click_on "Transplant Donor Workup"
        click_on "Edit"

        fill_in "Calculated Clearance", with: "193"

        within ".top" do
          click_on "Save"
        end
      end

      def update_transplant_registration(registration:, user:, updated_at: nil)
        login_as user
        visit patient_transplants_dashboard_path(registration.patient)
        within_fieldset "Transplant Wait List Registration" do
          click_on "Edit"
        end

        select "Pancreas only", from: "Transplant Type"

        within ".top" do
          click_on "Save"
        end

        have_content("Pancreas only")
      end

      def set_transplant_registration_status(user:, registration:, status:, started_on:)
        login_as user
        visit patient_transplants_dashboard_path(registration.patient)
        within_fieldset "Status History" do
          fill_in "transplants_registration_status[started_on]", with: started_on
          select status, from: "transplants_registration_status[description_id]"
          click_on "Add status"
        end
      end

      def update_transplant_registration_status(user:, registration:, status:, started_on:)
        login_as user
        visit patient_transplants_dashboard_path(registration.patient)
        within_fieldset "Status History" do
          find(:xpath, "//tr[td[contains(.,'#{status}')]]/td/a", text: 'Edit').click
        end

        fill_in "transplants_registration_status[started_on]", with: started_on
        click_on "Save"
      end

      def delete_transplant_registration_status(registration:, user:, status:)
        login_as user
        visit patient_transplants_dashboard_path(registration.patient)
        within_fieldset "Status History" do
          find(:xpath, "//tr[td[contains(.,'#{status}')]]/td/a", text: 'Delete').click
        end
      end

      def transplant_registration_was_refused
        expect(page).to have_css("input[type=submit]")
      end

      def transplant_registration_has_errors
        expect(page).to have_css("small.error")
      end

      def transplant_registration_status_was_refused
        within_fieldset "Status History" do
          expect(page.all('tbody tr').size).to eq(@initial_statuses_count)
        end
      end

      def transplant_registration_status_has_errors
        within_fieldset "Status History" do
          expect(page).to have_css("small.error")
        end
      end

      def recipient_workup_exists(patient)
        expect(page).to have_content("Heart failure")
      end

      def donor_workup_exists(donor)
        expect(page).to have_content("Heart failure")
      end

      def transplant_registration_exists(patient:, status_name:, started_on:)
        expect(page).to have_content("Kidney only")
        expect(page).to have_content(status_name)
        expect(page).to have_content(started_on)
      end

      def workup_was_updated(patient)
        expect(page).to have_content("Heart failure")
      end

      def donor_workup_was_updated(patient)
        expect(page).to have_content("193")
      end

      def transplant_registration_status_history_matches(registration: nil, hashes:)
        within_fieldset "Status History" do
          hashes.each do |row|
            expect(page).to have_content(row[:status])
            expect(page).to have_content(row[:start_date])
            expect(page).to have_content(row[:termination_date]) if row[:termination_date].present?
          end
        end
      end

      def transplant_registration_current_status_is(registration: nil, name:, started_on:)
        within_fieldset "Transplant Wait List Registration" do
          expect(page).to have_content(name)
          expect(page).to have_content(started_on)
        end
      end

      def transplant_registration_status_history_includes(registration: nil, hashes:)
        sets = hashes.map do |row|
          [row[:start_date], row[:status], row[:termination_date]]
        end

        within_fieldset "Status History" do
          sets.each do |set|
            row = page.all('tr').detect do |tr|
              row_texts = tr.all("td").map(&:text)
              (set - row_texts).empty? # Texts include all the ones in the set?
            end
            expect(row).to_not be_nil
          end
        end
      end
    end
  end
end
