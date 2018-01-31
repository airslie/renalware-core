require "rails_helper"

describe Renalware::Clinical::HeaderPresenter do
  include PathologySpecHelper
  subject(:presenter) { described_class.new(patient) }

  let(:patient) { build(:patient) }

  it { is_expected.to respond_to(:hgb) }

  describe "pathology" do
    it "returns most recent results by delehating to the patient's current obs set" do
      value = "1.11"
      date = Time.zone.now.to_date
      descriptions = create_descriptions(%w(HGB PLT))
      create_observations(::Renalware::Pathology.cast_patient(patient), descriptions, result: value)

      expect(presenter.pathology.hgb_result).to eq(value)
      expect(presenter.pathology.hgb_observed_at).to eq(date)

      expect(presenter.pathology.plt_result).to eq(value)
      expect(presenter.pathology.plt_observed_at).to eq(date)
    end
  end
end
