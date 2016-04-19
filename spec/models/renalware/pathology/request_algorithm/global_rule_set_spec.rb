require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::GlobalRuleSet do
  it { is_expected.to validate_presence_of(:observation_description_id) }
  it { is_expected.to validate_presence_of(:regime) }
  it do
    is_expected.to validate_inclusion_of(:regime)
      .in_array(described_class::REGIMES)
  end
  it do
    is_expected.to validate_inclusion_of(:frequency)
      .in_array(described_class::FREQUENCIES)
  end

  let(:frequency) { "Always" }
  let(:global_rule_set) do
    create(
      :pathology_request_algorithm_global_rule_set,
      frequency: frequency
    )
  end

  describe "#required_for_patient?" do
    let(:patient) { create(:patient) }

    before do
      allow(global_rule_set).to receive(:get_last_observation_for_patient)
        .and_return(last_observation)
    end

    subject { global_rule_set.required_for_patient?(patient) }

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

  describe "#get_last_observation_for_patient" do
    let!(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }
    let!(:observation_description) { create(:pathology_observation_description) }
    let!(:observation_request_1) { create(:pathology_observation_request, patient: patient) }
    let!(:observation_1) do
      create(
        :pathology_observation,
        request: observation_request_1,
        description: observation_description,
        observed_at: Time.now - 1.week
      )
    end
    let!(:observation_request_2) { create(:pathology_observation_request, patient: patient) }
    let!(:observation_2) do
      create(
        :pathology_observation,
        request: observation_request_2,
        description: observation_description,
        observed_at: Time.now - 2.week
      )
    end
    let!(:observation_3) { create(:pathology_observation, request: observation_request_2) }

    let(:global_rule_set) do
      create(
        :pathology_request_algorithm_global_rule_set,
        frequency: frequency,
        observation_description_id: observation_description.id
      )
    end

    subject { global_rule_set.send(:get_last_observation_for_patient, patient) }

    it { is_expected.to eq(observation_1) }
  end
end
