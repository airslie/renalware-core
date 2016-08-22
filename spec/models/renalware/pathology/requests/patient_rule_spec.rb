require "rails_helper"

describe Renalware::Pathology::Requests::PatientRule do
  it { is_expected.to validate_presence_of(:lab) }
  it { is_expected.to validate_presence_of(:test_description) }
  it { is_expected.to validate_presence_of(:frequency_type) }
  it { is_expected.to validate_presence_of(:patient_id) }
  it do
    is_expected.to validate_inclusion_of(:frequency_type)
      .in_array(Renalware::Pathology::Requests::Frequency.all_names)
  end

  let(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }

  subject(:patient_rule) do
    create(
      :pathology_requests_patient_rule,
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
      end

      it { expect(patient_rule).not_to be_required }
    end

    context "given today is within the patient_rule's start/end date range" do
      before do
        allow(Date).to receive(:current).and_return(Date.parse("2016-04-20")).once
      end

      context "given the patient was not previously observed" do
        it { expect(patient_rule).to be_required }
      end

      context "given the patient was previously observed" do
        let(:observed_on) { Date.parse("2016-04-19") }
        let!(:clinic) { create(:clinic) }
        let!(:patient) { create(:pathology_patient) }
        let!(:consultant) { create(:pathology_consultant) }
        let!(:request) do
          create(
            :pathology_requests_request,
            clinic: clinic,
            patient: patient,
            consultant: consultant,
            created_at: observed_on
          )
        end

        it { expect(patient_rule).to be_required }
      end
    end
  end
end
