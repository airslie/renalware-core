require "rails_helper"

describe Renalware::Pathology::Requests::RequestQuery do
  let(:params) { {} }
  let(:request_query) { Renalware::Pathology::Requests::RequestQuery.new(params) }

  describe "#call" do
    let!(:request_new) { create(:pathology_requests_request, created_at: Time.current - 1.day) }
    let!(:request_old) { create(:pathology_requests_request, created_at: Time.current - 2.day) }

    subject(:request_query) { Renalware::Pathology::Requests::RequestQuery.new(params) }

    context "with no filter given in the params" do
      it "shows all requests sorted by the default sort value" do
        expect(request_query.call.map(&:id)).to eq([request_new.id, request_old.id])
      end
    end

    context "with a filter given in the params" do
      let(:date) { request_old.created_at.to_date.strftime("%d-%m-%Y") }
      let(:params) { { created_on_eq: date } }

      it "filters the requests" do
        expect(request_query.call.map(&:id)).to eq([request_old.id])
      end
    end
  end
end
