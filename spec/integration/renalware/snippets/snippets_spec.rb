# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Snippet management", type: :request do
  let(:user) { Renalware::Snippets.cast_user(@current_user) }

  describe "GET index" do
    it "responds successfully" do
      get snippets_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end

  describe "GET new" do
    it "responds with a form" do
      get new_snippet_path

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "successfully and creates a new snippet" do
        headers = { "HTTP_REFERER" => "/" }
        params = { snippet: { title: "title", body: "Body" } }

        post(snippets_path, params: params, headers: headers)

        follow_redirect!

        expect(response).to have_http_status(:success)
        expect(user.snippets.count).to eq(1)
        snippet = user.snippets.last
        expect(snippet.body).to eq(params[:snippet][:body])
        expect(snippet.title).to eq(params[:snippet][:title])
      end
    end
    context "with invalid params" do
      it "responds with a form" do
        headers = { "HTTP_REFERER" => "/" }
        params = { snippet: { title: "", body: "" } }

        post(snippets_path, params: params, headers: headers)

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      snippet = create(:snippet, author: user)
      get edit_snippet_path(snippet)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATH update" do
    context "with valid params" do
      it "updates snippet and redirects to #index" do
        snippet = create(:snippet, author: user)
        headers = { "HTTP_REFERER" => "/" }

        params = { snippet: { title: "title1", body: "Body1" } }

        patch snippet_path(snippet, params: params, headers: headers)

        follow_redirect!

        snippet.reload
        expect(response).to have_http_status(:success)
        expect(snippet.body).to eq(params[:snippet][:body])
        expect(snippet.title).to eq(params[:snippet][:title])
      end
    end
    context "with invalid params" do
      it "renders a form" do
        snippet = create(:snippet, author: user)
        headers = { "HTTP_REFERER" => "/" }

        params = { snippet: { title: "", body: "" } }

        patch snippet_path(snippet, params: params, headers: headers)

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
    end
  end
end
