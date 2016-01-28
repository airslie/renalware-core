require 'rails_helper'
require_dependency "models/renalware/concerns/personable"

module Renalware
  describe Doctor, type: :model do
    subject { create(:doctor) }

    it_behaves_like 'Personable'

    it { should validate_uniqueness_of :code }
    it { should validate_presence_of :practitioner_type }
  end
end
