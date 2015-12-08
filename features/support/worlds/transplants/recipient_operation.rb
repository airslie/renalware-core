module World
  module Transplants::RecipientOperation
    module Domain
      # @section helpers
      #
      def recipient_operation_for(patient)
        Renalware::Transplants::RecipientOperation.for_patient(patient).first_or_initialize
      end

      def valid_recipient_operation_attributes
        {
          performed_on: fake_date,
          theatre_case_start_time: fake_time,
          donor_kidney_removed_from_ice_at: fake_date_time,
          operation_type: "kidney",
          transplant_site: "somewhere",
          kidney_perfused_with_blood_at: fake_date_time,
          cold_ischaemic_time: fake_time,
          warm_ischaemic_time: fake_time
        }
      end

      # @section set-ups
      #
      def set_up_recipient_operation(patient)
        Renalware::Transplants::RecipientOperation.create!(
          valid_recipient_operation_attributes.merge(
            patient: patient,
          )
        )
      end

      # @section commands
      #
      def create_recipient_operation(patient:, user:, performed_on:)
        Renalware::Transplants::RecipientOperation.create(
          valid_recipient_operation_attributes.merge(
            patient: patient,
            performed_on: performed_on
          )
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
      def expect_recipient_operation_to_exist(patient)
        expect(Renalware::Transplants::RecipientOperation.for_patient(patient)).to be_present
      end

      def expect_update_recipient_operation_to_succeed(patient:, user:)
        update_recipient_operation(patient: patient, user: user)
        operation = recipient_operation_for(patient)
        expect(operation).to be_modified
      end

      def expect_recipient_operation_to_be_refused
        expect(Renalware::Transplants::RecipientOperation.count).to eq(0)
      end
    end


    module Web
      include Domain

      def create_recipient_operation(user:, patient:, performed_on:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)
        click_on "Enter operation details"

        select "Kidney only", from: "Operation Type"
        fill_in "Operation Date", with: performed_on
        fill_in "Theatre Case Start Time", with: fake_time
        fill_in "Donor Kidney Removed From Ice At", with: fake_time
        fill_in "Transplant Site", with: "somewhere"
        fill_in "Kidney Perfused With Blood At", with: fake_time
        fill_in "Cold Ischaemic Time", with: fake_time

        within ".top" do
          click_on "Save"
        end
      end

      def update_recipient_operation(patient:, user:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(patient)
        within_fieldset "Recipient Operations" do
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
