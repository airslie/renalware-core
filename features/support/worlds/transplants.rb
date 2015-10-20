module World
  module Transplants
    module Domain
      def create_recipient_workup(_user, patient)
        Renalware::Transplants::RecipientWorkup.create!(
          patient: patient
        )
      end

      def create_donor_workup(_user, patient)
        Renalware::Transplants::DonorWorkup.create!(
          patient: patient,
          document: {
            relationship: {
              donor_recip_relationship: "son_or_daughter"
            }
          }
        )
      end

      def update_workup(workup, _user, updated_at)
        workup.update_attributes!(
          document: {
            historicals: {
              tb: "no"
            }
          },
          updated_at: updated_at
        )
      end

      def update_donor_workup(workup, _user, updated_at)
        workup.update_attributes!(
          document: {
            relationship: {
              donor_recip_relationship: "son_or_daughter"
            },
            comorbidities: {
              angina: {
                status: "no"
              }
            }
          },
          updated_at: updated_at
        )
      end

      def recipient_workup_exists(patient)
        Renalware::Transplants::RecipientWorkup.for_patient(patient).any?
      end

      def donor_workup_exists(donor)
        Renalware::Transplants::DonorWorkup.for_patient(donor).any?
      end

      def workup_was_updated(patient)
        workup = Renalware::Transplants::RecipientWorkup.for_patient(patient).first
        workup.updated_at != workup.created_at
      end

      def donor_workup_was_updated(patient)
        workup = Renalware::Transplants::DonorWorkup.for_patient(patient).first
        workup.updated_at != workup.created_at
      end
    end

    module Web
      def create_recipient_workup(user, patient)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Recipient Workup"

        fill_in "Karnofsky Score", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def create_donor_workup(user, patient)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Donor Workup"

        select "Mother or father", from: "Relationship to Recipient"
        fill_in "Oral GTT", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def update_workup(workup, user, _updated_at)
        login_as user
        visit patient_clinical_summary_path(workup.patient)
        click_on "Transplant Recipient Workup"
        click_on "Edit"

        fill_in "Cervical smear result", with: "193"

        within ".top" do
          click_on "Save"
        end
      end

      def update_donor_workup(workup, user, _updated_at)
        login_as user
        visit patient_clinical_summary_path(workup.patient)
        click_on "Transplant Donor Workup"
        click_on "Edit"

        fill_in "Calculated Clearance", with: "193"

        within ".top" do
          click_on "Save"
        end
      end

      def recipient_workup_exists(_patient)
        expect(page).to have_content("Heart failure")
      end

      def donor_workup_exists(_donor)
        expect(page).to have_content("Heart failure")
      end

      def workup_was_updated(_patient)
        expect(page).to have_content("Heart failure")
      end

      def donor_workup_was_updated(_patient)
        expect(page).to have_content("193")
      end
    end
  end
end
