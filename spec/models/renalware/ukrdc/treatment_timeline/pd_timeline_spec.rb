# frozen_string_literal: true

require "rails_helper"

module Renalware
  module UKRDC
    module TreatmentTimeline
      describe Generators::PDTimeline do
        include PatientsSpecHelper
        subject(:generator) { described_class.new(modality) }

        let(:user) { create(:user) }
        let(:pd_ukrdc_modality_code) { create(:ukrdc_modality_code, :pd) }
        let(:apd_ukrdc_modality_code) { create(:ukrdc_modality_code, :apd) }
        let(:capd_ukrdc_modality_code) { create(:ukrdc_modality_code, :capd) }
        let(:pd_mod_desc) { create(:pd_modality_description) }
        let(:modality) do
          set_modality(
            patient: patient,
            modality_description: pd_mod_desc,
            by: user
          )
        end

        def create_regime(start_date:, end_date: nil, type: :apd_regime)
          regime = build(type,
                         add_hd: false,
                         patient: patient,
                         start_date: start_date,
                         end_date: end_date)
          regime.bags << build(:pd_regime_bag, :everyday)
          regime.save!
          regime
        end

        context "when the patient has the PD modality" do
          let(:patient) { create(:pd_patient) }

          context "when they have no PD regime" do
            it "creates one Treatment with a generic UKRDC treatment code of PD" do
              pd_ukrdc_modality_code

              expect {
                generator.call
              }.to change(UKRDC::Treatment, :count).by(1)

              expect(UKRDC::Treatment.first).to have_attributes(
                patient_id: patient.id,
                pd_regime_id: nil,
                modality_code: pd_ukrdc_modality_code,
                started_on: modality.started_on,
                ended_on: modality.ended_on,
                modality_id: modality.id
              )
            end
          end

          context "when they have a APD regime active at the point of modality creation" do
            it "creates uses the regime type when creating the Treatment" do
              apd_ukrdc_modality_code
              create_regime(start_date: 5.years.ago, end_date: nil, type: :apd_regime)

              expect {
                generator.call
              }.to change(UKRDC::Treatment, :count).by(1)

              expect(UKRDC::Treatment.first).to have_attributes(
                modality_code: apd_ukrdc_modality_code
              )
            end
          end

          context "when they have a CAPD regime active at the point of modality creation" do
            it "creates uses the regime type creating the Treatment" do
              capd_ukrdc_modality_code
              create_regime(start_date: 5.years.ago, end_date: nil, type: :capd_regime)

              expect {
                generator.call
              }.to change(UKRDC::Treatment, :count).by(1)

              expect(UKRDC::Treatment.first).to have_attributes(
                modality_code: capd_ukrdc_modality_code
              )
            end
          end

          context "when they have an APD regime created within 2 wks of the modality start date" do
            it "creates uses the regime type when creating the Treatment" do
              apd_ukrdc_modality_code
              create_regime(start_date: Time.zone.now + 13.days, end_date: nil, type: :apd_regime)

              expect {
                generator.call
              }.to change(UKRDC::Treatment, :count).by(1)

              expect(UKRDC::Treatment.first).to have_attributes(
                modality_code: apd_ukrdc_modality_code
              )
            end
          end

          context "when they have an APD regime created after 2 weeks of the modality start date" do
            it "creates uses the default PD type for the initial Treatment and creates "\
               "a futher Treatment to register the change from PD to APD" do
              pd_ukrdc_modality_code
              apd_ukrdc_modality_code
              apd_regime = create_regime(
                start_date: Time.zone.now + 2.months,
                end_date: nil,
                type: :apd_regime
              )

              expect {
                generator.call
              }.to change(UKRDC::Treatment, :count).by(2)

              treatments = UKRDC::Treatment.order(started_on: :asc)
              p treatments.map(&:started_on)
              expect(treatments[0]).to have_attributes(
                modality_code: pd_ukrdc_modality_code,
                started_on: modality.started_on,
                ended_on: apd_regime.start_date
              )
              expect(treatments[1]).to have_attributes(
                modality_code: apd_ukrdc_modality_code,
                started_on: apd_regime.start_date,
                ended_on: nil
              )
            end
          end
        end
      end
    end
  end
end
