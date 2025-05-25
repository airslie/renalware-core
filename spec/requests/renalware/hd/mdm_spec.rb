describe "Patient HD MDM" do
  let(:patient) { create(:hd_patient, family_name: "Rabbit", local_patient_id: "12345") }

  describe "GET show" do
    it "responds successfully" do
      create(:pathology_observation_description, code: "HGB")
      create(:pathology_code_group, :default)
      get patient_hd_mdm_path(patient)

      expect(response).to be_successful
    end
  end
end
