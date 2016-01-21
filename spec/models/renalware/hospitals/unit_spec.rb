require 'rails_helper'

module Renalware::Hospitals
  RSpec.describe Unit, type: :model do
    it { should validate_presence_of(:hospital_centre) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:unit_code) }
    it { should validate_presence_of(:renal_registry_code) }
    it { should validate_presence_of(:unit_type) }
  end
end
