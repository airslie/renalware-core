require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::FrequencyMethods do
  let(:klass) do
    Class.new do
      include Renalware::Pathology::RequestAlgorithm::FrequencyMethods
    end
  end
  subject { klass.new }

  describe "#required_from_frequency?" do
    context "frequency == 'Always'" do
      let(:frequency) { "Always" }
      let(:days_ago_observed) { 1 }
      it { expect(subject.required_from_frequency?(frequency, days_ago_observed)).to eq(true) }
    end

    context "frequency == 'Once'" do
      let(:frequency) { "Once" }
      let(:days_ago_observed) { 1 }

      it { expect(subject.required_from_frequency?(frequency, days_ago_observed)).to eq(false) }
    end

    context "frequency == 'Weekly'" do
      let(:frequency) { "Weekly" }

      context "last_observed_at 6 days ago" do
        let(:days_ago_observed) { 6 }
        it { expect(subject.required_from_frequency?(frequency, days_ago_observed)).to eq(false) }
      end

      context "last_observed_at 7 days ago" do
        let(:days_ago_observed) { 7 }
        it { expect(subject.required_from_frequency?(frequency, days_ago_observed)).to eq(true) }
      end
    end

    context "frequency == 'Monthly'" do
      let(:frequency) { "Monthly" }

      context "last_observed_at 27 days ago" do
        let(:days_ago_observed) { 27 }
        it { expect(subject.required_from_frequency?(frequency, days_ago_observed)).to eq(false) }
      end

      context "last_observed_at 28 days ago" do
        let(:days_ago_observed) { 28 }
        it { expect(subject.required_from_frequency?(frequency, days_ago_observed)).to eq(true) }
      end
    end
  end
end
