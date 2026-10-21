describe Renalware::Clinical::ProfilePresenter do
  subject(:profile) { described_class.new(patient:, params: {}) }

  let(:patient) { build(:patient) }

  it :aggregate_failures do
    is_expected.to respond_to(:allergies)
    is_expected.to respond_to(:swabs)
  end

  describe "#swabs" do
    let(:patient) { create(:patient, :minimal) }
    let(:event_type) { create(:swab_event_type) }
    let!(:swabs) { create_swabs }

    it "returns the latest ten swabs for this patient" do
      create(:swab, event_type:)

      expect(profile.swabs).to eq(swabs.first(10))
      expect(profile.swabs.first.association(:event_type)).to be_loaded
    end

    it "supports page and per_page parameters" do
      presenter = described_class.new(patient:, params: { page: "2", per_page: "3" })

      expect(presenter.swabs).to eq(swabs.slice(3, 3))
    end

    it "falls back to the default page size when per_page is invalid" do
      presenter = described_class.new(patient:, params: { per_page: "abc" })

      expect(presenter.swabs).to eq(swabs.first(10))
    end

    it "returns an empty collection beyond the last page" do
      presenter = described_class.new(patient:, params: { page: "3" })

      expect(presenter.swabs).to be_empty
    end

    it "treats a non-positive page as the first page" do
      presenter = described_class.new(patient:, params: { page: "0" })

      expect(presenter.swabs).to eq(swabs.first(10))
    end
  end

  def create_swabs
    Array.new(11) do |index|
      create(:swab, patient:, event_type:, date_time: index.days.ago)
    end
  end
end
