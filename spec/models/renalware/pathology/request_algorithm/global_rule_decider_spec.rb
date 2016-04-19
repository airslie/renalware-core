require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::GlobalRuleDecider do
  let(:patient) { create(:patient) }
  let(:observation_description_id) { rand(100) }
  let(:frequency) { "Always" }
  let(:global_rule) do
    create(
      :pathology_request_algorithm_global_rule,
      observation_description_id: observation_description_id,
      frequency: frequency
    )
  end

  let(:global_rule_decider) { described_class.new(patient, global_rule) }

  describe "#observation_required?" do
    before do
      allow(global_rule_decider).to receive(:observation_required_from_param?)
        .and_return(observation_required_from_param)
      allow(global_rule_decider).to receive(:observation_required_from_frequency?)
        .and_return(observation_required_from_frequency)
    end

    subject { global_rule_decider.observation_required? }

    context "param/frequency = true/true" do
      let(:observation_required_from_param) { true }
      let(:observation_required_from_frequency) { true }
      it { is_expected.to eq(true) }
    end

    context "param/frequency = true/false" do
      let(:observation_required_from_param) { true }
      let(:observation_required_from_frequency) { false }
      it { is_expected.to eq(false) }
    end

    context "param/frequency = false/false" do
      let(:observation_required_from_param) { false }
      let(:observation_required_from_frequency) { false }
      it { is_expected.to eq(false) }
    end
  end

  describe "#observation_required_from_param?" do
    let(:param_type_object) do
      double(Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult)
    end
    let(:test_required) { double }

    before do
      allow(Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult)
        .to receive(:new).and_return(param_type_object)
      allow(param_type_object).to receive(:patient_requires_test?).and_return(test_required)
    end

    subject { global_rule_decider.send(:observation_required_from_param?) }

    it { is_expected.to eq(test_required) }
  end

  describe "#observation_required_from_frequency?" do
    before do
      allow(global_rule_decider).to receive(:last_observation).and_return(last_observation)
    end

    subject { global_rule_decider.send(:observation_required_from_frequency?) }

    context "last_observation is nil" do
      let(:last_observation) { nil }
      it { is_expected.to eq(true) }
    end

    context "last_observation is not nil" do
      let(:date_today) { Date.parse("2016-04-18")} # Monday 18th April (12:30)
      let(:observed_at) { Time.new(2016, 4, 17, 12, 30, 0, "+01:00") } # Sunday 17th April (12:30)

      let(:last_observation) do
        double(Renalware::Pathology::Observation, observed_at: observed_at)
      end

      before do
        allow(Date).to receive(:today).and_return(date_today)
      end

      context "frequency == 'Always'" do
        it { is_expected.to eq(true) }
      end

      context "frequency == 'Once'" do
        let(:frequency) { "Once" }
        it { is_expected.to eq(false) }
      end

      context "frequency == 'Weekly'" do
        let(:frequency) { "Weekly" }

        context "last_observed_at 6 days ago" do
          # Tuesday 12th April (23:59)
          let(:observed_at) { Time.new(2016, 4, 12, 0, 0, 0, "+01:00") }
          it { is_expected.to eq(false) }
        end

        context "last_observed_at 7 days ago" do
          # Monday 11th April (00:00)
          let(:observed_at) { Time.new(2016, 4, 11, 23, 59, 0, "+01:00") }
          it { is_expected.to eq(true) }
        end
      end

      context "frequency == 'Monthly'" do
        let(:frequency) { "Monthly" }

        context "last_observed_at 27 days ago" do
          # Tuesday 22nd March (23:59)
          let(:observed_at) { Time.new(2016, 3, 22, 0, 0, 0, "+01:00") }
          it { is_expected.to eq(false) }
        end

        context "last_observed_at 28 days ago" do
          # Monday 21rst March (00:00)
          let(:observed_at) { Time.new(2016, 3, 21, 23, 59, 0, "+01:00") }
          it { is_expected.to eq(true) }
        end
      end
    end
  end

  describe "#last_observation" do
    pending
  end
end
