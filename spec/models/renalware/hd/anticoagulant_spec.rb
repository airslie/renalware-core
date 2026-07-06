module Renalware::HD
  describe Anticoagulant do
    subject { build(:hd_anticoagulant) }

    it_behaves_like "a Paranoid model"

    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:code) }
  end
end
