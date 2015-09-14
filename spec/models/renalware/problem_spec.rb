require 'rails_helper'

module Renalware
  describe Problem, :type => :model do
    it { should belong_to :patient }
  end
end