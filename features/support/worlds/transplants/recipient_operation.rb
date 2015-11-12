module World
  module Transplants::RecipientOperation
    module Domain
      # @section helpers
      #
      def recipient_operation_for(patient)
        Renalware::Transplants::RecipientOperation.for_patient(patient).first_or_initialize
      end

      # @section set-ups
      #
      def set_up_recipient_operation(patient)
        Renalware::Transplants::RecipientOperation.create!(
          patient: patient,
          performed_on: Time.zone.today,
          theatre_case_start_time: "11:00",
          donor_kidney_removed_from_ice_at: Time.zone.now,
          operation_type: "kidney",
          transplant_site: "somewhere",
          kidney_perfused_with_blood_at: Time.zone.now,
          cold_ischaemic_time: "11:30"
        )
      end


      # @section commands
      #
      def create_recipient_operation(patient:, user:, performed_on:)
        Renalware::Transplants::RecipientOperation.create(
          patient: patient,
          performed_on: performed_on,
          theatre_case_start_time: "11:00",
          donor_kidney_removed_from_ice_at: Time.zone.now,
          operation_type: "kidney",
          transplant_site: "somewhere",
          kidney_perfused_with_blood_at: Time.zone.now,
          cold_ischaemic_time: "11:30"
        )
      end

      def update_recipient_operation(patient:, user: nil)
        travel_to 1.hour.from_now

        operation = recipient_operation_for(patient)
        operation.update_attributes!(
          document: {
          },
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def assert_recipient_operation_exists(patient)
        expect(Renalware::Transplants::RecipientOperation.for_patient(patient).any?).to be_truthy
      end

      def assert_update_recipient_operation(patient:, user:)
        update_recipient_operation(patient: patient, user: user)
        operation = recipient_operation_for(patient)
        expect(operation.reload.updated_at).to_not eq(operation.created_at)
      end

      def assert_recipient_operation_was_refused
        expect(Renalware::Transplants::RecipientOperation.count).to eq(0)
      end
    end


    module Web
      include Domain

      def create_recipient_operation(user:, patient:, performed_on:)
        login_as user
        visit patient_transplants_dashboard_path(patient)
        click_on "Enter operation details"

        select "Kidney only", from: "Operation Type"
        fill_in "Operation Date", with: performed_on
        fill_in "Theatre Case Start Time", with: "11:00"
        fill_in "Donor Kidney Removed From Ice At", with: "11:00"
        fill_in "Transplant Site", with: "somewhere"
        fill_in "Kidney Perfused With Blood At", with: "11:00"
        fill_in "Cold Ischaemic Time", with: "11:00"

        within ".top" do
          click_on "Save"
        end
      end

      def update_recipient_operation(patient:, user:)
        login_as user
        visit patient_transplants_dashboard_path(patient)
        within_fieldset "Operations" do
          click_on "Edit"
        end

        select "Pancreas only", from: "Operation Type"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
