module World
  module Transplants::Registration
    module Domain
      # @section helpers
      #
      def transplant_registration_for(patient)
        Renalware::Transplants::Registration.for_patient(patient).first_or_initialize
      end

      # @section set-ups
      #
      def set_up_patient_on_wait_list(patient)
        Renalware::Transplants::Registration.create!(
          patient: patient,
          statuses_attributes: {
            "0": {
              started_on: "03-11-2015",
              description_id: registration_status_description_named("Active").id,
              by: Renalware::User.first
            }
          }
        )
      end

      def set_up_patient_on_wait_list(patient)
        Renalware::Transplants::Registration.create!(
          patient: patient,
          statuses_attributes: {
            "0": {
              started_on: "03-11-2015",
              description_id: registration_status_description_named("Active").id,
              by: Renalware::User.first
            }
          }
        )
      end

      # @section commands
      #
      def create_transplant_registration(user:, patient:, status:, started_on:)
        description = registration_status_description_named(status)
        Renalware::Transplants::Registration.create(
          patient: patient,
          statuses_attributes: {
            "0": {
              started_on: started_on,
              description_id: description.id,
              by: user
            }
          }
        )
      end

      # @section expectations
      #
      def expect_transplant_registration_to_exist(patient:, status_name:, started_on:)
        registration = Renalware::Transplants::Registration.for_patient(patient).first
        expect(registration).to_not be_nil
        status = registration.current_status
        expect(registration.current_status).to_not be_nil
        expect(registration.current_status.description.name).to eq(status_name)
        expect(registration.current_status.started_on).to eq(Date.parse(started_on))
      end

      def expect_transplant_registration_to_be_modified(patient:)
        travel_to 1.hour.from_now

        registration = transplant_registration_for(patient)
        registration.update_attributes!(
          document: {
          },
          updated_at: Time.zone.now
        )
        expect(registration).to be_modified
      end

      def expect_transplant_registration_to_be_refused
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

      def update_transplant_registration(patient:, user:)
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
