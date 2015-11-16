module World
  module Transplants::Donation
    module Domain
      # @section helpers
      #
      def donation_for(patient)
        Renalware::Transplants::Donation.for_patient(patient).first_or_initialize
      end

      def valid_donation_attributes
        {
        }
      end

      # @section set-ups
      #
      def set_up_donation(patient)
        Renalware::Transplants::Donation.create!(
          valid_donation_attributes.merge(
            patient: patient,
          )
        )
      end

      # @section commands
      #
      def create_donation(patient:, user:)
        Renalware::Transplants::Donation.create(
          valid_donation_attributes.merge(
            patient: patient
          )
        )
      end

      def update_donation(patient:, user: nil)
        travel_to 1.hour.from_now

        operation = donation_for(patient)
        operation.update_attributes!(
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_donation_to_exist(patient)
        expect(Renalware::Transplants::Donation.for_patient(patient)).to be_present
      end

      def expect_update_donation_to_succeed(patient:, user:)
        update_donation(patient: patient, user: user)
        operation = donation_for(patient)
        expect(operation).to be_modified
      end

      def expect_donation_to_be_refused
        expect(Renalware::Transplants::Donation.count).to eq(0)
      end
    end


    module Web
      include Domain

      def create_donation(user:, patient:)
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

      def update_donation(patient:, user:)
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
