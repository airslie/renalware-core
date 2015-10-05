require 'rails_helper'

module Renalware
  RSpec.describe ESRF, :type => :model do
    it { should belong_to :patient }
  end
end
