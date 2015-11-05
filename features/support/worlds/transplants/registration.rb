module World
  module Transplants::Registration
    module Domain
      # Helpers

      def transplant_registration_for(patient)
        Renalware::Transplants::Registration.for_patient(patient).first_or_initialize
      end

      # Set-ups

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

      # Commands

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

      # Asserts

      def assert_transplant_registration_exists(patient:, status_name:, started_on:)
        registration = Renalware::Transplants::Registration.for_patient(patient).first
        expect(registration).to_not be_nil
        status = registration.current_status
        expect(registration.current_status).to_not be_nil
        expect(registration.current_status.description.name).to eq(status_name)
        expect(registration.current_status.started_on).to eq(Date.parse(started_on))
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
    end


    module Web
      include Domain

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
    end
  end
end