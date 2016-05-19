require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::Frequency::Once do
  subject(:frequency) { Renalware::Pathology::RequestAlgorithm::Frequency::Once.new }

  describe "#exceeds?" do
    subject(:exceeds?) { frequency.exceeds?(1) }

    it { expect(exceeds?).to be_falsey }
  end

  describe "#once?" do
    it { expect(frequency.once?).to be_truthy }
  end
end

describe Renalware::Pathology::RequestAlgorithm::Frequency::Always do
  subject(:frequency) { Renalware::Pathology::RequestAlgorithm::Frequency::Always.new }

  describe "#exceeds?" do
    subject(:exceeds?) { frequency.exceeds?(1) }

    it { expect(exceeds?).to be_truthy }
  end

  describe "#once?" do
    it { expect(frequency.once?).to be_falsey }
  end
end

describe Renalware::Pathology::RequestAlgorithm::Frequency::Weekly do
  subject(:frequency) { Renalware::Pathology::RequestAlgorithm::Frequency::Weekly.new }

  describe "#exceeds?" do
    subject(:exceeds?) { frequency.exceeds?(days_ago) }

    context "given the days ago is 6" do
      let(:days_ago) { 6 }

      it { expect(exceeds?).to be_falsey }
    end

    context "given the days ago is 7" do
      let(:days_ago) { 7 }

      it { expect(exceeds?).to be_truthy }
    end
  end

  describe "#once?" do
    it { expect(frequency.once?).to be_falsey }
  end
end

describe Renalware::Pathology::RequestAlgorithm::Frequency::Monthly do
  subject(:frequency) { Renalware::Pathology::RequestAlgorithm::Frequency::Monthly.new }

  describe "#exceeds?" do
    subject(:exceeds?) { frequency.exceeds?(days_ago) }

    context "given the days ago is 27" do
      let(:days_ago) { 27 }

      it { expect(exceeds?).to be_falsey }
    end

    context "given the days ago is 28" do
      let(:days_ago) { 28 }

      it { expect(exceeds?).to be_truthy }
    end
  end

  describe "#once?" do
    it { expect(frequency.once?).to be_falsey }
  end
end
