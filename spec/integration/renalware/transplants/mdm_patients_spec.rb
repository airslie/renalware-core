require "rails_helper"

RSpec.describe "Transplants MDM Patients", type: :feature do
  include PatientsSpecHelper
  let(:user) { create(:user) }

  describe "GET index" do
    it "`all` filter displays all Transplant patients" do
      patient = create_recip_operation_patient(user)

      login_as_clinical
      visit transplants_mdm_patients_path

      expect(page).to have_content(patient.family_name.upcase)
    end

    it "`recent` filter displays patients with an operation within 3 months" do
      patient1 = create_recip_operation_patient(user, with_recent_operation: false)
      patient2 = create_recip_operation_patient(user, with_recent_operation: true)
      login_as_clinical

      visit transplants_mdm_patients_path
      click_on I18n.t("renalware.transplants.mdm_patients.filters.filter.recent")

      expect(page).to have_content(patient2.local_patient_id)
      expect(page).to have_no_content(patient1.local_patient_id)
    end

    it "`on worryboard` filter displays transplant patients on the worryboard" do
      patient1 = create_recip_operation_patient(user)
      patient2 = create_recip_operation_patient(user)
      patient2.build_worry(by: user).save!

      login_as_clinical

      visit transplants_mdm_patients_path
      click_on I18n.t("renalware.transplants.mdm_patients.filters.filter.on_worryboard")

      expect(page).to have_content(patient2.local_patient_id)
      expect(page).to have_no_content(patient1.local_patient_id)
    end

    def create_donor_patient(user)
      create(:transplant_patient).tap do |patient|
        set_modality(patient: patient,
                     modality_description: create(:transplant_donor_modality_description),
                     by: user)
      end
    end

    def create_recip_operation_patient(user, with_recent_operation: false)
      create(:transplant_patient).tap do |patient|
        set_modality(patient: patient,
                     modality_description: create(:transplant_modality_description),
                     by: user)

        if with_recent_operation
          create(:transplant_recipient_operation,
                 patient: patient,
                 performed_on: 2.months.ago)
        end
      end
    end
  end
end
