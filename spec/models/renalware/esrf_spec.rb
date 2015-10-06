require 'rails_helper'

module Renalware
  RSpec.describe ESRF, :type => :model do
    it { should belong_to :patient }
    it { should validate_presence_of :diagnosed_on }
  end
end
