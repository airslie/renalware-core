# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  RSpec.describe Events::Echo do
    describe "#document" do
      subject { described_class.new.document }

      it { is_expected.to respond_to(:valve_pathology) }

      %i(
        visit_number
        la_vol
        lvidd_2d
        ivsd_2d
        pwd_2d
        lv_ed_vol
        ra_area
        rv_diameter
        tapse
        estimated_lvf
        estimated_rvsp
      ).each do |attr_name|
        it { is_expected.to validate_numericality_of(attr_name) }
      end
    end
  end
end
