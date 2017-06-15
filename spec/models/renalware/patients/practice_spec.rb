require "rails_helper"

module Renalware::Patients
  describe Practice, type: :model do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :address }
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to have_many(:practice_memberships) }
    it { is_expected.to have_many(:primary_care_physicians).through(:practice_memberships) }
    it_behaves_like "a Paranoid model"
  end
end
