require "rails_helper"

module Renalware::Patients
  describe Practice, type: :model do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :address }
    it { is_expected.to validate_presence_of :code }
  end
end
