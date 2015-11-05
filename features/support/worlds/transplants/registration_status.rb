module World
  module Transplants::RegistrationStatus
    module Domain
      # Helpers

      def registration_status_description_named(name)
        Renalware::Transplants::RegistrationStatusDescription.find_by(
          name: name
        ) || raise("Cannot find status [#{name}] in seeding data")
      end

      def status_for_registration_and_name(registration, name)
        description = registration_status_description_named(name)
        registration.statuses.find_by description: description
      end

      # Set-ups

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

      def set_transplant_registration_status(patient:, user:, status:, started_on:)
        registration = transplant_registration_for(patient)
        description = registration_status_description_named(status)
        registration.add_status!(
          description: description, started_on: started_on, whodunnit: user.id
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

      def assert_transplant_registration_status_was_refused(patient)
        registration = transplant_registration_for(patient)
        expect(registration.statuses.count).to eq(@initial_statuses_count)
      end

      def assert_transplant_registration_status_history_matches(patient:, hashes:)
        statuses = transplant_registration_for(patient).reload.statuses.map do |s|
          { status: s.description.name,
            start_date: I18n.l(s.started_on),
            by: s.updated_by.to_s.split.first,
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
            hash[:by] = s.updated_by.first_name
          end
          hash.with_indifferent_access
        end
        hashes.each do |row|
          expect(statuses).to include(row)
        end
      end

      def assert_transplant_registration_current_status_by(patient:, user:)
        registration = transplant_registration_for(patient)
        expect(registration.current_status.whodunnit).to eq(user.id.to_s)
      end
    end


    module Web
      include Domain

      def set_transplant_registration_status(user:, patient:, status:, started_on:)
        login_as user
        visit patient_transplants_dashboard_path(patient)
        within_fieldset "Status History" do
          fill_in "transplants_registration_status[started_on]", with: started_on
          select status, from: "transplants_registration_status[description_id]"
          click_on "Add status"
        end
        wait_for_ajax
      end

      def update_transplant_registration_status(user:, patient:, status:, started_on:)
        login_as user
        visit patient_transplants_dashboard_path(patient)
        within_fieldset "Status History" do
          find_link_in_row_with(text: status, link_label: "Edit").click
        end

        fill_in "transplants_registration_status[started_on]", with: started_on
        click_on "Save"
      end

      def delete_transplant_registration_status(patient:, user:, status:)
        login_as user
        visit patient_transplants_dashboard_path(patient)
        within_fieldset "Status History" do
          find_link_in_row_with(text: status, link_label: "Delete").click
        end
      end
    end
  end
end