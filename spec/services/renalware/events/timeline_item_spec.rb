RSpec.describe Renalware::Events::TimelineItem do
  subject(:item) { described_class.new(model.id, order_date) }

  let(:order_date) { Time.zone.now }
  let(:event_type) { create(:event_type, name: "Simple") }
  let(:model) { create(:simple_event, event_type:) }

  it "returns correct data for timeline" do
    expect(item.id).to eq model.id
    expect(item.date).to eq order_date

    expect(item.type).to eq "Event"
    expect(item.description).to eq model.event_type.name
    # expect(item.detail).to eq ""
    expect(item.created_by).to eq model.created_by.full_name
  end
end
