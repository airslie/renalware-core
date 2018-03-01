# frozen_string_literal: true

require "rails_helper"

module Renalware
  module PD
    RSpec.describe CreateRegime do
      let(:user) { create(:user) }
      let(:patient) { create(:patient, by: user) }
      let(:bag_type) { create(:bag_type) }
      let(:subject) { CreateRegime.new(patient: patient).call(by: user, params: params) }
      let(:pre_existing_regime) do
        regime = build(:apd_regime,
                       add_hd: false,
                       patient: patient,
                       end_date: nil,
                       start_date: "01-01-2012")
        regime.bags << build(:pd_regime_bag, sunday: false)
        regime.save!
        regime
      end

      describe "#call" do
        context "when params are valid" do
          let(:params) do
            attributes_for(:apd_regime)
              .merge(bags_attributes: {
                       "12345" => {
                         **attributes_for(:pd_regime_bag, bag_type_id: bag_type.id)
                       }
                     })
          end

          it "returns true with the new regime" do
            expect(subject).to be_success
            expect(subject.object).to be_kind_of(Regime)
            expect(subject.object).to be_persisted
          end

          it "makes the new regime current" do
            expect(subject.object).to be_current
          end

          it "terminates the previous regime" do
            expect(pre_existing_regime).to be_current

            expect(subject.object).to be_current
            expect(pre_existing_regime).to be_terminated
            expect(pre_existing_regime.reload.end_date).to eq(subject.object.start_date)
          end
        end

        context "when params are invalid e.g. there are no bags" do
          let(:params) { attributes_for(:apd_regime) } # no bags

          it "returns failure with the unsaved regime" do
            expect(subject).to be_failure
            expect(subject.object).to be_kind_of(Regime)
            expect(subject.object).not_to be_persisted
          end
        end
      end
    end
  end
end
