describe "Managing PD PET Results" do
  let(:patient) { create(:pd_patient, by: user) }
  let(:user) { create(:user) }

  describe "GET index" do
    it "responds with all results for the remote summary link" do
      create(:pd_pet_result, patient:)

      get(
        patient_pd_pet_results_path(patient, format: :js),
        headers: {
          "ACCEPT" => "text/javascript",
          "X-Requested-With" => "XMLHttpRequest"
        }
      )

      expect(response).to be_successful
      expect(response.media_type).to eq("text/javascript")
      expect(response.body).to include('petResultsTitle.textContent = "PET Results (1)"')
    end
  end

  describe "GET new" do
    it "responds with a form" do
      get new_patient_pd_pet_result_path(patient)

      expect(response).to be_successful
      expect(response.body).to match("PD Summary")
      expect(response.body).to match("New PET")
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      result = create(:pd_pet_result, patient:)
      get edit_patient_pd_pet_result_path(patient, result)

      expect(response).to be_successful
      expect(response.body).to match("PD Summary")
      expect(response.body).to match("Edit PET")
    end
  end

  describe "DELETE destroy" do
    it "soft deletes a pet result" do
      pet = create(:pd_pet_result, patient:)
      delete patient_pd_pet_result_path(patient, pet)

      expect(response).to be_redirect
      expect(pet.reload.deleted_at).to be_present
      expect(patient.pet_results.count).to eq(0) # soft deleted
    end
  end
end
