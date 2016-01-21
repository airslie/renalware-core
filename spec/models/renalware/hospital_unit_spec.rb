require 'rails_helper'

module Renalware
  RSpec.describe HospitalUnit, type: :model do
    it { should validate_presence_of(:hospital) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:unit_code) }
    it { should validate_presence_of(:renal_registry_code) }
    it { should validate_presence_of(:unit_type) }
  end
end
