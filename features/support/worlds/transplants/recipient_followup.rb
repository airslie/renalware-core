module World
  module Transplants::RecipientFollowup
    module Domain
      # @section helpers
      #
      def recipient_followup_for(operation)
        Renalware::Transplants::RecipientFollowup.for_operation(operation).first_or_initialize
      end

      def valid_recipient_followup_attributes
        {
          stent_removed_on: Time.zone.today,
          transplant_failed: false
        }
      end

      # @section set-ups
      #
      def set_up_recipient_followup(operation)
        Renalware::Transplants::RecipientFollowup.create!(
          valid_recipient_followup_attributes.merge(
            operation: operation
          )
        )
      end

      # @section commands
      #
      def create_recipient_followup(operation:, user:)
        Renalware::Transplants::RecipientFollowup.create(
          valid_recipient_followup_attributes.merge(
            operation_id: operation.id
          )
        )
      end

      def update_recipient_followup(operation:, user: nil)
        travel_to 1.hour.from_now

        operation = recipient_followup_for(operation)
        operation.update_attributes!(
          document: {
          },
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_recipient_followup_to_exist(operation)
        expect(Renalware::Transplants::RecipientFollowup.for_operation(operation)).to be_present
      end

      def expect_update_recipient_followup_to_succeed(operation:, user:)
        update_recipient_followup(operation: operation, user: user)
        followup = recipient_followup_for(operation)
        expect(followup).to be_modified
      end
    end


    module Web
      include Domain

      def create_recipient_followup(operation:, user:)
        login_as user
        visit patient_transplants_recipient_dashboard_path(operation.patient)
        within_fieldset "Recipient Operations" do
          click_on "Enter details"
        end

        fill_in "Stent Removal Date", with: valid_recipient_followup_attributes[:stent_removed_on]

        within ".top" do
          click_on "Save"
        end
      end

      def update_recipient_followup(operation:, user: nil)
        login_as user
        visit patient_transplants_recipient_dashboard_path(operation.patient)
        within_fieldset "Recipient Operations" do
          click_on "Update"
        end

        within ".transplants_recipient_followup_transplant_failed" do
          choose "No"
        end

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
