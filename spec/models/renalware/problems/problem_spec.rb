require "rails_helper"

module Renalware::Problems
  describe Problem, type: :model do
    it { is_expected.to belong_to(:patient).touch(true) }
    it { should validate_presence_of :patient }
    it { should validate_presence_of :description }
  end
end
