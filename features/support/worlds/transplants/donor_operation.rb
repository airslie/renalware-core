module World
  module Transplants::DonorOperation
    module Domain
      # @section helpers
      #
      def donor_operation_for(patient)
        Renalware::Transplants::DonorOperation.for_patient(patient).first_or_initialize
      end

      def valid_donor_operation_attributes
        {
          performed_on: fake_date
        }
      end

      # @section set-ups
      #
      def set_up_donor_operation(patient)
        Renalware::Transplants::DonorOperation.create!(
          valid_donor_operation_attributes.merge(
            patient: patient,
          )
        )
      end

      # @section commands
      #
      def create_donor_operation(patient:, user:, performed_on:)
        Renalware::Transplants::DonorOperation.create(
          valid_donor_operation_attributes.merge(
            patient: patient,
            performed_on: performed_on
          )
        )
      end

      def update_donor_operation(patient:, user: nil)
        travel_to 1.hour.from_now

        operation = donor_operation_for(patient)
        operation.update_attributes!(
          document: {
          },
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_donor_operation_to_exist(patient)
        expect(Renalware::Transplants::DonorOperation.for_patient(patient)).to be_present
      end

      def expect_update_donor_operation_to_succeed(patient:, user:)
        update_donor_operation(patient: patient, user: user)
        operation = donor_operation_for(patient)
        expect(operation).to be_modified
      end

      def expect_donor_operation_to_be_refused
        expect(Renalware::Transplants::DonorOperation.count).to eq(0)
      end
    end


    module Web
      include Domain

      def create_donor_operation(user:, patient:, performed_on:)
        login_as user
        visit patient_transplants_dashboard_path(patient)
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

      def update_donor_operation(patient:, user:)
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
