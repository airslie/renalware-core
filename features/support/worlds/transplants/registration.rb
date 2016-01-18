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

      def set_up_patient_on_wait_list(patient, status="Active")
        Renalware::Transplants::Registration.create!(
          patient: patient,
          statuses_attributes: {
            "0": {
              started_on: "03-11-2015",
              description_id: registration_status_description_named(status).id,
              by: Renalware::User.first
            }
          }
        )
      end

      def set_up_wait_list_registrations(table)
        table.hashes.each do |row|
          patient_name = row[:patient]
          status = row[:status]
          patient = Renalware::Patient.create!(
            family_name: patient_name.split(",").first.strip,
            given_name: patient_name.split(",").last.strip,
            nhs_number: rand(10000000).to_s.rjust(10, "1234567890"),
            local_patient_id: rand(10000).to_s.rjust(6, "Z99999"),
            sex: "M",
            born_on: Time.zone.today
          )
          set_up_patient_on_wait_list(patient, status)
        end
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

      def view_wait_list_registrations(filter:, user: nil)
        @query = Renalware::Transplants::Registrations::WaitListQuery.new(
          quick_filter: filter
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

      def expect_wait_list_registrations_to_be(hashes)
        registrations = @query.call
        expect(registrations.size).to eq(hashes.size)

        entries = registrations.map do |r|
          hash = {
            patient: r.patient.to_s,
            status: r.current_status.description.name
          }
          hash.with_indifferent_access
        end
        hashes.each do |row|
          expect(entries).to include(row)
        end
      end
    end


    module Web
      include Domain

      def create_transplant_registration(user:, patient:, status:, started_on:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)
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
        visit patient_transplants_recipient_dashboard_path(patient)
        within_fieldset "Transplant Wait List Registration" do
          click_on "Edit"
        end

        select "Pancreas only", from: "Transplant Type"

        within ".top" do
          click_on "Save"
        end

        have_content("Pancreas only")
      end

      def view_wait_list_registrations(filter:, user:)
        login_as user
        visit transplants_wait_list_path(filter: filter)
      end

      def expect_wait_list_registrations_to_be(hashes)
        hashes.each do |row|
          expect(page.body).to have_content(row[:patient])
        end
      end
    end
  end
end
