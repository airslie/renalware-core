require "rails_helper"

describe Renalware::Pathology::Requests::RequestQuery do
  let(:params) { {} }
  let(:request_query) { Renalware::Pathology::Requests::RequestQuery.new(params) }

  describe "#call" do
    let!(:clinic_new) { create(:clinic) }
    let!(:patient_new) { create(:pathology_patient) }
    let!(:consultant_new) { create(:pathology_consultant) }
    let!(:request_new) do
      create(
        :pathology_requests_request,
        clinic: clinic_new,
        patient: patient_new,
        consultant: consultant_new,
        created_at: Time.current - 1.day
      )
    end
    let!(:clinic_old) { create(:clinic) }
    let!(:patient_old) { create(:pathology_patient) }
    let!(:consultant_old) { create(:pathology_consultant) }
    let!(:request_old) do
      create(
        :pathology_requests_request,
        clinic: clinic_old,
        patient: patient_old,
        consultant: consultant_old,
        created_at: Time.current - 2.days
      )
    end


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
