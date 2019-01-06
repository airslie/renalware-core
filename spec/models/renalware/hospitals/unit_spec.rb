# frozen_string_literal: true

require "rails_helper"

module Renalware::Hospitals
  describe Unit, type: :model do
    it { is_expected.to validate_presence_of(:hospital_centre) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:unit_code) }
    it { is_expected.to validate_presence_of(:renal_registry_code) }
    it { is_expected.to validate_presence_of(:unit_type) }
    it { is_expected.to have_many(:wards) }
  end
end
