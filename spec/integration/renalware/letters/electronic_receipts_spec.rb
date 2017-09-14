require "rails_helper"

RSpec.describe "View a user's read/unread electronic ccs", type: :request do

  describe "GET unread" do
    it "responds successfully" do
      get unread_letters_electronic_receipts_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:unread)
    end
  end

  describe "GET read" do
    it "responds successfully" do
      get read_letters_electronic_receipts_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:read)
    end
  end

  describe "GET sent" do
    it "responds successfully" do
      get sent_letters_electronic_receipts_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:sent)
    end
  end
end
