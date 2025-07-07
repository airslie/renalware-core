RSpec.describe Renalware::Letters::TimelineItem do
  subject(:item) { described_class.new(model.id, order_date) }

  let(:order_date) { Time.zone.now }
  let(:model) { create(:draft_letter) }

  it "returns correct data for timeline" do
    expect(item.id).to eq model.id
    expect(item.date).to eq order_date

    expect(item.type).to eq "Letter (draft)"
    expect(item.description).to eq model.topic.text
    expect(item.detail).to eq model.body
    expect(item.created_by).to eq model.created_by.full_name
  end
end
