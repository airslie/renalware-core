module World
  module Transplants
    module Domain
      def create_recipient_workup(_user, patient)
        Renalware::Transplants::RecipientWorkup.create!(
          patient: patient,
          performed_at: 1.day.ago
        )
      end

      def update_workup(workup, _user, updated_at)
        workup.update_attributes(
          document_attributes: {
            hx_tb: true
          },
          updated_at: updated_at
        )
      end

      def recipient_workup_exists(patient)
        Renalware::Transplants::RecipientWorkup.for_patient(patient).present?
      end

      def workup_was_updated(patient)
        workup = Renalware::Transplants::RecipientWorkup.for_patient(patient)
        workup.updated_at != workup.created_at
      end
    end

    module Web
      def create_recipient_workup(user, patient)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Recipient Workup"

        fill_in "Karnofsky Score", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def update_workup(workup, user, _updated_at)
        login_as user
        visit patient_clinical_summary_path(workup.patient)
        click_on "Recipient Workup"
        click_on "Edit"

        fill_in "Cervical smear result", with: "193"

        within ".top" do
          click_on "Save"
        end
      end

      def recipient_workup_exists(_patient)
        !first(".workup").nil?
      end

      def workup_was_updated(_patient)
        !first(".workup").nil?
      end
    end
  end
end
