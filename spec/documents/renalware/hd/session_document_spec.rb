# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe SessionDocument, type: :model do
      describe SessionDocument::Dialysis do
        it do
          expect(subject).to validate_numericality_of(:blood_flow)
            .is_greater_than_or_equal_to(50)
            .is_less_than_or_equal_to(800)
        end

        %i(
          arterial_pressure
          venous_pressure
          fluid_removed
          flow_rate
          machine_urr
          machine_ktv
          litres_processed
          blood_flow
        ).each do |att|
          it { is_expected.to validate_numericality_of(att) }
          it { is_expected.to allow_value("", nil).for(att) }
        end
      end

      describe SessionDocument::Observations, type: :model do
        %i(
          temperature
          weight
          bm_stix
          pulse
        ).each do |att|
          it { is_expected.to validate_numericality_of(att) }
          it { is_expected.to allow_value("", nil).for(att) }
        end
      end

      describe SessionDocument::HDF, type: :model do
        %i(
          subs_fluid_pct
          subs_goal
          subs_rate
          subs_volume
        ).each do |att|
          it { is_expected.to validate_numericality_of(att) }
          it { is_expected.to allow_value("", nil).for(att) }
        end
      end
    end
  end
end
