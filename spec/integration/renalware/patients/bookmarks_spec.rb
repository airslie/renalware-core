# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Managing bookmarks", type: :request do
  let(:user) { @current_user }
  let(:patient) { create(:patient, by: user) }

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new bookmark" do
        headers = { "HTTP_REFERER" => "/" }
        params = {
          patients_bookmark: {
            urgent: true,
            notes: "Abc"
          }
        }

        post(patient_bookmarks_path(patient), params: params, headers: headers)
        expect(response).to have_http_status(:redirect)

        bookmark = Renalware::Patients::Bookmark.find_by(patient_id: patient.id)

        expect(bookmark).not_to be_nil
        expect(bookmark.urgent).to eq(true)
        expect(bookmark.notes).to eq("Abc")
        follow_redirect!
        expect(response).to have_http_status(:success)
      end

      it "does not create and implies success if the bookmark already exists" do
        headers = { "HTTP_REFERER" => "/" }
        params = {
          patients_bookmark: {
            urgent: true,
            notes: "A note",
            user_id: @current_user.id
          }
        }

        attributes = params[:patients_bookmark].merge!(patient_id: patient.id)
        extant_bookmark = Renalware::Patients::Bookmark.create(attributes)

        post(patient_bookmarks_path(patient), params: params, headers: headers)
        expect(response).to have_http_status(:redirect)

        bookmark = Renalware::Patients::Bookmark.find_by(attributes)

        expect(bookmark).to eq(extant_bookmark)
        follow_redirect!
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE destroy" do
    let(:bookmark) do
      create(:patients_bookmark,
             user: Renalware::Patients.cast_user(user),
             patient: patient)
    end

    it "soft deletes the bookmark" do
      headers = { "HTTP_REFERER" => "/" }
      delete bookmark_path(bookmark), headers: headers
      expect(response).to have_http_status(:redirect)
      expect(Renalware::Patients::Bookmark).not_to exist(id: bookmark.id)
    end

    it "does not baulk if the bookmark has already been deleted" do
      bookmark.destroy!
      expect(Renalware::Patients::Bookmark).not_to exist(id: bookmark.id)
      headers = { "HTTP_REFERER" => "/" }
      delete bookmark_path(bookmark), headers: headers
      expect(response).to have_http_status(:redirect)
      expect(Renalware::Patients::Bookmark).not_to exist(id: bookmark.id)
    end
  end
end
