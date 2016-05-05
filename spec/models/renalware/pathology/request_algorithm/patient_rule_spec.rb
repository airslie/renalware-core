require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::PatientRule do
  it { is_expected.to be_an ActiveRecord::Base }

  it { is_expected.to validate_presence_of(:lab) }
  it { is_expected.to validate_presence_of(:test_description) }
  it { is_expected.to validate_presence_of(:frequency) }
  it { is_expected.to validate_presence_of(:patient_id) }
  it do
    is_expected.to validate_inclusion_of(:frequency)
      .in_array(Renalware::Pathology::RequestAlgorithm::PatientRule::FREQUENCIES)
  end

  let(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }
  let(:last_observed_at) { nil }
  let(:start_date) { nil }
  let(:end_date) { nil }
  subject do
    create(
      :pathology_request_algorithm_patient_rule,
      patient: patient,
      last_observed_at: last_observed_at,
      start_date: start_date,
      end_date: end_date
    )
  end

  describe "#required_for_patient?" do
    context "not within range of start/end date" do
      before do
        allow(subject).to receive(:today_within_range?).and_return(false)
      end

      it { expect(subject.required?).to eq(false) }
    end

    context "within range of start/end date" do
      before do
        allow(subject).to receive(:today_within_range?).and_return(true)
      end

      context "last_observed_at nil" do
        it { expect(subject.required?).to eq(true) }
      end

      context "last_observed_at not nil" do
        let(:date_today) { Date.parse("2016-04-20") }
        let(:last_observed_at) { Date.parse("2016-04-19") }
        let(:required_from_frequency) { double }

        before do
          allow(Date).to receive(:current).and_return(date_today)
          allow(subject).to receive(:required_from_frequency?)
            .and_return(required_from_frequency)
        end

        it do
          subject.required?
          expect(Date).to have_received(:current)
        end
        it do
          subject.required?
          expect(subject).to have_received(:required_from_frequency?)
            .with(subject.frequency, 1)
        end
        it { expect(subject.required?).to eq(required_from_frequency) }
      end
    end
  end
end
