require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::PatientRule do
  it { is_expected.to validate_presence_of(:lab) }
  it { is_expected.to validate_presence_of(:test_description) }
  it { is_expected.to validate_presence_of(:frequency_type) }
  it { is_expected.to validate_presence_of(:patient_id) }
  it do
    is_expected.to validate_inclusion_of(:frequency_type)
      .in_array(Renalware::Pathology::RequestAlgorithm::FREQUENCIES)
  end

  let(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }

  subject(:patient_rule) do
    create(
      :pathology_request_algorithm_patient_rule,
      patient: patient,
      start_date: Date.parse("2016-04-19"),
      end_date: Date.parse("2016-04-21"),
      frequency_type: "Always"
    )
  end

  describe "#required_for_patient?" do
    context "given today is not within the patient_rule's start/end date range" do
      before do
        allow(Date).to receive(:current).and_return(Date.parse("2016-04-22")).once
        patient_rule.last_observed_at = nil
      end

      it { expect(patient_rule).not_to be_required }
    end

    context "given today is within the patient_rule's start/end date range" do
      before do
        allow(Date).to receive(:current).and_return(Date.parse("2016-04-20")).once
      end

      context "given the patient was not previously observed" do
        before do
          patient_rule.last_observed_at = nil
        end

        it { expect(patient_rule).to be_required }
      end

      context "given the patient was previously observed" do
        before do
          patient_rule.last_observed_at = Date.parse("2016-04-19")
        end

        it { expect(patient_rule).to be_required }
      end
    end
  end
end
