require 'rails_helper'

module Renalware
  RSpec.describe FluidDescription, :type => :model do
     it { should have_many(:peritonitis_episodes) }
  end
end