require 'rails_helper'

module Renalware
  RSpec.describe PatientsHelper, :type => :helper do
    describe "display_pd_menu" do
      before do
        load_modalities(["diabetic", "Renal/Diabetic"], ["livedonor", "Live Donor"], ["PD_CAPD", "PD-CAPD"], ["heartfailure", "Heart Failure"])

        @patient = create(:patient)
        @non_pd_modality = create(:modality, patient: @patient, modality_code: @diabetic, deleted_at: nil)
        @patient.modalities << @non_pd_modality
      end

      context "patient has history of PD" do
        it "should detect PD" do
          @pd_modality = create(:modality, patient: @patient, modality_code: @pd_capd, started_on: Date.parse("2015-05-01"))
          @patient.modalities << @pd_modality

          expect(display_pd_menu(@patient.modalities.with_deleted)).to eq(true)
        end
      end

      context "patient has no history of PD" do
        it "should detect no PD" do
          expect(display_pd_menu(@patient.modalities.with_deleted)).to eq(false)
        end
      end

    end
  end
end