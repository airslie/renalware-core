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
          status: :pending_workup
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
      def create_donation(patient:, user:, status: nil)
        Renalware::Transplants::Donation.create(
          valid_donation_attributes.merge(
            patient: patient,
            status: status
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

      def create_donation(user:, patient:, status: nil)
        login_as user
        visit patient_transplants_donor_dashboard_path(patient)
        click_on "Enter donation"

        begin
          find("option[value='#{status}']").select_option
        rescue Capybara::ElementNotFound
        end

        within ".top" do
          click_on "Save"
        end
      end

      def update_donation(patient:, user:)
        login_as user
        visit patient_transplants_donor_dashboard_path(patient)
        within_fieldset "Donation" do
          click_on "Edit"
        end

        select "Working Up", from: "Status"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
