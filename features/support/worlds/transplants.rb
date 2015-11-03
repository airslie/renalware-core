module World
  module Transplants

    def registration_status_description_named(name)
      Renalware::Transplants::RegistrationStatusDescription.find_or_create_by(
        name: name
      )
    end

    module Domain
      def create_recipient_workup(user: nil, patient:)
        Renalware::Transplants::RecipientWorkup.create!(
          patient: patient
        )
      end

      def create_donor_workup(user: nil, patient:)
        Renalware::Transplants::DonorWorkup.create!(
          patient: patient,
          document: {
            relationship: {
              donor_recip_relationship: "son_or_daughter"
            }
          }
        )
      end

      def update_workup(workup:, user: nil, updated_at:)
        workup.update_attributes!(
          document: {
            historicals: {
              tb: "no"
            }
          },
          updated_at: updated_at
        )
      end

      def update_donor_workup(workup:, user: nil, updated_at:)
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

      def transplant_registration_exists(patient:, status_name:, started_on:)
        registration = Renalware::Transplants::Registration.for_patient(patient).first
        expect(registration).to_not be_nil
        status = registration.current_status
        expect(registration.current_status).to_not be_nil
        expect(registration.current_status.description.name).to eq(status_name)
        expect(registration.current_status.started_on).to eq(Date.parse(started_on))
      end

      def workup_was_updated(patient)
        workup = Renalware::Transplants::RecipientWorkup.for_patient(patient).first
        workup.updated_at != workup.created_at
      end

      def donor_workup_was_updated(patient)
        workup = Renalware::Transplants::DonorWorkup.for_patient(patient).first
        workup.updated_at != workup.created_at
      end

      def create_transplant_registration(user: nil, patient:, status:, started_on:)
        registration = Renalware::Transplants::Registration.create!(
          patient: patient
        )
        description = registration_status_description_named(status)
        registration.add_status!(description_id: description.id, started_on: started_on )
      end

      def update_transplant_registration(registration:, user: nil, updated_at:)
        registration.update_attributes!(
          document: {
          },
          updated_at: updated_at
        )
        registration.reload
        registration.updated_at != registration.created_at
      end
    end

    module Web
      def create_recipient_workup(user:, patient:)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Recipient Workup"

        fill_in "Karnofsky Score", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def create_donor_workup(user:, patient:)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Donor Workup"

        select "Mother or father", from: "Relationship to Recipient"
        fill_in "Oral GTT", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def create_transplant_registration(user:, patient:, status:, started_on:)
        login_as user
        visit patient_transplants_dashboard_path(patient)
        click_on "Enter registration details"

        select "Kidney only", from: "Transplant Type"
        within_fieldset "Status" do
          fill_in "Started on", with: started_on
          select "Active", from: "Description"
        end

        within ".top" do
          click_on "Save"
        end
      end

      def update_workup(workup:, user:, updated_at: nil)
        login_as user
        visit patient_clinical_summary_path(workup.patient)
        click_on "Transplant Recipient Workup"
        click_on "Edit"

        fill_in "Cervical smear result", with: "193"

        within ".top" do
          click_on "Save"
        end
      end

      def update_donor_workup(workup:, user:, updated_at: nil)
        login_as user
        visit patient_clinical_summary_path(workup.patient)
        click_on "Transplant Donor Workup"
        click_on "Edit"

        fill_in "Calculated Clearance", with: "193"

        within ".top" do
          click_on "Save"
        end
      end

      def update_transplant_registration(registration:, user:, updated_at: nil)
        login_as user
        visit patient_transplants_dashboard_path(registration.patient)
        within_fieldset "Transplant Wait List Registration" do
          click_on "Edit"
        end

        select "Pancreas only", from: "Transplant Type"

        within ".top" do
          click_on "Save"
        end

        have_content("Pancreas only")
      end

      def recipient_workup_exists(patient)
        expect(page).to have_content("Heart failure")
      end

      def donor_workup_exists(donor)
        expect(page).to have_content("Heart failure")
      end

      def transplant_registration_exists(patient:, status_name:, started_on:)
        expect(page).to have_content("Kidney only")
        expect(page).to have_content(status_name)
        expect(page).to have_content(started_on)
      end

      def workup_was_updated(patient)
        expect(page).to have_content("Heart failure")
      end

      def donor_workup_was_updated(patient)
        expect(page).to have_content("193")
      end
    end
  end
end
