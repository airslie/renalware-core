# frozen_string_literal: true

require "rails_helper"

describe Renalware::HD::ProtocolPresenter do
  include PathologySpecHelper
  describe "methods" do
    subject(:presenter) { described_class.new(nil, nil) }

    let(:patient) { nil }

    it { is_expected.to respond_to(:preference_set) }
    it { is_expected.to respond_to(:access) }
    it { is_expected.to respond_to(:sessions) }
    it { is_expected.to respond_to(:patient_title) }
    it { is_expected.to respond_to(:prescriptions) }
    it { is_expected.to respond_to(:recent_pathology) }
  end

  describe "#prescriptions" do
    it "returns only the patient's prescriptions that should be administered on HD" do
      patient = create(:hd_patient)
      create(:prescription, patient: patient, administer_on_hd: true)
      create(:prescription, patient: patient, administer_on_hd: false)
      presenter = described_class.new(patient, nil)

      presenter.prescriptions
      expect(presenter.prescriptions.length).to eq(1)
      expect(presenter.prescriptions.first.administer_on_hd).to eq(true)
    end
  end

  describe "#recent_pathology" do
    context "when the patient has recent pathology" do
      it "returns the current_observation_set.values hash" do
        # Because the AllObservationCodes singleton might already have been instantiated
        # and hanging onto a previous collection of observation codes, reset it
        Singleton.__init__(Renalware::Pathology::AllObservationCodes)
        descriptions = create_descriptions(%w(HGB PLT))
        patient = create(:pathology_patient)

        time = Time.zone.parse("2017-12-12 01:01:01")

        # This creates two observations and a pg trigger will update patient.current_observation_set
        create_observations(patient,
                            descriptions,
                            observed_at: time,
                            result: 1)

        presenter = described_class.new(patient, nil)

        expect(presenter.recent_pathology.hgb_result).to eq("1")
        expect(presenter.recent_pathology.hgb_observed_at).to eq(time.to_date)
        expect(presenter.recent_pathology.plt_result).to eq("1")
        expect(presenter.recent_pathology.plt_observed_at).to eq(time.to_date)
      end
    end
  end
  context "when the patient has no pathology" do
    it "returns an empty current_observation_set so eg a #hgb_result call will not fail" do
      # Because the AllObservationCodes singleton might already have been instantiated
      # and hanging onto a previous collection of observation codes, reset it
      Singleton.__init__(Renalware::Pathology::AllObservationCodes)
      # Important - we need to create the relevant observation descriptions e.g. HGB before we can
      # try and access it on the current_observations_set.values hash (eg #hgb_result) which
      # uses .method_missing to dynamically find the relevant result.
      create_descriptions(%w(HGB PLT))

      patient = create(:pathology_patient)
      presenter = described_class.new(patient, nil)

      expect(presenter.recent_pathology.hgb_result).to eq(nil)
      expect(presenter.recent_pathology.hgb_observed_at).to eq(nil)
      expect(presenter.recent_pathology.plt_result).to eq(nil)
      expect(presenter.recent_pathology.plt_observed_at).to eq(nil)
    end
  end
end
