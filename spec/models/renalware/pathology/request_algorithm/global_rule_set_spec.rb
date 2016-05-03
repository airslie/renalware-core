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
      frequency: frequency,
      observation_description_id: observation_description.id
    )
  end

  describe "#required_for_patient?" do
    let!(:patient) { create(:patient) }
    let(:pathology_patient) { Renalware::Pathology.cast_patient(patient) }
    let!(:observation_description) { create(:pathology_observation_description) }
    let!(:observation_request) do
      create(:pathology_observation_request, patient: pathology_patient)
    end

    subject { global_rule_set.required_for_patient?(patient) }

    context "last_observation is nil" do
      let(:last_observation) { nil }
      it { is_expected.to eq(true) }
    end

    context "last_observation is not nil" do
      let(:date_today) { Date.parse("2016-04-18")} # Monday 18th April (12:30)

      before do
        allow(Date).to receive(:today).and_return(date_today)
      end

      context "frequency == 'Always'" do
        it { is_expected.to eq(true) }
      end

      context "frequency == 'Once'" do
        let!(:last_observation) do
          create(
            :pathology_observation,
            request: observation_request,
            description: observation_description
          )
        end
        let(:frequency) { "Once" }
        it { is_expected.to eq(false) }
      end

      context "frequency == 'Weekly'" do
        let(:frequency) { "Weekly" }

        context "last_observed_at 6 days ago" do
          # Tuesday 12th April (23:59)
          let!(:last_observation) do
            create(
              :pathology_observation,
              request: observation_request,
              description: observation_description,
              observed_at: Time.new(2016, 4, 12, 0, 0, 0, "+01:00")
            )
          end
          it { is_expected.to eq(false) }
        end

        context "last_observed_at 7 days ago" do
          let!(:last_observation) do
            create(
              :pathology_observation,
              request: observation_request,
              description: observation_description,
              observed_at: Time.new(2016, 4, 11, 23, 59, 0, "+01:00")
            )
          end
          it { is_expected.to eq(true) }
        end
      end

      context "frequency == 'Monthly'" do
        let(:frequency) { "Monthly" }

        context "last_observed_at 27 days ago" do
          # Tuesday 22nd March (23:59)
          let!(:last_observation) do
            create(
              :pathology_observation,
              request: observation_request,
              description: observation_description,
              observed_at: Time.new(2016, 3, 22, 0, 0, 0)
            )
          end
          it { is_expected.to eq(false) }
        end

        context "last_observed_at 28 days ago" do
          let!(:last_observation) do
            create(
              :pathology_observation,
              request: observation_request,
              description: observation_description,
              observed_at: Time.new(2016, 3, 21, 23, 59, 0, "+01:00")
            )
          end
          it { is_expected.to eq(true) }
        end
      end
    end
  end
end
