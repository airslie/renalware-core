require "rails_helper"

RSpec.describe "Searching letter descriptions", type: :request do
  include JsonHelpers

  let(:description) { create(:letter_description) }

  describe "GET search" do
    context "no entries matching" do
      it "returns empty set" do
        search("this is not found")
        expect(json_response.size).to eq(0)
      end
    end

    context "full description text" do
      it "returns matching entries" do
        search(description.text)
        expect(json_response.size).to eq(1)
      end
    end

    context "beginning of the description text" do
      it "returns matching entries" do
        search(description.text.split.first)
        expect(json_response.size).to eq(1)
      end
    end

    context "end of the description text" do
      it "returns matching entries" do
        search(description.text.split.last)
        expect(json_response.size).to eq(1)
      end
    end
  end

  private

  def search(term)
    get search_letters_descriptions_path(term: term), format: :json

    expect(response).to be_success
  end
end
