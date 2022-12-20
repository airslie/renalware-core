# frozen_string_literal: true

require "rails_helper"

describe "Patient Dietetics MDM" do
  let(:patient) { create(:patient) }

  describe "GET show" do
    it "responds successfully" do
      create(:pathology_code_group, name: :dietetics_mdm)

      get patient_dietetics_mdm_path(patient)

      expect(response).to be_successful
    end
  end
end
