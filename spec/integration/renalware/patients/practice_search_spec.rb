require "rails_helper"

RSpec.describe "Changing a patient's GP (primary care physician)", type: :request do
  describe "GET show" do
    context "when there is a match" do
      it "responds with json containing the practice/s when searching by practice name" do
        create(:practice, name: "Harpenden").address.update(postcode: "TW20 8AP")
        practice = create(:practice, name: "St. John's Wood")

        get search_patients_practices_path(params: { q: "wood" }, format: :json)

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq(:json)
        expect(JSON.parse(response.body)).to eq([{ "id" => practice.id, "name" => practice.name }])
      end

      it "responds with json containing the practice/s when searching by practice postcode" do
        create(:practice, name: "Harpenden").address.update(postcode: "TW20 8AP")
        practice = create(:practice, name: "St. John's Wood")
        practice.address.update(postcode: "NW1 1AA")

        get search_patients_practices_path(params: { q: "NW1 1AA" }, format: :json)

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq(:json)
        expect(JSON.parse(response.body)).to eq([{ "id" => practice.id, "name" => practice.name }])
      end
    end

    context "when there is no match" do
      it "responds with an e,pty array as json" do
        get search_patients_practices_path(params: { q: "wood" }, format: :json)

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq(:json)
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
end
