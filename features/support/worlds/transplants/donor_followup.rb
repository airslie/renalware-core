module World
  module Transplants::DonorFollowup
    module Domain
      # @section helpers
      #
      def donor_followup_for(operation)
        Renalware::Transplants::DonorFollowup.for_operation(operation).first_or_initialize
      end

      def valid_donor_followup_attributes
        {
          last_seen_on: Time.zone.today
        }
      end

      # @section set-ups
      #
      def set_up_donor_followup(operation)
        Renalware::Transplants::DonorFollowup.create!(
          valid_donor_followup_attributes.merge(
            operation: operation
          )
        )
      end

      # @section commands
      #
      def create_donor_followup(operation:, user:)
        Renalware::Transplants::DonorFollowup.create(
          valid_donor_followup_attributes.merge(
            operation_id: operation.id
          )
        )
      end

      def update_donor_followup(operation:, user: nil)
        travel_to 1.hour.from_now

        operation = donor_followup_for(operation)
        operation.update_attributes!(
          document: {
          },
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_donor_followup_to_exist(operation)
        expect(Renalware::Transplants::DonorFollowup.for_operation(operation)).to be_present
      end

      def expect_update_donor_followup_to_succeed(operation:, user:)
        update_donor_followup(operation: operation, user: user)
        followup = donor_followup_for(operation)
        expect(followup).to be_modified
      end
    end


    module Web
      include Domain

      def create_donor_followup(operation:, user:)
        login_as user
        visit patient_transplants_donor_dashboard_path(operation.patient)
        within_fieldset "Donor Operations" do
          click_on "Enter details"
        end

        fill_in "Stent Removal Date", with: valid_donor_followup_attributes[:stent_removed_on]

        within ".top" do
          click_on "Save"
        end
      end

      def update_donor_followup(operation:, user: nil)
        login_as user
        visit patient_transplants_donor_dashboard_path(operation.patient)
        within_fieldset "Donor Operations" do
          click_on "Update"
        end

        within ".transplants_donor_followup_transplant_failed" do
          choose "No"
        end

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
