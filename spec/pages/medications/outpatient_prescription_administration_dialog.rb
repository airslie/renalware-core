require_relative "../page_object"

module Pages
  module Medications
    class OutpatientPrescriptionAdministrationDialog < PageObject
      include SlimSelectHelper

      pattr_initialize [:prescription!]
      MODAL_CONTAINER_ID = "#outpatient-prescription-administration-modal".freeze

      def container_css
        MODAL_CONTAINER_ID
      end

      def open_by_clicking_on_drug_name
        visit patient_prescriptions_path(prescription.patient)
        click_on "Record Outpatient Drugs"
        click_on prescription.drug_name
      end

      def visible?
        page.has_css?("#{MODAL_CONTAINER_ID} .modal")
      end

      def displaying_prescription?
        within(MODAL_CONTAINER_ID) do
          page.has_content?(prescription.drug_name)
        end
      end

      def not_administered_reason=(reason)
        select reason, from: "medications_outpatient_prescription_administration_reason_id"
      end

      def notes=(value)
        within(MODAL_CONTAINER_ID) do
          fill_in "Notes", with: value
        end
      end

      def recorded_on=(value)
        fill_in "Recorded on", with: value
      end

      def administered=(value)
        return if value.nil?

        selection = value ? "Yes" : "No"
        within(".medications_outpatient_prescription_administration_administered") do
          choose selection
        end
      end

      def administered_by=(user)
        slim_select(
          user.given_name,
          from: "medications_outpatient_prescription_administration_administered_by_id"
        )
      end

      def administered_by_password=(password)
        fill_password(:administrator, password)
      end

      def witnessed_by=(user)
        return if user.blank?

        slim_select(
          user.given_name,
          from: "medications_outpatient_prescription_administration_witnessed_by_id"
        )
      end

      def witnessed_by_password=(password)
        fill_password(:witness, password)
      end

      def save_button_captions
        within(MODAL_CONTAINER_ID) do
          all("input[type='submit']").filter_map { |button| button.value if button.visible? }
        end
      end

      def save
        within(MODAL_CONTAINER_ID) do
          click_on "Sign-off"
        end
        wait_for_submit
      end

      def save_and_witness_later
        within(MODAL_CONTAINER_ID) do
          click_on "Save and Witness Later"
        end
        wait_for_submit
      end

      private

      def fill_password(user_type, password)
        within ".user-and-password--#{user_type}" do
          find("input[type='password']").set(password)
        end
      end

      def wait_for_submit
        page.has_no_css?("#{MODAL_CONTAINER_ID} .modal")
      end
    end
  end
end
