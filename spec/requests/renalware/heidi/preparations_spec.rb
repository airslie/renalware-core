describe "Heidi preparation" do
  describe "GET /heidi/preparation" do
    it "renders a browser-tab holding page while Heidi is prepared" do
      get heidi_preparation_path

      expect(response).to be_successful
      expect(response.body).to include("Preparing Heidi")
      expect(response.body).to include(
        "Renalware is saving the clinic visit and creating the Heidi session."
      )
    end
  end
end
