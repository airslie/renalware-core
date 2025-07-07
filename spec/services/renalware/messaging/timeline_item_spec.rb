RSpec.describe Renalware::Messaging::TimelineItem do
  subject(:item) { described_class.new(model.id, order_date) }

  let(:order_date) { Time.zone.now }
  let(:model) { create(:internal_message) }

  it "returns correct data for timeline" do
    expect(item.id).to eq model.id
    expect(item.date).to eq order_date

    expect(item.type).to eq "Message"
    expect(item.description).to eq "The subject"
    expect(item.detail).to eq "The body"
    expect(item.created_by).to eq model.author.full_name
  end
end
