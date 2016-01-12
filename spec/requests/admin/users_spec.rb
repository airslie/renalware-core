require "rails_helper"

RSpec.describe "Managing Users", type: :request do
  let(:user) { create(:user, :clinician) }

  describe "GET index" do
    it "responds with a list" do
      get admin_users_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_admin_user_path(user)

      expect(response).to have_http_status(:success)
    end

    context "when editing itself" do
      it "redirects to the list" do
        get edit_admin_user_path(@current_user)

        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "PATCH update" do
    context "given valid attributes" do
      it "updates a record" do
        attributes = { approved: !user.approved, role_ids: user.role_ids }
        patch admin_user_path(user), user: attributes

        expect(response).to have_http_status(:redirect)
        expect(Renalware::User.exists?(id: user.id, approved: !user.approved)).to be_truthy

        follow_redirect!

        expect(response).to have_http_status(:success)
      end
    end

    context "given invalid attributes" do
      it "responds with a form" do
        attributes = { approved: true, role_ids: [] }
        patch admin_user_path(user), user: attributes

        expect(response).to have_http_status(:success)
        expect(response.body).to include("<form")
      end
    end
  end
end
