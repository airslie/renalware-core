# rubocop:disable Metrics/MethodLength
require "rails_helper"

RSpec.describe "Viewing patients whose HD preferences do not match their profile", type: :feature do
  let(:hospital) { create(:hospital_centre) }
  let(:current_unit) do
    create(:hospital_unit, name: "X", hospital_centre: hospital, is_hd_site: true)
  end
  let(:preferred_unit) do
    create(:hospital_unit, name: "Y", hospital_centre: hospital, is_hd_site: true)
  end
  let(:user) { Renalware::User.first }

  def patient_preferring_another_schedule(name: "Jones")
    create(:hd_patient, family_name: name).tap do |patient|
      create(:hd_profile,
             patient: patient,
             schedule: :mon_wed_fri_am, # !
             hospital_unit: current_unit)
      create(:hd_preference_set,
             patient: patient,
             schedule: :mon_wed_fri_pm, # !
             hospital_unit: current_unit,
             created_by_id: user.id,
             updated_by_id: user.id)
    end
  end

  def patient_preferring_another_hospital_unit(name: "Smith")
    create(:hd_patient, family_name: name).tap do |patient|
      create(:hd_profile,
             patient: patient,
             schedule: :mon_wed_fri_am,
             hospital_unit: current_unit) # !
      create(:hd_preference_set,
             patient: patient,
             schedule: :mon_wed_fri_am,
             hospital_unit: preferred_unit, # !
             created_by: user,
             updated_by: user)
    end
  end

  def patient_whose_preferences_are_met(name: "Metpost")
    create(:hd_patient, family_name: name).tap do |patient|
      create(:hd_profile, patient: patient, hospital_unit: current_unit, schedule: :mon_wed_fri_am)
      create(:hd_preference_set,
             patient: patient,
             hospital_unit: current_unit,
             schedule: :mon_wed_fri_am,
             created_by: user,
             updated_by: user)
    end
  end

  describe "GET index" do
    it "responds with a list of patients with unmet preferences" do
      login_as_clinician
      patient_met = patient_whose_preferences_are_met
      patient_schedule = patient_preferring_another_schedule
      patient_unit = patient_preferring_another_hospital_unit

      visit hd_unmet_preferences_path

      expect(page).to have_content(patient_schedule.family_name.upcase)
      expect(page).to have_content(patient_unit.family_name.upcase)
      expect(page).to have_no_content(patient_met.family_name.upcase)
    end

    context "when filtering" do
      it "responds with a list of patients matching filters" do
        login_as_clinician
        patient_met = patient_whose_preferences_are_met
        patient_schedule = patient_preferring_another_schedule
        patient_unit = patient_preferring_another_hospital_unit

        visit hd_unmet_preferences_path

        # Select the hospital unit Y which patient_unit prefers
        select "Y", from: "q_hd_preference_set_hospital_unit_id_eq"
        click_on "Filter"

        expect(page).to have_content(patient_unit.family_name.upcase)
        expect(page).to have_no_content(patient_met.family_name.upcase)
        expect(page).to have_no_content(patient_schedule.family_name.upcase)
      end
    end
  end
end
