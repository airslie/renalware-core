describe "Heidi preparation" do
  around do |example|
    original = Renalware.config.heidi_enabled
    example.run
  ensure
    Renalware.config.heidi_enabled = original
  end

  describe "GET /heidi/preparation" do
    it "renders a browser-tab holding page while Heidi is prepared" do
      get heidi_preparation_path

      expect(response).to be_successful
      expect(response.body).to include("Preparing Heidi")
      expect(response.body).to include(
        "Renalware is saving the clinic visit and creating the Heidi session."
      )
    end

    it "returns not found when Heidi is disabled" do
      Renalware.config.heidi_enabled = false

      get heidi_preparation_path

      expect(response).to have_http_status(:not_found)
    end
  end
end
