require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::Frequency::Once do
  subject(:frequency) { Renalware::Pathology::RequestAlgorithm::Frequency::Once.new }

  describe "#exceeds?" do
    it { expect(frequency.exceeds?(1)).to be_falsey }
  end

  describe "#once?" do
    it { expect(frequency.once?).to be_truthy }
  end
end

describe Renalware::Pathology::RequestAlgorithm::Frequency::Always do
  subject(:frequency) { Renalware::Pathology::RequestAlgorithm::Frequency::Always.new }

  describe "#exceeds?" do
    it { expect(frequency.exceeds?(1)).to be_truthy }
  end

  describe "#once?" do
    it { expect(frequency.once?).to be_falsey }
  end
end

describe Renalware::Pathology::RequestAlgorithm::Frequency::Weekly do
  subject(:frequency) { Renalware::Pathology::RequestAlgorithm::Frequency::Weekly.new }

  describe "#exceeds?" do
    context "given the days ago is 6" do
      it { expect(frequency.exceeds?(6)).to be_falsey }
    end

    context "given the days ago is 7" do
      it { expect(frequency.exceeds?(7)).to be_truthy }
    end
  end

  describe "#once?" do
    it { expect(frequency.once?).to be_falsey }
  end
end

describe Renalware::Pathology::RequestAlgorithm::Frequency::Monthly do
  subject(:frequency) { Renalware::Pathology::RequestAlgorithm::Frequency::Monthly.new }

  describe "#exceeds?" do
    context "given the days ago is 27" do
      it { expect(frequency.exceeds?(27)).to be_falsey }
    end

    context "given the days ago is 28" do
      it { expect(frequency.exceeds?(28)).to be_truthy }
    end
  end

  describe "#once?" do
    it { expect(frequency.once?).to be_falsey }
  end
end
