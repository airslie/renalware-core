RSpec.describe Renalware::Modalities::TimelineItem do
  subject(:item) { described_class.new(model.id, order_date) }

  let(:order_date) { Time.zone.now }
  let(:model) { create(:modality) }

  it "returns correct data for timeline" do
    expect(item.id).to eq model.id
    expect(item.date).to eq order_date

    expect(item.type).to eq "Modality Change"
    expect(item.description).to eq model.description.name
    expect(item.detail).to be_blank
    expect(item.created_by).to eq model.created_by.full_name
  end
end
