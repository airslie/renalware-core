require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::PatientRule do
  it { is_expected.to be_an ActiveRecord::Base }

  it { is_expected.to validate_presence_of(:lab) }
  it { is_expected.to validate_presence_of(:test_description) }
  it { is_expected.to validate_presence_of(:frequency) }
  it { is_expected.to validate_presence_of(:patient_id) }
  it do
    is_expected.to validate_inclusion_of(:frequency)
      .in_array(described_class::FREQUENCIES)
  end

  let(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }
  let(:last_tested_at) { nil }
  let(:start_date) { nil }
  let(:end_date) { nil }
  let(:patient_rule) do
    create(
      :pathology_request_algorithm_patient_rule,
      patient: patient,
      last_tested_at: last_tested_at,
      start_date: start_date,
      end_date: end_date
    )
  end

  describe "#required_for_patient?" do
    context 'not within range of start/end date' do
      before do
        allow(patient_rule).to receive(:today_within_range?).and_return(false)
      end

      subject! { patient_rule.required? }

      it { is_expected.to eq(false) }
    end

    context 'within range of start/end date' do
      before do
        allow(patient_rule).to receive(:today_within_range?).and_return(true)
      end

      context 'last_tested_at nil' do
        subject! { patient_rule.required? }
        it { is_expected.to eq(true) }
      end

      context 'last_tested_at not nil' do
        let(:date_today) { Date.parse('2016-04-20') }
        let(:last_tested_at) { Date.parse('2016-04-19') }
        let(:required_from_frequency) { double }

        before do
          allow(Date).to receive(:today).and_return(date_today)
          allow(patient_rule).to receive(:required_from_frequency?)
            .and_return(required_from_frequency)
        end

        subject! { patient_rule.required? }

        it { expect(Date).to have_received(:today) }
        it do
          expect(patient_rule).to have_received(:required_from_frequency?)
            .with(patient_rule.frequency, 1)
        end
        it { is_expected.to eq(required_from_frequency) }
      end
    end
  end

  describe '#today_within_range?' do
    context 'start/end date not present' do
      subject { patient_rule.send(:today_within_range?) }

      it { is_expected.to eq(true) }
    end

    context 'start/end date present and within range' do
      let(:start_date) { Date.today - 1.day }
      let(:end_date) { Date.today + 1.day }

      subject { patient_rule.send(:today_within_range?) }

      it { is_expected.to eq(true) }
    end

    context 'start/end date present and not within range' do
      let(:start_date) { Date.today - 1.day }
      let(:end_date) { Date.today - 2.days }

      subject { patient_rule.send(:today_within_range?) }

      it { is_expected.to eq(false) }
    end
  end
end
