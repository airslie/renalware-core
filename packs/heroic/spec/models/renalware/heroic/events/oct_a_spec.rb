# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  RSpec.describe Events::OctA do
    describe "#document" do
      subject { described_class.new.document }

      it { is_expected.to respond_to(:diabetic_retinopathy) }

      %i(
        visit_number
        skeletonized_vessel_density_continuous
        fractal_dimension_continuous
        vessel_diameter_index_continuous
        average_vessel_calibre_continuous
        foveal_avascular_zone_continuous
        perifoveal_interpapillary_area_continuous
        number_of_microaneurysms
      ).each do |attr_name|
        it { is_expected.to validate_numericality_of(attr_name) }
      end
    end
  end
end
