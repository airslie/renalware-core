RSpec.describe Renalware::Admissions::TimelineItem do
  subject(:item) { described_class.new(model.id, order_date) }

  let(:order_date) { Time.zone.now }
  let(:model) { create(:admissions_admission) }

  it "returns correct data for timeline" do
    expect(item.id).to eq model.id
    expect(item.date).to eq order_date

    expect(item.type).to eq "Admission"
    expect(item.description).to eq "unknown"
    expect(item.detail).to eq model.hospital_ward.name
    expect(item.created_by).to eq model.created_by.full_name
  end
end
