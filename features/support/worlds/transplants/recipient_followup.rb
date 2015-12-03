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

      def create_recipient_operation(user:, operation:, performed_on:)
        login_as user
        visit operation_transplants_recipient_dashboard_path(operation)
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

      def update_recipient_operation(operation:, user:)
        login_as user
        visit operation_transplants_recipient_dashboard_path(operation)
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
