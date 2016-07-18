module World
  module Transplants::DonorOperation
    module Domain
      # @section helpers
      #
      def donor_operation_for(patient)
        patient = transplant_patient(patient)

        Renalware::Transplants::DonorOperation.for_patient(patient).first_or_initialize
      end

      def valid_donor_operation_attributes
        {
          performed_on: fake_date
        }
      end

      # @section seeding
      #
      def seed_donor_operation(patient)
        patient = transplant_patient(patient)

        Renalware::Transplants::DonorOperation.create!(
          valid_donor_operation_attributes.merge(
            patient: patient,
          )
        )
      end

      # @section commands
      #
      def create_donor_operation(patient:, user:, performed_on:)
        patient = transplant_patient(patient)

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
        visit patient_transplants_donor_dashboard_path(patient)
        click_on "Enter operation details"

        fill_in "Operation Date", with: performed_on

        within ".top" do
          click_on "Save"
        end
      end

      def update_donor_operation(patient:, user:)
        login_as user
        visit patient_transplants_donor_dashboard_path(patient)
        within_fieldset "Donor Transplant Operations" do
          click_on "Edit"
        end

        select "Both", from: "Kidney Side"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
