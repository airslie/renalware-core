require 'rails_helper'

module Renalware
  describe Doctor, type: :model do
    subject { create(:doctor) }

    it_behaves_like 'Personable'

    it { should belong_to :address }
    it { should have_many :letters }

    it { should validate_uniqueness_of :code }
    it { should validate_presence_of :practitioner_type }
  end
end