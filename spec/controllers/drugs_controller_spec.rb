require 'rails_helper'

RSpec.describe DrugsController, :type => :controller do
  describe "DELETE to destroy" do
    it "returns http success" do
      drug = FactoryGirl.create(:drug)
      delete :destroy, id: drug.id
      drug.reload
      expect(drug.deleted_at).not_to be nil
      expect(response).to have_http_status(:found)
    end
  end

  describe "GET #new" do

    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end

  end

end
