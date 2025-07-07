RSpec.describe Renalware::Clinics::TimelineItem do
  subject(:item) { described_class.new(model.id, order_date) }

  let(:order_date) { Time.zone.now }
  let(:model) { create(:clinic_visit) }

  it "returns correct data for timeline" do
    expect(item.id).to eq model.id
    expect(item.date).to eq order_date

    expect(item.type).to eq "Clinic Visit"
    expect(item.description).to eq model.clinic.name
    expect(item.detail).to be_blank
    expect(item.created_by).to eq model.created_by.full_name
  end
end
