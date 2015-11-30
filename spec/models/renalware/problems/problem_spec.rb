require 'rails_helper'

module Renalware::Problems
  describe Problem, :type => :model do
    it { should belong_to :patient }

    it { should validate_presence_of :patient }
  end
end
