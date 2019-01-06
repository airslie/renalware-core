# frozen_string_literal: true

require "rails_helper"

describe "Searching letter descriptions", type: :request do
  include JsonHelpers

  let!(:other_description) { create(:letter_description, text: "123456789") }
  let(:description) { create(:letter_description) }

  describe "GET search" do
    context "with no entries matching" do
      it "returns empty set" do
        search("this is not found")
        expect(json_response.size).to eq(0)
      end
    end

    context "with full description text" do
      it "returns matching entries" do
        search(description.text)
        expect(json_response.size).to eq(1)
      end
    end

    context "with beginning of the description text" do
      it "returns matching entries" do
        search(description.text.split.first)
        expect(json_response.size).to eq(1)
      end
    end

    context "with end of the description text" do
      it "returns matching entries" do
        search(description.text.split.last)
        expect(json_response.size).to eq(1)
      end
    end
  end

  private

  def search(term)
    get search_letters_descriptions_path(term: term), params: { format: :json }

    expect(response).to be_successful
  end
end
