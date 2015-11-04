module World
  module Transplants

    module Domain
      # Helpers

      def registration_status_description_named(name)
        Renalware::Transplants::RegistrationStatusDescription.find_or_create_by(
          name: name
        )
      end

      def status_for_registration_and_name(registration, name)
        description = registration_status_description_named(name)
        registration.statuses.find_by description: description
      end

      def transplant_registration_for(patient)
        Renalware::Transplants::Registration.for_patient(patient).first_or_initialize
      end

      def donor_workup_for(patient)
        Renalware::Transplants::DonorWorkup.for_patient(patient).first_or_initialize
      end

      def recipient_workup_for(patient)
        Renalware::Transplants::RecipientWorkup.for_patient(patient).first_or_initialize
      end

      # Set-ups

      def set_up_recipient_workup_for(patient)
        Renalware::Transplants::RecipientWorkup.create!(
          patient: patient
        )
      end

      def set_up_doner_workup_for(patient)
        Renalware::Transplants::DonorWorkup.create!(
          patient: patient,
          document: {
            relationship: {
              donor_recip_relationship: "son_or_daughter"
            }
          }
        )
      end

      def set_up_patient_wait_list_statuses(patient, table)
        registration = Renalware::Transplants::Registration.create!(
          patient: patient
        )
        table.hashes.each do |row|
          description = registration_status_description_named(row[:status])
          registration.statuses.create!(
            description: description,
            started_on: row[:start_date],
            terminated_on: row[:termination_date],
            whodunnit: Renalware::User.find_by(first_name: row[:by]).id,
          )
        end
        @initial_statuses_count = registration.statuses.count
      end

      # Commands

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

      def update_workup(patient:, user: nil, updated_at:)
        workup = recipient_workup_for(patient)
        workup.update_attributes!(
          document: {
            historicals: {
              tb: "no"
            }
          },
          updated_at: updated_at
        )
      end

      def update_donor_workup(patient:, user: nil, updated_at:)
        workup = donor_workup_for(patient)
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

      def set_up_patient_on_wait_list(patient)
        Renalware::Transplants::Registration.create!(
          patient: patient,
          statuses_attributes: {
            "0": {
              started_on: "03-11-2015",
              description_id: 1
            }
          }
        )
      end

      def set_transplant_registration_status(patient:, user:, status:, started_on:)
        registration = transplant_registration_for(patient)
        description = registration_status_description_named(status)
        registration.add_status!(
          description: description, started_on: started_on, whodunnit: user.id
        )
      end

      def create_transplant_registration(user: nil, patient:, status:, started_on:)
        description = registration_status_description_named(status)
        Renalware::Transplants::Registration.create(
          patient: patient,
          statuses_attributes: {
            "0": {
              started_on: started_on,
              description_id: description.id
            }
          }
        )
      end

      def update_transplant_registration_status(patient:, user:, status:, started_on:)
        registration = transplant_registration_for(patient)
        s = status_for_registration_and_name(registration, status)
        registration.update_status!(s, started_on: started_on, whodunnit: user.id)
      end

      def delete_transplant_registration_status(patient:, user:, status:)
        registration = transplant_registration_for(patient)
        s = status_for_registration_and_name(registration, status)
        registration.delete_status!(s)
      end

      # Asserts

      def assert_recipient_workup_exists(patient)
        expect(Renalware::Transplants::RecipientWorkup.for_patient(patient).any?).to be_truthy
      end

      def assert_donor_workup_exists(donor)
        expect(Renalware::Transplants::DonorWorkup.for_patient(donor).any?).to be_truthy
      end

      def assert_transplant_registration_exists(patient:, status_name:, started_on:)
        registration = Renalware::Transplants::Registration.for_patient(patient).first
        expect(registration).to_not be_nil
        status = registration.current_status
        expect(registration.current_status).to_not be_nil
        expect(registration.current_status.description.name).to eq(status_name)
        expect(registration.current_status.started_on).to eq(Date.parse(started_on))
      end

      def assert_workup_was_updated(patient)
        workup = Renalware::Transplants::RecipientWorkup.for_patient(patient).first
        expect(workup.updated_at).to_not eq(workup.created_at)
      end

      def assert_donor_workup_was_updated(patient)
        workup = Renalware::Transplants::DonorWorkup.for_patient(patient).first
        expect(workup.updated_at).to_not eq(workup.created_at)
      end

      def assert_update_transplant_registration(patient:, user: nil, updated_at:)
        registration = transplant_registration_for(patient)
        registration.update_attributes!(
          document: {
          },
          updated_at: updated_at
        )
        registration.reload
        expect(registration.updated_at).to_not eq(registration.created_at)
      end

      def assert_transplant_registration_was_refused
        expect(Renalware::Transplants::Registration.count).to eq(0)
      end

      def assert_transplant_registration_status_was_refused(patient)
        registration = transplant_registration_for(patient)
        expect(registration.statuses.count).to eq(@initial_statuses_count)
      end

      def assert_transplant_registration_status_history_matches(patient:, hashes:)
        statuses = transplant_registration_for(patient).reload.statuses.map do |s|
          { status: s.description.name,
            start_date: I18n.l(s.started_on),
            by: s.whodunnit_name.split.first,
            termination_date: (s.terminated_on ? I18n.l(s.terminated_on) : "")
          }.with_indifferent_access
        end
        expect(statuses.size).to eq(hashes.size)
        hashes.each do |row|
          expect(statuses).to include(row)
        end
      end

      def assert_transplant_registration_current_status_is(patient:, name:, started_on:)
        status = transplant_registration_for(patient).current_status
        expect(status.to_s).to eq(name)
        expect(I18n.l(status.started_on)).to eq(started_on)
      end

      def assert_transplant_registration_status_history_includes(patient:, hashes:)
        statuses = transplant_registration_for(patient).reload.statuses.map do |s|
          hash = { status: s.description.name,
            start_date: I18n.l(s.started_on),
            termination_date: (s.terminated_on ? I18n.l(s.terminated_on) : "")
          }
          if hashes.first[:by].present?
            hash[:by] = s.whodunnit_name.split.first
          end
          hash.with_indifferent_access
        end
        hashes.each do |row|
          expect(statuses).to include(row)
        end
      end
    end


    module Web
      include Domain

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

      def update_workup(patient:, user:, updated_at: nil)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Recipient Workup"
        click_on "Edit"

        fill_in "Cervical smear result", with: "193"

        within ".top" do
          click_on "Save"
        end
      end

      def update_donor_workup(patient:, user:, updated_at: nil)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Donor Workup"
        click_on "Edit"

        fill_in "Calculated Clearance", with: "193"

        within ".top" do
          click_on "Save"
        end
      end

      def update_transplant_registration(patient:, user:, updated_at: nil)
        login_as user
        visit patient_transplants_dashboard_path(patient)
        within_fieldset "Transplant Wait List Registration" do
          click_on "Edit"
        end

        select "Pancreas only", from: "Transplant Type"

        within ".top" do
          click_on "Save"
        end

        have_content("Pancreas only")
      end

      def set_transplant_registration_status(user:, patient:, status:, started_on:)
        login_as user
        visit patient_transplants_dashboard_path(patient)
        within_fieldset "Status History" do
          fill_in "transplants_registration_status[started_on]", with: started_on
          select status, from: "transplants_registration_status[description_id]"
          click_on "Add status"
        end
      end

      def update_transplant_registration_status(user:, patient:, status:, started_on:)
        login_as user
        visit patient_transplants_dashboard_path(patient)
        within_fieldset "Status History" do
          find(:xpath, "//tr[td[contains(.,'#{status}')]]/td/a", text: "Edit").click
        end

        fill_in "transplants_registration_status[started_on]", with: started_on
        click_on "Save"
      end

      def delete_transplant_registration_status(patient:, user:, status:)
        login_as user
        visit patient_transplants_dashboard_path(patient)
        within_fieldset "Status History" do
          find(:xpath, "//tr[td[contains(.,'#{status}')]]/td/a", text: "Delete").click
        end
      end
    end
  end
end
