require "rails_helper"

module Renalware::Problems
  describe Problem, type: :model do
    it_behaves_like "a Paranoid model"
    it_behaves_like "an Accountable model"
    it { is_expected.to belong_to(:patient).touch(true) }
    it { is_expected.to validate_presence_of :patient }
    it { is_expected.to validate_presence_of :description }
  end
end
